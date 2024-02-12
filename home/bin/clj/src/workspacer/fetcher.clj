(ns workspacer.fetcher
  (:require [babashka.fs :as fs]
            [clojure.string :as string]
            [babashka.process :as process]))

(defn get-workspaceroot
  "Returns the workspace root directory, which is defined by the WORKSPACEROOT environment varibale.
  If the WORKSPACEROOT environment varibale is not defined, returns home directory otherwise"
  []
  (let [root (System/getenv "WORKSPACEROOT")
        unix-home (System/getenv "HOME")
        nt-home (System/getenv "USERPROFILE")]
    (cond
      (some? root) root
      (some? unix-home) unix-home
      (some? nt-home) nt-home)))

(defn- is-valid-workspace?
  "Returns true if a path given is a valid workspace name, and false if it is not. A valid workspace is any folder
  up to 3 levels deep o workspace root"
  [path]
  (let [root-level (.getNameCount (fs/path (get-workspaceroot)))
        path-level (.getNameCount path)
        level (- path-level root-level)
        dir? (fs/directory? path)
        file-name (fs/file-name path)
        ignored? (or (string/starts-with? file-name ".") (string/starts-with? file-name "_"))]

    (and (not ignored?) dir? (<= level 3))))

(defn- get-child-workspaces
  "Returns an array of valid workspaces which are the direct children of the roots given"
  [roots]
  (->> roots
       (map #(fs/list-dir % is-valid-workspace?))
       (reduce concat)))

(defn- filter-workspace [workspace name]
  (if (nil? name) true
      (= (:name workspace) name)))

(defn query-full-info
  "Returns an array of valid workspaces up to 3 (included) levels deep. If name is passed, returns all workspaces that matches name
  The difference with `query` is that this function returns an map with more information about the workspace, such as symlinks and git remote,
  this is a separate function because of performance reasons"
  [& [name]]
  (let [level-1 (fs/list-dir (get-workspaceroot))
        level-2 (get-child-workspaces level-1)
        level-3 (get-child-workspaces level-2)
        git-remote #(-> (process/sh {:dir (str %) :continue true :out :string :err :string :in :inherit} "git remote get-url origin") :out string/trim-newline)
        link #(str (fs/real-path %))
        par #(str (string/replace-first (string/replace (string/replace (fs/parent %) (get-workspaceroot) "") "\\" "/") "/" "") "/")]
    (->> (concat level-1 level-2 level-3)
         (map #(hash-map :name (fs/file-name %) :parent (par %) :path (str %) :link (if (fs/sym-link? %) (link %) false) :git-remote (if (fs/exists? (fs/path % ".git")) (git-remote %) false)))
         (filter #(filter-workspace % name)))))

(defn query
  "Returns an array of valid workspaces up to 3 (included) levels deep. If name is passed, returns all workspaces that matches name"
  [& [name]]
  (let [level-1 (fs/list-dir (get-workspaceroot))
        level-2 (get-child-workspaces level-1)
        level-3 (get-child-workspaces level-2)
        par #(str (string/replace-first (string/replace (string/replace (fs/parent %) (get-workspaceroot) "") "\\" "/") "/" "") "/")]
    (->> (concat level-1 level-2 level-3)
         (map #(hash-map :name (fs/file-name %) :parent (par %) :path (str %)))
         (filter #(filter-workspace % name)))))
