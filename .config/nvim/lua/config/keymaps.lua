local map = vim.keymap.set

map("i", "jj", "<Esc>", { silent = true, desc = "Exit insert mode" })

map("n", "<Esc><Esc>", "<cmd>nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })

map("n", "<C-n>", function()
  require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
end, { silent = true, desc = "Explorer NeoTree (Root Dir)" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function(event)
    map("n", "<leader>cr", function()
      local file = vim.fn.expand("%:p")
      local output = vim.fn.stdpath("cache") .. "/lazyvim-c-run"
      vim.cmd("write")
      Snacks.terminal.open(
        { "sh", "-c", string.format("cc -Wall -Wextra -std=c17 %q -o %q && %q", file, output, output) },
        {
          cwd = vim.fn.expand("%:p:h"),
          esc_esc = false,
          ctrl_hjkl = false,
        }
      )
    end, { buffer = event.buf, desc = "Compile and run current C file" })
  end,
})

map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrap" })
