# TODO Before getting a new machine
- [ ] Create special scripts for work
    - `load-mivilsoft` will load `~/.local/bin/mivilsoft-tools/` into `$PATH`
    - `traccar-consume-websocket [-url url] [-usr usrname] [-passwd passwd] [-token token] [-filter all|positions|logs|devices]` -> websocket client for traccar (**currently implemented in python on traccar-old**)
        - Maybe rewrite it on js with a nice TUI library (multiplatform obviously)
    - `traccar-simulate` Its the simulation project I have on `~/Source/Mivilsoft/full-traccar-simulation/`
    - also temporary tools like `add_traccar_epmmop_groups`
    - IDEA: all tools source code placed on `~/Source/Mivilsoft/tools/{project}`

- [x] Delete stuff related to:
    - NixOS
    - Wezterm
  On the future, experiment with the new AGS and Hyprland with a workflow similar to iPadOS. The bigest problem with that
  is a system configuration app

- [-] Move from Ansible to Chezmoi + Bash
    - chezmoi will handle dotfiles (w/o symlinks) and will trigger a single bash script, that bash script will run the
      rest of the bash scripts
    - [x] When the time comes, adapt to Windows and Android

- [ ] Backup files, either to GDriver

- [x] Setup waydroid

- [ ] S3 for backup files
    - Minecraft backup saves
    - Reaper backup configs
        - I think its best to use stow
    - Wallpapers?
        - [ ] Move the cloning of `~/Pictures/wallpapers` stuff to ansible

- [ ] maybe an script to add entries to `.ssh/config`:
    - It ask for hosts (until a special key is pressed) and if no host is selected, it fails
    - It ask for user (until a special key is selected?)
    - It ask for the port (default 22, it can be an empty value)
    - It ask for the pem file (maybe config to choose the directory in which all these are stored and fzf to it)
    - It writes at the of the file the new entry

- [ ] Questions:
    - Shell environment and development tools are overlapping in some zones, will it be better if I merge them into one?
        - Also, they both can have the 'minimal' and 'normal' tier, but only shell environment have the 'fancy' tier
    - How do I detect on ~~ansible~~ that I'm running in Termux?
        - No more ansible (also chezmoi can run on a container with a one shot )

- [ ] Test with a fedora and arch container the size of shell_env and set caps to shell_env minimal and full
    - Mary Kondo styling? maybe styling will be just for full, but idk. I'm not going to run this on a server.

- [ ] Move android sdk and ndk stuff to asdf?
    - not posible, use sdkmanager installed manually

- [ ] make matugen/config.toml a template to dynamically add templates and avoiding create unnecesary directories

- [ ] Learn Reaper (3h video)

- [ ] Integrate the install script with my (future) webdav server

- [ ] maybe install babashka `bb` and `rlwrap`

