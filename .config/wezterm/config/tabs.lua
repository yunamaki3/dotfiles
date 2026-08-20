local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  config.show_tabs_in_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false

  config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
  }

  config.window_background_gradient = {
    colors = { "#000000" },
  }

  config.colors = {
    tab_bar = {
      inactive_tab_edge = "none",
    },
  }

  local solid_left_arrow = wezterm.nerdfonts.ple_lower_right_triangle
  local solid_right_arrow = wezterm.nerdfonts.ple_upper_left_triangle

  wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
    local background = "#5c6d74"
    local foreground = "#ffffff"
    local edge_background = "none"

    if tab.is_active then
      background = "#ae8b2d"
    end

    local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = background } },
      { Text = solid_left_arrow },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = background } },
      { Text = solid_right_arrow },
    }
  end)
end

return M
