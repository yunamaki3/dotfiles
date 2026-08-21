return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        native_lsp = { enabled = true },
        neotree = true,
        noice = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
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
