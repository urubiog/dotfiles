-- Get Neovim version information
local nvim_version = vim.version()

-- Join major, minor, and patch with "."
local version_str = table.concat({ nvim_version.major, nvim_version.minor, nvim_version.patch }, ".")

local plugins = {
        {
        "lervag/vimtex",
        lazy = false,     -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end
    },
    {
        "hedyhli/markdown-toc.nvim",
        ft = "markdown",  -- Lazy load on markdown filetype
        cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
        opts = {
            -- Your configuration here (optional)
            headings = {
                -- Include headings before the ToC (or current line for `:Mtoc insert`).
                -- Setting to true will include headings that are defined before the ToC
                -- position to be included in the ToC.
                before_toc = false,
            },

            -- Table or boolean. Set to true to use these defaults, set to false to disable completely.
            -- Fences are needed for the update/remove commands, otherwise you can
            -- manually select ToC and run update.
            fences = {
                enabled = true,
                -- These fence texts are wrapped within "<!-- % -->", where the '%' is
                -- substituted with the text.
                start_text = "mtoc-start",
                end_text = "mtoc-end"
                -- An empty line is inserted on top and below the ToC list before the being
                -- wrapped with the fence texts, same as vim-markdown-toc.
            },

            -- Enable auto-update of the ToC (if fences found) on buffer save
            auto_update = true,

            toc_list = {
                -- string or list of strings (for cycling)
                -- If cycle_markers = false and markers is a list, only the first is used.
                -- You can set to '1.' to use a automatically numbered list for ToC (if
                -- your markdown render supports it).
                markers = '*',
                cycle_markers = false,
                -- Example config for cycling markers:
                ----- markers = {'*', '+', '-'},
                ----- cycle_markers = true,
            },
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "mfussenegger/nvim-dap",
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui"
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            cmdline = {
                format = {
                    search_down = false, -- Evita mostrar mensajes de búsqueda hacia abajo
                    search_up = false,   -- Evita mostrar mensajes de búsqueda hacia arriba
                    filter = false,      -- No mostrar filtros innecesarios
                },
            },
            popupmenu = {
                enabled = true,
            },
            transparent = true,
            messages = {
                -- Configurar vistas para mensajes reducidos
                enabled = true,
                view_error = "notify",    -- Solo mostrar errores como notificaciones
                view_warn = false,        -- Advertencias en miniatura
                view_history = false,     -- No guardar historial de mensajes
                view_cmdline = "cmdline", -- Solo comandos en la línea de comando
                filter = {                -- Filtrar aún más los mensajes
                    event = {
                        "msg_show", "msg_clear", "cmdline"
                    },
                    kind = {
                        "",      -- Filtrar cualquier mensaje sin categoría
                    },
                    skip = true, -- Evitar mostrar estos tipos de mensajes
                },
            },
            notify = {
                enabled = true, -- Solo mantener notificaciones importantes
                view = "mini",  -- Usar una vista pequeña para notificaciones
                filter = {
                    -- Filtrar solo mensajes importantes (errores, advertencias críticas)
                    event = "msg_show",
                    min_level = "warn", -- Solo mostrar advertencias y errores
                },
            },
            lsp = {
                progress = { enabled = false },  -- No mostrar progreso del LSP
                hover = { enabled = false },     -- No mostrar mensajes de hover
                signature = { enabled = false }, -- No mostrar mensajes de firma
                message = { enabled = false },   -- Ocultar mensajes LSP generales
            },
            routes = {
                -- Redirigir salida de los comandos a la barra de notificaciones predeterminada
                -- {
                --     filter = { event = "msg_show", kind = { "", "echo" } }, -- Filtra mensajes de salida de comandos
                --     opts = { view = "mini" },                               -- Muestra en la vista de barra de notificaciones predeterminada (mini)
                -- },
                -- Otras reglas que ya tienes definidas
                {
                    filter = { event = "msg_show", kind = { "search_count", "mode" } },
                    opts = { skip = true }, -- Estos mensajes siguen siendo omitidos
                },
                {
                    filter = { event = "msg_show", find = "Pattern not found" },
                    opts = { skip = true },
                },
            },
            background_colour = "#000000"
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
                "debugpy",
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
    },
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        config = function()
            require "configs.conform"
        end,
    },

}
return plugins
