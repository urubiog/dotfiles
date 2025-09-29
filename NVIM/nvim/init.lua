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

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        auto_update = false,
        branch = "v2.5",
        import = "nvchad.plugins",
        config = function()
            require "options"
            require "mappings"
            require "autocmd"
            require "null-ls"
        end,
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvim-tree").setup({
    auto_reload_on_write = true,
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = true,
    sort = {
        sorter = "name",
        folders_first = true,
    },
    view = {
        width = 40,
        side = "right",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    },
    renderer = {
        root_folder_label = function(path)
            return vim.fn.fnamemodify(path, ":t") -- Extrae solo el último segmento del path
        end,
        add_trailing = false,
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "name",
        indent_markers = {
            enable = true,
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
    filters = {
        dotfiles = false,
        custom = { ".DS_Store", "thumbs.db" },
    },
    git = {
        enable = true,
        ignore = true,
        show_on_dirs = true,
        timeout = 400,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        debounce_delay = 50,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
        },
        open_file = {
            quit_on_open = true,
            resize_window = true,
        },
    },
    log = {
        enable = false,
        truncate = true,
        types = {
            diagnostics = true,
            git = false,
        },
    },
})

require("smear_cursor")
