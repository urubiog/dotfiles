require "nvchad.autocmds"

local cmd = vim.cmd

cmd("lua require('lazygit')")

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.schedule(function()
            cmd("colorscheme nvchad")
        end)
    end,
})
