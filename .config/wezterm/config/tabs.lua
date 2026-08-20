local wezterm = require("wezterm")
local appearance = require("config.appearance")

local M = {}

local function tab_title(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end
  return tab.active_pane.title
end

function M.apply(config)
  local palette = appearance.palette

  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.show_close_tab_button_in_tabs = false
  config.tab_bar_at_bottom = false
  config.tab_max_width = 28

  wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
    local bg = tab.is_active and palette.surface or "none"
    local fg = tab.is_active and palette.cyan or palette.muted
    if hover and not tab.is_active then
      bg = "#17243a"
      fg = palette.blue
    end

    local index = tostring(tab.tab_index + 1)
    local title = wezterm.truncate_right(tab_title(tab), max_width - 7)
    return {
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
      { Text = "  " .. index .. "  " .. title .. "  " },
    }
  end)

  wezterm.on("update-right-status", function(window, _)
    local leader = window:leader_is_active() and "  LEADER  " or ""
    window:set_right_status(wezterm.format({
      { Foreground = { Color = palette.yellow } },
      { Text = leader },
      { Foreground = { Color = palette.muted } },
      { Text = wezterm.strftime("  %H:%M  ") },
    }))
  end)
end

return M

