-- Get Neovim version information
local nvim_version = vim.version()

-- Join major, minor, and patch with "."
local version_str = table.concat({ nvim_version.major, nvim_version.minor, nvim_version.patch }, ".")


local plugins = {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            cmdline = {
                format = {
                    search_down = false,  -- Evita mostrar mensajes de búsqueda hacia abajo
                    search_up = false,    -- Evita mostrar mensajes de búsqueda hacia arriba
                    filter = false,       -- No mostrar filtros innecesarios
                },
            },
            popupmenu = {
                enabled = true,  -- Desactivar menús emergentes
            },
            messages = {
                -- Configurar vistas para mensajes reducidos
                enabled = true,
                view = "mini",   -- Usar vista mínima para no molestar
                view_error = "notify",  -- Solo mostrar errores como notificaciones
                view_warn = "mini",     -- Advertencias en miniatura
                view_history = false,   -- No guardar historial de mensajes
                view_cmdline = "cmdline", -- Solo comandos en la línea de comando
                filter = {  -- Filtrar aún más los mensajes
                    event = {
                        "msg_show", "msg_clear", "cmdline"
                    },
                    kind = {
                        "",  -- Filtrar cualquier mensaje sin categoría
                    },
                    skip = true,  -- Evitar mostrar estos tipos de mensajes
                },
            },
            notify = {
                enabled = true,  -- Solo mantener notificaciones importantes
                view = "mini",   -- Usar una vista pequeña para notificaciones
                filter = {
                    -- Filtrar solo mensajes importantes (errores, advertencias críticas)
                    event = "msg_show",
                    min_level = "warn",  -- Solo mostrar advertencias y errores
                },
            },
            lsp = {
                progress = { enabled = false },  -- No mostrar progreso del LSP
                hover = { enabled = false },     -- No mostrar mensajes de hover
                signature = { enabled = false }, -- No mostrar mensajes de firma
                message = { enabled = false },   -- Ocultar mensajes LSP generales
            },
            routes = {
                -- Filtrar aún más los eventos no esenciales
                {
                    filter = { event = "msg_show", kind = { "search_count", "echo", "mode" } },
                    opts = { skip = true },  -- No mostrar estos mensajes
                },
                -- Filtrar mensajes triviales
                {
                    filter = { event = "msg_show", find = "Pattern not found" }, 
                    opts = { skip = true },  -- No mostrar mensajes de patrones no encontrados
                },
            }
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_theme = 'light'
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "lewis6991/gitsigns.nvim",
        require("gitsigns").setup()
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        config = function()
            local db = require('dashboard')
            db.setup {
                theme = 'doom',
                config = {
                    header = {
                        "",
                        "",
                        '                                     ,o""""o                                        ',
                        '                                  ,o$"     o                                        ',
                        '                               ,o$$$                                                ',
                        '                             ,o$$$\'                                                 ',
                        '                           ,o$"o$\'                                                  ',
                        '                         ,o$$"$"\'                                                   ',
                        '                      ,o$"$o"$"\'                                                    ',
                        '                   ,oo$"$"$"$"$$`                      ,oooo$$$$$$$$oooooo.         ',
                        '                ,o$$$"$"$"$"$"$"o$`..             ,$o$"$$"$"\'            `oo.o      ',
                        '             ,oo$$$o"$"$"$"$  $"$$$"$`o        ,o$$"o$$$o$\'                 `o      ',
                        '          ,o$"$"$o$"$"$"$  $"$$o$$o $$o`o   ,$$$$$o$"$$o\'                    $      ',
                        '        ,o"$$"\'  `$"$o$" o$o$o"  $$$o$o$oo"$$$o$"$$"$o"\'                    $      ',
                        '     ,o$""        `"$ "$$o$$" $"$o$o$$"$o$$o$o$o"$"$"`""o                   \'       ',
                        '   ,o$\'          o$ `"$"$o "$o$$o$$$"$$$o"$o$$o"$$$    `$$                          ',
                        '  ,o\'           (     `" o$"$o"$o$$$"$o$"$"$o$"$$"$ooo|  `                          ',
                        ' $"$             `    (   `"o$$"$o$o$$ "o$o"   $o$o"$"$    )                        ',
                        '(  `                   `    `o$"$$o$" "o$$     "o /|"$o"                            ',
                        ' `                           `$o$$$$"" o$      "o$$|"$o\'                            ',
                        '                              `$o"$"$ $ "       `"$"$o$                             ',
                        '                               "$$"$$ "oo         ,$""$                             ',
                        '                               $"$o$$""o"          ,o$"$                            ',
                        '                               $$"$$"$ "o           `,",                            ',
                        '                     ,oo$oo$$$$$$"$o$$$ ""o                                         ',
                        '                  ,o$$"o"o$o$$o$$$"$o$$oo"oo                                        ',
                        '                ,$"oo"$$$$o$$$$"$$$o"o$o"o"$o o                                     ',
                        '               ,$$$""$$o$,      `$$$$"$$$o""$o $o                                   ',
                        '               $o$o$"$,          `$o$"$o$o"$$o$ $$o                                 ',
                        '              $$$o"o$$           ,$$$$o$$o"$"$$ $o$$oo      ,                       ',
                        '              "$o$$$ $`.        ,"$$o$"o$""$$$$ `"$o$$oo    `o                      ',
                        '              `$o$o$"$o$o`.  ,.$$"$o$$"$$"o$$$$   `$o$$ooo    $$ooooooo             ',
                        '                `$o$"$o"$"$$"$$"$"$$o$$o"$$o"        `"$o$o            `"o          ',
                        '                   `$$"$"$o$$o$"$$"$ $$$  $ "           `$"$o            `o         ',
                        '                      `$$"o$o"$o"$o$ "  o $$$o            `$$"o          ,$         ',
                        '                                                            `$$ooo     ,o$$         ',
                        '                                                               `$o$$$o$"$\'          ',
                        "",
                    },
                    center = {
                        {
                            icon = '  ',
                            desc = 'Find File                           ',
                            action = 'Telescope find_files',
                        },
                        {
                            icon = '  ',
                            desc = 'New File                            ',
                            action = 'enew',
                        },
                        {
                            icon = '  ',
                            desc = 'Recently Opened Files               ',
                            action = 'Telescope oldfiles',
                        },
                        {
                            icon = '󰈭  ',
                            desc = 'Search Text                         ',
                            action = 'Telescope live_grep',
                        },
                        {
                            icon = '  ',
                            desc = 'Update Plugins                      ',
                            action = 'Mason',
                        },
                        {
                            icon = '💤  ',
                            desc = 'Lazy                                ',
                            action = 'Lazy',
                        },
                        {
                            icon = '❌  ',
                            desc = 'Close                               ',
                            action = 'bd',
                        },
                    },
                    footer = {
                        "",
                        "Bienvenido señor.\tNvim " .. version_str,
                    }
                }
            }
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },
    {
        "mhartington/formatter.nvim",
        event = "VeryLazy",
        opts = function()
            return require "plugins.configs.formatter"
        end
    },
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            require "plugins.configs.lint"
        end
    },
    {
        "catppuccin/nvim",
        as = "catppuccin"
    },
    {
        "tribela/vim-transparent"
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = { "python" },
        opts = function()
            return require "plugins.configs.null-ls"
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- Type checkers and formatters for various languages
                -- markdown
                "marksman",
                "misspell",
                -- lua
                "lua-language-server",
                "stylua",
                -- web dev
                "css-lsp",
                "html-lsp",
                "typescript-language-server",
                "deno",
                -- docker
                "dockerfile-language-server",
                "docker-compose-language-service",
                -- rust
                "rust-analyzer",
                "rustfmt",
                -- go
                "gopls",
                "glint",
                "go-debug-adapter",
                "goimports",
                "goimports-reviser",
                "golangci-lint",
                "golangci-lint-langserver",
                "golines",
                "gotests",
                "gotestsum",
                -- python
                "pyright",
                "flake8",
                "black",
                "mypy",
                "pydocstyle",
                "pylint",
                "pyre",
                "autoflake",
                "autopep8",
                "python-lsp-server",
                -- yaml
                "terraform-ls",
                "tflint",
                "yaml-language-server",
                "yamlfmt",
                "yamllint",
                -- sql
                "sqlfluff",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup({
                bind = true, -- This is mandatory, otherwise border config won't get registered.
                doc_lines = 20, -- How many lines of documentation to show.
                floating_window = true, -- Use a floating window instead of virtual text.
                fix_pos = false, -- Let the floating window change its position when the cursor moves.
                hint_enable = true, -- Virtual hint enable.
                hint_prefix = "🔹 ", -- Panda for parameter hint.
                hint_scheme = "String",
                use_lspsaga = false, -- Set to true if you want to use lspsaga popup.
                hi_parameter = "Search", -- How your parameter will be highlighted.
                max_height = 12, -- Max height of signature floating window.
                max_width = 120, -- Max width of signature floating window.
                handler_opts = {
                    border = "single" -- Double, single, shadow, none.
                },
                extra_trigger_chars = {} -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
            })
        end
    }
}

return plugins
