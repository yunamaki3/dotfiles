local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  config.font = wezterm.font_with_fallback({
    { family = "FiraMono Nerd Font Mono", weight = "Regular" },
    { family = "Noto Sans Mono CJK JP", weight = "Regular" },
  })
  config.font_size = 16.0

  config.window_background_opacity = 0.85
  if wezterm.target_triple:find("darwin") then
    config.macos_window_background_blur = 20
  elseif wezterm.target_triple:find("windows") then
    config.win32_system_backdrop = "Acrylic"
  end
  config.window_decorations = "RESIZE"
end

return M
