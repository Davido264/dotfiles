local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder()

-- look n feel
config.font = wezterm.font_with_fallback({"Mononoki Nerd Font", "JetBrains Mono"})
config.hide_mouse_cursor_when_typing = false
config.font_size = 13.0
config.bold_brightens_ansi_colors = false
config.window_background_opacity = 0.85
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.scrollback_lines = 3500
config.enable_scroll_bar = true
config.inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.4,
}

-- pywal
local home
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  home = os.getenv("USERPROFILE")
else
  home = os.getenv("HOME")
end
local ok,colors,_ = pcall(wezterm.color.load_scheme, home .. "/.cache/wal/colors.toml")

if ok then
  config.colors = colors
end

wezterm.add_to_config_reload_watch_list(home .. "/.cache/wal/colors.toml")

--shell
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { "pwsh.exe", "-nologo" }
end
-- keymaps
config.leader = { key = 'f', mods = 'ALT' }
config.keys = {
  -- ?
	{ key = "LeftArrow" , mods = "OPT", action = act.SendString("\x1bb") },
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

  -- full scren
  { key = 'Enter', mods = 'ALT',    action = wezterm.action.ToggleFullScreen },

  -- management 
  { key = "-",     mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "\\",    mods = "LEADER", action = act.SplitHorizontal({ domain= "CurrentPaneDomain" }) },
  { key = "z" ,    mods = "LEADER", action = "TogglePaneZoomState" },
  { key = "c" ,    mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "H",     mods = "LEADER", action = act.AdjustPaneSize({"Left", 5}) },
  { key = "J",     mods = "LEADER", action = act.AdjustPaneSize({"Down", 5}) },
  { key = "K",     mods = "LEADER", action = act.AdjustPaneSize({"Up", 5}) },
  { key = "L",     mods = "LEADER", action = act.AdjustPaneSize({"Right", 5}) },

  -- nagivation
  { key = "h",     mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j",     mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",     mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l",     mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "`",     mods = "LEADER", action = act.ActivateLastTab },
  { key = " ",     mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "1",     mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2",     mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3",     mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4",     mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5",     mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6",     mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7",     mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8",     mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9",     mods = "LEADER", action = act.ActivateTab(8) },
  { key = "x",     mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

  { key = "[",     mods = "LEADER", action = act.ActivateCopyMode },
}
config.key_tables = {
  copy_mode = {
    { key="Escape", mods="NONE", action=act.CopyMode("Close")},

    { key="h", mods="NONE", action=act.CopyMode("MoveLeft")},
    { key="j", mods="NONE", action=act.CopyMode("MoveDown")},
    { key="k", mods="NONE", action=act.CopyMode("MoveUp")},
    { key="l", mods="NONE", action=act.CopyMode("MoveRight")},

    { key="LeftArrow",  mods="NONE", action=act.CopyMode("MoveLeft")},
    { key="DownArrow",  mods="NONE", action=act.CopyMode("MoveDown")},
    { key="UpArrow",    mods="NONE", action=act.CopyMode("MoveUp")},
    { key="RightArrow", mods="NONE", action=act.CopyMode("MoveRight")},

    { key="RightArrow", mods="ALT",  action=act.CopyMode("MoveForwardWord")},
    { key="w",          mods="NONE", action=act.CopyMode("MoveForwardWord")},
    { key="e",          mods="NONE", action=act.CopyMode("MoveForwardWord")},

    { key="LeftArrow", mods="ALT",   action=act.CopyMode("MoveBackwardWord")},
    { key="b",         mods="NONE",  action=act.CopyMode("MoveBackwardWord")},

    { key="0",     mods="NONE",  action=act.CopyMode("MoveToStartOfLine")},

    { key="$",     mods="NONE",  action=act.CopyMode("MoveToEndOfLineContent")},
    { key="_",     mods="NONE",  action=act.CopyMode("MoveToStartOfLineContent")},

    { key="v", mods="NONE",  action=act.CopyMode{SetSelectionMode="Cell"}},
    { key="V", mods="NONE",  action=act.CopyMode{SetSelectionMode="Line"}},
    { key="v", mods="CTRL",  action=act.CopyMode{SetSelectionMode="Block"}},

    { key="G", mods="NONE",  action=act.CopyMode("MoveToScrollbackBottom")},
    { key="g", mods="NONE",  action=act.CopyMode("MoveToScrollbackTop")},

    { key="H", mods="NONE",  action=act.CopyMode("MoveToViewportTop")},
    { key="H", mods="SHIFT", action=act.CopyMode("MoveToViewportTop")},
    { key="L", mods="NONE",  action=act.CopyMode("MoveToViewportBottom")},
    { key="L", mods="SHIFT", action=act.CopyMode("MoveToViewportBottom")},

    { key="o", mods="NONE",  action=act.CopyMode("MoveToSelectionOtherEnd")},
    { key="O", mods="NONE",  action=act.CopyMode("MoveToSelectionOtherEndHoriz")},

    { key="PageUp",   mods="NONE", action=act.CopyMode("PageUp")},
    { key="PageDown", mods="NONE", action=act.CopyMode("PageDown")},

    {key="y", mods="NONE", action=act.Multiple{
      act.CopyTo("ClipboardAndPrimarySelection"),
      act.CopyMode("Close"),
    }},

    {key="/", mods="NONE", action=act{Search={CaseSensitiveString=""}}},
    {key="?", mods="NONE", action=act{Search={CaseInSensitiveString=""}}},
    {key="n", mods="CTRL", action=act{CopyMode="NextMatch"}},
    {key="p", mods="CTRL", action=act{CopyMode="PriorMatch"}},
  }
}

-- terminal multiplexer
config.unix_domains = {
  {
    name = 'unix',
  },
}

-- tls domain
config.tls_clients = {
  {
    name = 'mux',
    remote_address = 'localhost:10000',
    bootstrap_via_ssh = 'localhost',
  },
}

config.tls_servers = {
  {
    bind_address = 'localhost:10000',
  },
}

config.default_gui_startup_args = { 'connect', 'unix' }

return config
