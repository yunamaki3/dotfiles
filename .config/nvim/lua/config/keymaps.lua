local map = vim.keymap.set

map("n", "<leader>cr", function()
  if vim.bo.filetype ~= "c" then
    vim.notify("This command is available for C files", vim.log.levels.WARN)
    return
  end

  local file = vim.fn.expand("%:p")
  local output = vim.fn.stdpath("cache") .. "/lazyvim-c-run"
  vim.cmd("write")
  Snacks.terminal.open({ "sh", "-c", string.format("cc -Wall -Wextra -std=c17 %q -o %q && %q", file, output, output) }, {
    cwd = vim.fn.expand("%:p:h"),
    esc_esc = false,
    ctrl_hjkl = false,
  })
end, { desc = "Compile and run current C file" })

map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrap" })
