local wezterm = require("wezterm")

local config = wezterm.config_builder()

require("config.appearance").apply(config)
require("config.keys").apply(config)
require("config.tabs").apply(config)

config.automatically_reload_config = true
config.check_for_updates = false
config.use_ime = true
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 700
config.scrollback_lines = 10000

return config

