-- starship.lua
os.setenv("SHELL","CMD")
load(io.popen('starship init cmd'):read("*a"))()
