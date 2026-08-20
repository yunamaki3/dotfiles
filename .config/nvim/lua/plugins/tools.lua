return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clang-format",
        "prettier",
        "stylua",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        markdown = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
    },
  },
}

