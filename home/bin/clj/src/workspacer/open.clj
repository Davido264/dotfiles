(ns workspacer.open
  (:require [babashka.fs :as fs]
            [babashka.process :as process]
            [clojure.string :as string]
            [clojure.java.browse :as browse]))

(defn- open-windows-terminal [ws-name ws-path]
    (process/process (format "wt.exe -M -w workspace nt --title \"%s\" -d \"%s\"" ws-name ws-path)))

(defn explorer [workspace]
  (let [path (:path workspace)]
    (if (fs/windows?)
      (process/process ["explorer.exe" path])
      (process/process ["xdg-open" path]))))

(defn obsidian [workspace]
  (let [path (:path workspace)
        processed-path (string/replace (string/replace path "\\" "%5C") " " "%20")]
    (browse/browse-url (format "obsidian://open?path=%s" processed-path))))

(defn terminal [workspace]
  (let [path (:path workspace)]
    (when (fs/windows?)
      (open-windows-terminal (:name workspace) path))))
