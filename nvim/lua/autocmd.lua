require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      vim.cmd "colorscheme nvchad"
    end)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local directory = vim.fn.isdirectory(data.file) == 1

    if directory then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "TodoFgTODO", { fg = "#4FC1FF" })
    vim.api.nvim_set_hl(0, "TodoFgFIX", { fg = "#FF6B6B" })
    vim.api.nvim_set_hl(0, "TodoFgWARN", { fg = "#FFB86C" })
    vim.api.nvim_set_hl(0, "TodoFgNOTE", { fg = "#8BE9FD" })
  end,
})
