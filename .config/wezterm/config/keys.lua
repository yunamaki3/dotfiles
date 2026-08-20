local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply(config)
  local target = wezterm.target_triple
  local is_macos = target:find("darwin") ~= nil

  config.leader = {
    key = "q",
    mods = is_macos and "ALT" or "CTRL",
    timeout_milliseconds = 1500,
  }

  config.keys = {
    { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 3 }) },
    { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 3 }) },
    { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 3 }) },
    { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 3 }) },
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    { key = "q", mods = "LEADER", action = act.ActivateCommandPalette },
  }

  config.key_tables = {
    copy_mode = {
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      {
        key = "y",
        mods = "NONE",
        action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    },
  }
end

return M

