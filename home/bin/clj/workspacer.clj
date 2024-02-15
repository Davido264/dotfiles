(ns workspacer
  (:require [workspacer.fetcher :as fetcher]
            [workspacer.open :as open]
            [babashka.process :as process]
            [fancy.table :as table]
            [babashka.cli :as cli]
            [babashka.fs :as fs]
            [clojure.string :as string]
            [clojure.pprint :as pp]
            [workspacer.config-fetcher :as config-fetcher]))

(def config (config-fetcher/get-config))

(defn- parent-name [w]
  (format "%s/%s" (:parent w) (:name w)))

(defn- to-fzf [coll]
  (->> coll
       (reduce (fn [& [p n]] (cond (and (some? p) (some? n)) (string/join "\0" [p n])
                                   :else "")))))

(defn- fzf [& [coll]]
  (let [coll (cond (nil? coll) (to-fzf (map parent-name (fetcher/query config)))
                   :else (to-fzf coll))]
    (-> (process/sh {:in coll :continue true :out :string :err :inherit} "fzf --read0") :out string/trim-newline)))

(defn- prompt-workspaces [& [_name]]
  (if (string/blank? _name) (let [workspaces (fetcher/query config)
                                         name (fzf (map parent-name workspaces))]
                                 (when (string/blank? name) (throw (ex-info "" {})))
                                 (->> workspaces
                                   (filter #(= (parent-name %) name))
                                   (first)))
        (let [workspaces (fetcher/query config _name)]
          (cond (= (count workspaces) 0) nil
                (= (count workspaces) 1) (first workspaces)
                :else (let [
                            _c (fzf (map parent-name workspaces))]
                        (when (string/blank? _c) (throw (ex-info "" {})))
                        (->> workspaces
                             (filter #(= (parent-name %) _c))
                             (first)))))))


(defn ls [args]
  (if (:edn (:opts args)) (pp/pprint (map #(dissoc % :path) (fetcher/query-full-info config)))
    (table/print-table (map #(dissoc % :path) (fetcher/query config)))))

(defn open [args]
  (let [explorer (:explorer (:opts args))
        obsidian (:obsidian (:opts args))
        path (:path (:opts args))
        name (:name (:opts args))
        workspace (prompt-workspaces name)]

    (when (nil? workspace) (throw (ex-info "No workspace found" {})))
    (cond explorer (open/explorer workspace)
          obsidian (open/obsidian workspace)
          path (println (:path workspace))
          :else (open/terminal workspace))))

(defn rm [args]
  (let [name (:name (:opts args))
        workspace (prompt-workspaces name)
        path (:path workspace)]

    (fs/delete-tree path)))

(defn- create-directory [name parent init clone link]
  (let [full-path (fs/path parent name)
        create-git-init (fn []
                          (fs/create-dir full-path)
                          (process/sh {:out :inherit :err :inherit :continue true} (format "git init -q -b main '%s'" full-path)))]

    (cond (not (string/blank? link)) (if (fs/exists? link) (fs/create-sym-link full-path (fs/path link))
                                         (throw (ex-info "Target directory doens't exist" {})))
          (not (string/blank? clone)) (process/sh {:out :inherit :err :inherit :continue true} (format "git clone %s '%s'" clone full-path))
          (true? init) (create-git-init)
          :else (fs/create-dir full-path))))

(defn create [args]
  (when (nil? (:name (:opts args))) (throw (ex-info "Name must be provided" {})))
  (let [p (->> (fetcher/query config)
               (map #(:parent %))
               (distinct))
        parent (cond (some? (:parent (:opts args))) (:parent (:opts args))
                     :else (fzf p))
        init (:init (:opts args))
        clone (:clone (:opts args))
        link (:link (:opts args))
        parent-path (fs/path (:root config) parent)
        name (:name (:opts args))
        c (count (filter #(= (string/upper-case parent) (string/upper-case %)) p))]

    (when (string/blank? parent) (throw (ex-info "" {})))
    (when (zero? c) (throw (ex-info "Invalid Parent" {})))
    (create-directory name parent-path init clone link)))

(defn print-config [_]
  (pp/pprint (config-fetcher/get-config)))


(def cmds [{:cmds ["ls"] :fn ls :alias{:e :edn}}
           {:cmds ["rm"] :fn rm :args->opts [:name]}
           {:cmds ["print-config"] :fn print-config}
           {:cmds ["new"] :fn create :args->opts [:name] :alias {:p :parent :i :init :c :clone :l :link}}
           {:cmds [] :fn open :args->opts [:name] :alias {:e :explorer :o :obsidian :p :path}}])

(defn -main [& args]
  (try
    (cli/dispatch cmds args {:coerce {:name :string :parent :string :clone :string :link :string}})
    (catch Exception e
      (when-not (string/blank? (ex-message e)) (println (ex-message e)))
      (when-not (empty? (ex-data e)) (pp/pprint (ex-data e))))))
