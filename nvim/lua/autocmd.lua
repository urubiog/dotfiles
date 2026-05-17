require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.schedule(function()
            vim.cmd("colorscheme nvchad")
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
