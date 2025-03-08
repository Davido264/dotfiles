# ASAP
- [ ] Questions:
    - Shell environment and development tools are overlapping in some zones, will it be better if I merge them into one?
        - Also, they both can have the 'minimal' and 'normal' tier, but only shell environment have the 'fancy' tier



- [ ] Move android sdk and ndk stuff to asdf?
    - not posible, use sdkmanager installed manually


# During the next week
- [ ] Backup files, either to GDrive or S3
    - Minecraft backup saves
    - Reaper backup configs (this can be on github i guess) (once I use it and start tweaking with it)
    - Wallpapers?
        - [ ] `~/Pictures/wallpapers`

- [ ] maybe an script to add entries to `.ssh/config` and `.ssh/`:
    - Gets bitwarden stored ssh keys
    - It ask for hosts (until a special key is pressed) and if no host is selected, it fails
    - It ask for user (until a special key is selected?)
    - It ask for the port (default 22, it can be an empty value)
    - It ask for the pem file (maybe config to choose the directory in which all these are stored and fzf to it)
    - It writes at the of the file the new entry
    - NOW BITWARDEN SUPPORTS SSH KEYS




# THIS WEEKEND
- [ ] Setup snapper to snapshot and rollback

- [ ] better config management on neovim for lsp and tooling



- [ ] Learn Reaper (3h video)

- [ ] Restore tabs (maybe use this to test browser usage)
    - [MacOS VM on docker](https://github.com/sickcodes/Docker-OSX)

    - [Capture the flag to learn](https://picoctf.org/)

    - [Cymatics downloads](https://cymatics.fm/pages/downloads-mirror)

    - [How to make beats in Reaper](https://www.youtube.com/watch?v=lJAmSS-ndoU)

    - [REAPER Full tutorial (left on 16:15)](https://youtu.be/XRAYqWFeYR0?si=b2aZ3WuRctiy6xKD&t=975)

    - [Errors while managing time](https://www.youtube.com/watch?v=JrhO02qs5Is)


# Maybe?
- create queries for mcfunction

# Long term
- latex templates
- learn to latex properly
- maybe pandoc properly?

# Project queue
- Create special scripts for work
    - `traccar-simulate` Its the simulation project I have on `~/Source/Mivilsoft/full-traccar-simulation/`
- Have a script to open neovim on a `/tmp` hosted markdown note, or a new note created on a replica of cwd in `Documents`
- Tetris on ncurses built with C (ongoing, waiting)
- waifu-wait-for (to explore goroutines) (waiting)
    `waifu-wait-for <comand>`
    ejecuta el comando, da un stderr y un stdout al comando en lugar de hacer que use la terminal,
    y muestra una animación en ascii art de una waifu esperando
    cuando el comando termine, se mostrará el stdout del comando, o el stderr si falla
    puedo usar go channels
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
    - Can wezterm do this? Maybe, I have to try it
    - Can ghostty do this? No
- Script that launches a popup (maybe rofi) and open a window layout
    - I saw a video in which a man did that on ipad OS using the shortcuts apps
        - It opened a menu, and then he chose a layout, and the windows opened
            - Example: Work:
                - A full screen terminal
                - A full screen browser
                - Full screen VSCode with a project open
                - Nautilus with a folder open
- `new-vm` script with Terraform, to support creating virtual machines on AWS EC2, GCP, Azure, etc


# Restore web Pages:
https://github.com/overtone/overtone
https://www.youtube.com/watch?v=eUixwf64sHg (Overtone)

--------------------

https://www.braveclojure.com/introduction/
https://github.com/vrtmrz/livesync-bridge (obsidian livesync)
https://bulletjournal.com/blogs/bulletjournalist/on-stillness-with-ryan-holiday

----- JAZZZZZZ --------
https://www.youtube.com/watch?v=yFUSp_yqo1A
https://www.youtube.com/watch?v=CH0xCGbnsgk

-----
https://www.gnu.org/software/coreutils/manual/coreutils.pdf


- [ ] TODO: Write this for Mason (install odoo lsp)



https://wiki.archlinux.org/title/TLP
https://www.reddit.com/r/swaywm/comments/l3nay0/does_anybody_know_of_a_power_manager_compatible/
https://github.com/Alexays/Waybar/wiki/Module:-Bluetooth
https://github.com/niklasfyi/dotfiles-1/blob/master/dot_config/waybar/config
https://github.com/francma/wob/blob/master/contrib/README.md
https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway
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
