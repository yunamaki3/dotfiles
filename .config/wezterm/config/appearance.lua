local wezterm = require("wezterm")

local M = {}

local palette = {
  background = "#0b1220",
  foreground = "#d8dee9",
  muted = "#64748b",
  surface = "#111b2e",
  cyan = "#5eead4",
  blue = "#7dd3fc",
  red = "#fb7185",
  yellow = "#fbbf24",
}

function M.apply(config)
  config.font = wezterm.font_with_fallback({
    { family = "FiraMono Nerd Font Mono", weight = "Regular" },
    { family = "Noto Sans Mono CJK JP", weight = "Regular" },
  })
  config.font_size = 16.0
  config.line_height = 1.08
  config.cell_width = 1.0

  config.color_scheme = "Tokyo Night"
  config.colors = {
    foreground = palette.foreground,
    background = palette.background,
    cursor_bg = palette.cyan,
    cursor_fg = palette.background,
    cursor_border = palette.cyan,
    selection_bg = "#29405f",
    selection_fg = palette.foreground,
    split = palette.muted,
    tab_bar = {
      background = "none",
      inactive_tab_edge = "none",
    },
  }

  config.window_background_opacity = 0.92
  config.text_background_opacity = 1.0
  config.macos_window_background_blur = 18
  config.win32_system_backdrop = "Acrylic"
  config.window_decorations = "RESIZE"
  config.window_padding = { left = 14, right = 14, top = 10, bottom = 10 }
  config.inactive_pane_hsb = { saturation = 0.88, brightness = 0.78 }

  config.window_frame = {
    active_titlebar_bg = "none",
    inactive_titlebar_bg = "none",
    font = wezterm.font({ family = "FiraMono Nerd Font Mono", weight = "Medium" }),
    font_size = 11.0,
  }
end

M.palette = palette

return M
