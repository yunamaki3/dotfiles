return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.bg = "#0b1220"
        colors.bg_dark = "#0b1220"
        colors.bg_float = "#111b2e"
        colors.border = "#334155"
        colors.cyan = "#5eead4"
        colors.blue = "#7dd3fc"
      end,
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
     ╭──────────────────────────╮
     │      clean workspace     │
     ╰──────────────────────────╯]],
        },
      },
    },
  },
}

