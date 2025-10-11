vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Importa los plugins desde el archivo externo
-- local plugins = require("plugins_fixed")

-- load plugins
require("lazy").setup({
        {
            "NvChad/NvChad",
            -- commit = "29ebe31ea6a4edf351968c76a93285e6e108ea08",
            lazy = false,
            auto_update = false,
            import = "nvchad.plugins",
            config = function()
                require "options"
                require "mappings"
                require "autocmd"
            end,
        },
        { import = "plugins" }, },
    lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
