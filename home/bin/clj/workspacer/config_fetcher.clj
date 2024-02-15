(ns workspacer.config-fetcher
  (:require [babashka.fs :as fs]
            [clojure.edn :as edn]
            [clojure.string :as string]))

(defn make-default-config []
  (hash-map :root (or (System/getenv "WORKSPACEROOT") (fs/home)) :parents [""]))

(defn get-config []
  (try
    (let [xdg-config (or (System/getenv "XDG_CONFIG_HOME") (str (fs/path (fs/home) ".config")))
          config-file (fs/path xdg-config "workspacerrc.edn")
          config (if (fs/exists? config-file) (edn/read-string (string/join "\n" (fs/read-all-lines config-file)))
                   (make-default-config))]
      config)
    (catch java.io.IOException e (println (ex-message e)))))
