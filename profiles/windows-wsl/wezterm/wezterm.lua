local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

-- local.lua is generated per PC and is not committed.
local local_path = wezterm.config_dir .. "/local.lua"
local local_config = {}
local local_file = io.open(local_path, "r")
if local_file then
    local_file:close()
    local_config = dofile(local_path)
end
local distro = local_config.distro or "Ubuntu"
config.default_domain = "WSL:" .. distro

config.wsl_domains = {
    {
        name = "WSL:" .. distro,
        distribution = distro,
        default_cwd = "~",
        default_prog = { "zsh", "-l" },
    },
}

-- Optional per-user fonts downloaded by scripts/install-current-fonts.ps1.
config.font_dirs = { wezterm.home_dir .. "/.local/share/dotfiles/fonts" }
config.font = wezterm.font_with_fallback({
    "FiraMono Nerd Font",
    "HackGen Console NF",
})
config.font_size = 14.0
config.use_ime = true
config.window_background_opacity = 0.85
-- config.win32_system_backdrop = "Acrylic"
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE"

config.hide_tab_bar_if_only_one_tab = false

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

config.window_background_gradient = {
    colors = { "#1a1a2e" },
}

config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.color_scheme = "Solarized Dark Higher Contrast"

config.colors = {
    background  = "#1a1a2e",
    cursor_bg = "#80EBDF",
    cursor_fg = "#000000",
    cursor_border = "#80EBDF",
    selection_bg = "#ffdd00",
    selection_fg = "#000000",
    tab_bar = {
        background = "none",
        inactive_tab_edge = "none",
    },
}


local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables
config.leader = { key = ";", mods = "CTRL", timeout_milliseconds = 2000}

config.inactive_pane_hsb = {
  hue = 0.9,
  saturation = 0.9,
  brightness = 1.0,
}

config.window_close_confirmation = "NeverPrompt"

return config
