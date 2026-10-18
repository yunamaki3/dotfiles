-- ============================================================
-- init.lua
-- ============================================================

-- バイトコードキャッシュを有効化
vim.loader.enable()

require("config.keylog")

vim.g.mapleader = " "      -- SpaceをLeaderに
vim.g.maplocalleader = " "

vim.opt.number = true          -- 行番号
vim.opt.cursorline = true      -- カーソル行をハイライト
vim.opt.mouse = "a"            -- マウス有効
vim.opt.termguicolors = true   -- 24bitカラー
vim.opt.signcolumn = "yes"     -- 左端にGit/診断マーク用の列を常に確保(ガタつき防止)

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true       -- タブをスペースに展開
vim.opt.autoindent = true
vim.opt.smartindent = true

-- 検索
vim.opt.incsearch = true       -- 入力しながら検索
vim.opt.hlsearch = true        -- マッチをハイライト
vim.opt.ignorecase = true      -- 大文字小文字を無視
vim.opt.smartcase = true       -- ただし大文字を含むときは区別

-- 補完メニューの挙動
vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.scrolloff = 4          -- カーソルの上下に常に4行の余白
vim.opt.splitright = true      -- :vsplit は右に開く
vim.opt.splitbelow = true      -- :split は下に開く
vim.opt.undofile = true        -- Neovimを閉じてもUndo履歴が残る
vim.opt.swapfile = false       -- スワップファイル(.swp)を作らない
vim.opt.clipboard = "unnamedplus" -- yank(コピー)がOSのクリップボードと連動

vim.opt.winblend = 20
vim.opt.pumblend = 10

-- vsnip
vim.g.vsnip_snippet_dir = vim.fn.expand("~/.vsnip")

-- ============================================================
-- キーマップ
-- ============================================================
local map = vim.keymap.set

-- jj で挿入モードを抜ける
map("i", "jj", "<Esc>", { silent = true })

-- Esc 2回で検索ハイライトを消す
map("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- j/k を「見た目の行」で移動
map({ "n", "x" }, "j", "gj", { silent = true })
map({ "n", "x" }, "k", "gk", { silent = true })

-- ウィンドウ分割系は基本"s"を起点にする
-- ウィンドウ分割
map("n", "ss", "<cmd>split<CR>",  { desc = "水平分割" })
map("n", "sv", "<cmd>vsplit<CR>", { desc = "垂直分割" })
-- 分割したウィンドウ間の移動
map("n", "sh", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "sj", "<C-w>j", { desc = "下のウィンドウへ" })
map("n", "sk", "<C-w>k", { desc = "上のウィンドウへ" })
map("n", "sl", "<C-w>l", { desc = "右のウィンドウへ" })

-- ファイルツリー
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { silent = true, desc = "ファイルツリー" })

-- ============================================================
-- lazy.nvim : プラグインマネージャー本体の自動インストール
-- (初回起動時に自動でgit cloneされます。この塊は公式の定型文)
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim; check Git and network connectivity")
  end
  local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"), "\n"))
  vim.fn.system({ "git", "-C", lazypath, "checkout", lock["lazy.nvim"].commit })
  if vim.v.shell_error ~= 0 then
    error("Failed to checkout locked lazy.nvim version")
  end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- プラグイン一覧
-- { "作者名/リポジトリ名", opts = {設定} } という書き方が基本形。
-- ============================================================
require("lazy").setup({
  ------------ colorscheme ----------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  ------------ visual ----------
  { "nvim-lualine/lualine.nvim", opts = {} },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { diagnostics = "nvim_lsp", separator_style = "thin" },
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      chunk = {
        enable = true,
        chars = {
          horizontal_line = "─", vertical_line = "│",
          left_top = "╭", left_bottom = "╰", right_arrow = ">",
        },
        style = "#806d9c",
      },
      indent = { enable = true },
    },
  },
  {
    "b0o/incline.nvim",
    config = function()
      local mocha = require("catppuccin.palettes").get_palette("mocha")
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal   = { guibg = mocha.mauve,    guifg = mocha.base },
            InclineNormalNC = { guifg = mocha.overlay1, guibg = mocha.surface0 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = { cursorline = true },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then filename = "[+]" .. filename end
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = { lsp = { progress = { enabled = true } } },
  },

  ------------ file tree ----------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    opts = {
      window = { width = 30 },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { visible = true },
      },
    },
  },

  ------------ nvim-treesitter ----------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- 既存のconfigs APIを使える互換ブランチ
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "lua", "vim", "vimdoc", "python", "bash", "json",
          "markdown", "typescript", "tsx", "javascript", "html", "css", "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  ------------ telescope ----------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- Space f f : ファイル名で検索して開く
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "ファイル検索" },
      -- Space f g : プロジェクト内の全文検索
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "全文検索(grep)" },
      -- Space f b : 開いているバッファから選ぶ
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "バッファ一覧" },
      -- Space f h : ヘルプ検索
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "ヘルプ検索" },
    },
  },

  ------------ gitsigns ----------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  ------------ flash ----------
  {
    "folke/flash.nvim",
    keys = {
      -- mode:normal +  s → 飛びたい場所の文字を2文字打つ → ラベルを押して着地
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flashジャンプ" },
    },
  },

  ------------ Comment: gcc -> comment out  ----------
  { "numToStr/Comment.nvim", keys = { "gc", "gcc", { "gc", mode = "v" } }, opts = {} },

  ------------ mini.surround ----------
  -- 例: saiw" → 単語を"で囲む / sd" → "を削除 / sr"' → "を'に変更
  { "echasnovski/mini.surround", keys = { "sa", "sd", "sr" }, opts = {} },

  -- ---------- which-key ----------
  -- Spaceを押して少し待つと候補表示
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  ------------ mason: LSPサーバーをUIからインストール ----------
  -- :Mason と打つと一覧が開き、i キーでインストールできます
  {
    "williamboman/mason.nvim",
    lazy = false, -- Mason管理のLSPを起動時からPATHに追加
    opts = {},
  },

  ------------ LSPと補完 ----------
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("clangd", { capabilities = caps })
      vim.lsp.enable("clangd")

      -- JavaScript / TypeScript
      vim.lsp.config("ts_ls", { capabilities = caps })
      vim.lsp.enable("ts_ls")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- 挿入モードに入った時だけ読み込む(遅延読み込みの例)
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      local function feedkey(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup({
        snippet = {
          expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#expandable"]() == 1 then
              feedkey("<Plug>(vsnip-expand)", "")
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#jumpable"](1) == 1 then
              feedkey("<Plug>(vsnip-jump-next)", "")
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "vsnip" } },
          { { name = "buffer" } }
        ),
      })

    end,
  },
})

-- ============================================================
-- その他(旧 autocmd / hi コマンドの移植)
-- ============================================================
vim.diagnostic.config({ float = { border = "rounded" } })

-- アクティブなウィンドウの境界線を目立たせる(元の設定をLua化)
vim.api.nvim_set_hl(0, "ActiveWindowSeparator",   { fg = "#69F5CD" })
vim.api.nvim_set_hl(0, "InactiveWindowSeparator", { fg = "#555555" })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function() vim.opt_local.winhighlight = "WinSeparator:ActiveWindowSeparator" end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function() vim.opt_local.winhighlight = "" end,
})
