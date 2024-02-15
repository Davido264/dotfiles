(ns workspacer.open
  (:require [babashka.fs :as fs]
            [babashka.process :as process]
            [clojure.string :as string]
            [clojure.java.browse :as browse]))

(defn- open-windows-terminal [ws-name ws-path]
  (process/process (format "wt.exe -M -w workspace nt --title \"%s\" -d \"%s\"" ws-name ws-path)))

(defn- alacritty [command]
  (process/process (format "bash -c 'alacritty --class workspace -T workspace -e %s &'" command)))

(defn- create-and-swith [ws-name ws-path & [alacritty?]]
  (process/sh (format "tmux new-session -ds %s -c %s" ws-name ws-path))
  (if (false? alacritty?) (process/sh (format "tmux switch-client -t %s" ws-name))
    (alacritty (format "tmux switch-client -t %s" ws-name))))

(defn- open-alacritty-tmux [ws-name ws-path]
  (let [tmux-running? (zero? (:exit (process/sh "pgrep" "tmux")))
        tmux-envvar? (some? (System/getenv "TMUX"))
        alacritty-runing? (zero? (:exit (process/sh "xdotool" "search" "--class" "workspace")))
        session-exist? (zero? (:exit (process/sh "tmux has-session -t=foo")))]

       (cond (and (not tmux-envvar?) (not tmux-running?) alacritty-runing?) (process/sh (format "tmux new-session -s %s -c %s" ws-name ws-path))
        (and (not tmux-envvar?) (not tmux-running?) (not alacritty-runing?)) (alacritty (format "tmux new-session -s %s -c %s" ws-name ws-path))
        (and alacritty-runing? session-exist?) (process/sh (format "tmux switch-client -t %s" ws-name))
        (and (not alacritty-runing?) session-exist?) (alacritty (format "tmux switch-client -t %s" ws-name))
        (and alacritty-runing? (not session-exist?)) (create-and-swith ws-name ws-path)
        (and (not alacritty-runing?) (not session-exist?)) (create-and-swith ws-name ws-path true))))

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
  (let [path (:path workspace)
        name (format "%s/%s" (:parent workspace) (:name workspace))]
    (if (fs/windows?)
      (open-windows-terminal name path)
      (open-alacritty-tmux name path))))

