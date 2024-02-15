(ns workspacer.fetcher
  (:require [babashka.fs :as fs]
            [clojure.string :as string]
            [babashka.process :as process]))

(defn- get-workspaces [root parent]
  (let [path (if (fs/absolute? (fs/expand-home parent)) (fs/expand-home parent) (fs/real-path (fs/path root parent)))]
    (->> (fs/list-dir path)
         (map #(hash-map :parent parent :name (fs/file-name %) :path (str %))))))

(defn- filter-workspace [workspace name]
  (if (nil? name) true
      (= (:name workspace) name)))

(defn query
  "Returns an array of workspaces under the directories stated by the config. 
  If name is passed, returns all workspaces that matches name"
  [config & [name]]
  (let [root (fs/expand-home (:root config))
        parents (:parents config)]
    (->> parents
         (map #(get-workspaces root %))
         (reduce concat)
         (filter #(filter-workspace % name)))))

(defn query-full-info
  "Returns an array of workspaces under the directories stated by the config.
  If name is passed, returns all workspaces that matches name.
  This function returns all information posible, and its separated from `workspacer.fetcher/query` because of performance"
  [config & [name]]
  (let [git-remote #(-> (process/sh {:dir (str %) :continue true :out :string :err :string :in :inherit} "git remote get-url origin") :out string/trim-newline)
        link #(str (fs/real-path %))]
    (->> (query config name)
         (map #(assoc % :link (if (fs/sym-link? (:path %)) (link (:path %)) false) :git-remote (if (fs/exists? (fs/path (:path %) ".git")) (git-remote (:path %)) false))))))