- [ ] Restore tabs (maybe use this to test browser usage)
    - [PiP on Top](https://github.com/Rafostar/gnome-shell-extension-pip-on-top)
        - Install extension, maybe see how to hide pip window from alt-tab

    - [MacOS VM on docker](https://github.com/sickcodes/Docker-OSX)

    - [Full screen to new workspace](https://github.com/onsah/fullscreen-to-new-workspace?tab=readme-ov-file)
        - maybe fork it and add functionality to go to the first workspace with fullscreen window when a window is unfullscreened
    - [Capture the flag to learn](https://picoctf.org/)

    - [Cymatics downloads](https://cymatics.fm/pages/downloads-mirror)

    - [How to make beats in Reaper](https://www.youtube.com/watch?v=lJAmSS-ndoU)

    - [REAPER Full tutorial (left on 16:15)](https://youtu.be/XRAYqWFeYR0?si=b2aZ3WuRctiy6xKD&t=975)

    - [Errors while managing time](https://www.youtube.com/watch?v=JrhO02qs5Is)


# Review
- [ ] Create README
    - Include the following command on the TODO after install:
        ```sh
        ./scripts/setup-rclone.sh
        gh auth login
        glab auth login
        ```


# Maybe?
- create queries for mcfunction

# Long term
- latex templates
- learn to latex properly
- maybe pandoc properly?
- Backup all (using cloud-drive)
- [...](file:///home/david/stuff_todo)


# Project queue
- Tetris on ncurses built with C (ongoing, waiting)
- waifu-wait-for (to explore goroutines) (waiting)
- Update cloud-sync (waiting)
    - Create a config file per directory
        - Set different providers
        - Configure encription
        - sync all directories with the config file
        - Upload to github
- Create a MFA cli for bitwarden (waiting)
    - Use bitwarden MFA field to generate codes
- alacritty-but-transparentizes-fullscreen
    - Fork alacritty and make it react to resize events to apply transparency only when full screen.
    - Can wezterm do this?
    - Can ghostty do this?
- Script that launches a popup (maybe rofi) and open a window layout
    - I saw a video in which a man did that on ipad OS using the shortcuts apps
        - It opened a menu, and then he chose a layout, and the windows opened
            - Example: Work:
                - A full screen terminal
                - A full screen browser
                - Full screen VSCode with a project open
                - Nautilus with a folder open
- Gnome plugin that automatically fullscreen a window when it was in split layout and the other window closes
    1. Split layout window 1 and 2
    2. Window 1 (or 2) closes
    3. The window left goes fullscreen
- Gnome plugin to consider Splitted Windows as One Window
    - There are 4 Apps open: Brave, Nautilus, Terminal and Okulus. But there are 2 Windows
    - Brave + Nautilus (splitted) is consider as one window
    - Terminal + Okulus (splitted) is consider as one window
- `new-vm` script with Terraform, to support creating virtual machines on AWS EC2, GCP, Azure, etc



# From Move-to-linux
idea de proyecto: waifu waiting
    waifu-wait-for <comand>
    ejecuta el comando, da un stderr y un stdout al comando en lugar de hacer que use la terminal,
    y muestra una animación en ascii art de una waifu esperando
    cuando el comando termine, se mostrará el stdout del comando, o el stderr si falla
    puedo usar go channels

# Restore web Pages:

https://github.com/overtone/overtone
https://www.youtube.com/watch?v=eUixwf64sHg (Overtone)

--------------------

https://www.youtube.com/@dataminingincae/videos
https://www.braveclojure.com/introduction/
https://github.com/vrtmrz/livesync-bridge
https://bulletjournal.com/blogs/bulletjournalist/on-stillness-with-ryan-holiday
https://repositorio.uta.edu.ec/

----- JAZZZZZZ --------
https://www.youtube.com/watch?v=yFUSp_yqo1A
https://www.youtube.com/watch?v=CH0xCGbnsgk

-----
https://www.gnu.org/software/coreutils/manual/coreutils.pdf


- [ ] ./roles/gaming/tasks/main.yml
    - TODO: Gaming on fedora
- [ ] ./roles/devel/tasks/langs/flutter.yml
    - TODO: Install flutter w/o dying
- [ ] ./roles/devel/tasks/main.yml
    - TODO: Write this for Mason
- [ ] ./roles/devel/tasks/main.yml
    - TODO: Don't know, maybe first to mary kondo this
- [ ] ./roles/system/tasks/main.yml
    - TODO: Detect android/termux with ansible_facts
- [ ] ./roles/shell_env/tasks/main.yml
    - TODO: Think about this
- [ ] ./roles/desktop_env/tasks/gnome.yml
    - TODO: Install caffeine and fullscreen-to-new-workspace extensions on fedora
- [ ] ./roles/desktop_env/tasks/main.yml
    - TODO: Create a separate task for Nerd fonts to do it manually by default and using pacman in arch
- [ ] ./roles/desktop_env/tasks/main.yml
    - TODO: This requires an iso from MS Windows or a CD of Office 2007
- [ ] ./stow/neovim/.config/nvim/lua/plugins/tools/mason.lua
    - TODO: When I have the time, go for the option 4, https://github.com/nvim-treesitter/nvim-treesitter/issues/2900 had


- [ ] `L8TR`: fix `pacman`'s _Operation to slow_
    - [ ] what if I want to run the script and do other things? Can the script be resilient with this errors?
- [ ] `L8TR`: `gaming` role: make it able (or ready to be able) to run on fedora






https://wiki.archlinux.org/title/TLP
https://www.reddit.com/r/swaywm/comments/l3nay0/does_anybody_know_of_a_power_manager_compatible/
https://github.com/Alexays/Waybar/wiki/Module:-Bluetooth
https://github.com/niklasfyi/dotfiles-1/blob/master/dot_config/waybar/config
https://github.com/nwg-piotr/nwg-displays
https://github.com/francma/wob/blob/master/contrib/README.md
https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway
https://github.com/Ubuntu-Sway/ubuntu-sway-default-settings/blob/a957d5ad38708215320444e6670430b7231cfec6/common/etc/skel/.config/swaylock/config
https://github.com/Ubuntu-Sway/ubuntu-sway-default-settings/tree/a957d5ad38708215320444e6670430b7231cfec6/common/etc/skel/.config
https://github.com/firecat53/networkmanager-dmenu




Moar links

https://www.reddit.com/r/linux_gaming/comments/8j73zu/comment/dyz2ra8/

https://gist.github.com/setzer22/77b1dc4b226fdf2dee83e6399e30558b

https://wiki.archlinux.org/title/Dual_boot_with_Windows

https://www.dedoimedo.com/computers/linux-intel-graphics-video-tearing.html

https://fasterland.net/fix-horizontal-lines-on-youtube-in-chrome-linux.html

https://www.youtube.com/watch?v=XST1XOhEr7A

https://www.reddit.com/r/Fedora/comments/ph75um/intel_graphics_driver/

https://github.com/noctuid/tdrop/blob/master/tdrop

https://superuser.com/questions/285755/boot-to-windows-once-from-grub-then-back-to-ubuntu-on-next-boot?_gl=1*wxzv0i*_ga*MTY1NDk3MTk4OS4xNjgxNDgzMzQy*_ga_S812YQPLT2*MTY4MTQ4MzM0MS4xLjAuMTY4MTQ4MzM0NC4wLjAuMA..
