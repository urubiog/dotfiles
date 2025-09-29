-- Get Neovim version information
local nvim_version = vim.version()

-- Join major, minor, and patch with "."
local version_str = table.concat({ nvim_version.major, nvim_version.minor, nvim_version.patch }, ".")

local plugins = {
    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup {
                suggestion = {
                    enabled = true, -- Habilitar sugerencias
                    auto_trigger = true, -- Activar sugerencias automáticamente
                    keymap = {
                        accept = "<C-e>",
                        next = "<M-]>", -- Siguiente sugerencia con Alt + ]
                        prev = "<M-[>", -- Anterior sugerencia con Alt + [
                    },
                },
                panel = { enabled = false }, -- Desactivar el panel flotante (opcional)
            }
        end,
    },
    -- {
    --     "folke/todo-comments.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     opts = {
    --         signs = true, -- show icons in the signs column
    --         sign_priority = 8, -- sign priority
    --         -- keywords recognized as todo comments
    --         keywords = {
    --             FIX = {
    --                 icon = " ", -- icon used for the sign, and in search results
    --                 color = "error", -- can be a hex color, or a named color (see below)
    --                 alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
    --                 -- signs = false, -- configure signs for some keywords individually
    --             },
    --             TODO = { icon = " ", color = "info" },
    --             HACK = { icon = " ", color = "warning" },
    --             WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    --             PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    --             NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    --             TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    --         },
    --         gui_style = {
    --             fg = "NONE", -- The gui style to use for the fg highlight group.
    --             bg = "BOLD", -- The gui style to use for the bg highlight group.
    --         },
    --         merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    --         -- highlighting of the line containing the todo comment
    --         -- * before: highlights before the keyword (typically comment characters)
    --         -- * keyword: highlights of the keyword
    --         -- * after: highlights after the keyword (todo text)
    --         highlight = {
    --             multiline = true,    -- enable multine todo comments
    --             multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
    --             multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    --             before = "",         -- "fg" or "bg" or empty
    --             keyword = "wide",    -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    --             after = "fg",        -- "fg" or "bg" or empty
    --             pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
    --             comments_only = true, -- uses treesitter to match keywords in comments only
    --             max_line_len = 400,  -- ignore lines longer than this
    --             exclude = {},        -- list of file types to exclude highlighting
    --         },
    --         -- list of named colors where we try to extract the guifg from the
    --         -- list of highlight groups or use the hex color if hl not found as a fallback
    --         colors = {
    --             error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    --             warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    --             info = { "DiagnosticInfo", "#2563EB" },
    --             hint = { "DiagnosticHint", "#10B981" },
    --             default = { "Identifier", "#7C3AED" },
    --             test = { "Identifier", "#FF00FF" }
    --         },
    --         search = {
    --             command = "rg",
    --             args = {
    --                 "--color=never",
    --                 "--no-heading",
    --                 "--with-filename",
    --                 "--line-number",
    --                 "--column",
    --             },
    --             -- regex that will be used to match keywords.
    --             -- don't replace the (KEYWORDS) placeholder
    --             pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    --             -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    --         },
    --     }
    -- },
    {
        "sphamba/smear-cursor.nvim",
        lazy = false,
        event = "BufReadPost",
        opts = {
            stiffness = 0.8,                -- 0.6      [0, 1]
            trailing_stiffness = 0.5,       -- 0.4      [0, 1]
            stiffness_insert_mode = 0.6,    -- 0.4      [0, 1]
            trailing_stiffness_insert_mode = 0.6, -- 0.4      [0, 1]
            distance_stop_animating = 0.5,  -- 0.1      > 0
            -- Smear cursor when switching buffers or windows.
            smear_between_buffers = true,

            -- Smear cursor when moving within line or to neighbor lines.
            -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
            smear_between_neighbor_lines = true,

            -- Draw the smear in buffer space instead of screen space when scrolling
            scroll_buffer_space = true,

            -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
            -- Smears will blend better on all backgrounds.
            legacy_computing_symbols_support = false,

            -- Smear cursor in insert mode.
            -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
            smear_insert_mode = true,
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- íconos opcionales
        },
        config = function()
            require("nvim-tree").setup {
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
                    width = 60,
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
            }
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            preset = "helix",
            defaults = {},
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show { global = false }
                end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<c-w><space>",
                function()
                    require("which-key").show { keys = "<c-w>", loop = true }
                end,
                desc = "Window Hydra Mode (which-key)",
            },
        },
    },
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        config = function()
            require "configs.conform"
        end,
    },
    {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end,
    },
    {
        "hedyhli/markdown-toc.nvim",
        ft = "markdown", -- Lazy load on markdown filetype
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
                end_text = "mtoc-end",
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
                markers = "*",
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
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"
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
            "rcarriga/nvim-dap-ui",
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
                    search_up = false, -- Evita mostrar mensajes de búsqueda hacia arriba
                    filter = false, -- No mostrar filtros innecesarios
                },
            },
            popupmenu = {
                enabled = true,
            },
            transparent = true,
            messages = {
                -- Configurar vistas para mensajes reducidos
                enabled = true,
                view_error = "notify", -- Solo mostrar errores como notificaciones
                view_warn = false, -- Advertencias en miniatura
                view_history = false, -- No guardar historial de mensajes
                view_cmdline = "cmdline", -- Solo comandos en la línea de comando
                filter = {        -- Filtrar aún más los mensajes
                    event = {
                        "msg_show",
                        "msg_clear",
                        "cmdline",
                    },
                    kind = {
                        "", -- Filtrar cualquier mensaje sin categoría
                    },
                    skip = true, -- Evitar mostrar estos tipos de mensajes
                },
            },
            notify = {
                enabled = true, -- Solo mantener notificaciones importantes
                view = "mini", -- Usar una vista pequeña para notificaciones
                filter = {
                    -- Filtrar solo mensajes importantes (errores, advertencias críticas)
                    event = "msg_show",
                    min_level = "warn", -- Solo mostrar advertencias y errores
                },
            },
            lsp = {
                progress = { enabled = false }, -- No mostrar progreso del LSP
                hover = { enabled = false }, -- No mostrar mensajes de hover
                signature = { enabled = false }, -- No mostrar mensajes de firma
                message = { enabled = false }, -- Ocultar mensajes LSP generales
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
            background_colour = "#000000",
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            -- other settings
            top_down = false,
            -- other settings
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_theme = "light"
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            -- Configuración principal
            require("gitsigns").setup {
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 500,
                    ignore_whitespace = false,
                },
                -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                max_file_length = 40000,
                preview_config = {
                    border = "rounded",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            }

            -- Definición de highlights, como dictan las nuevas escrituras del templo de Neovim
            local hl = vim.api.nvim_set_hl
            local function link(from, to)
                hl(0, from, { link = to })
            end

            link("GitSignsAdd", "DiffAdd")
            link("GitSignsAddLn", "DiffAdd")
            link("GitSignsAddNr", "DiffAdd")
            link("GitSignsChange", "DiffChange")
            link("GitSignsChangeLn", "DiffChange")
            link("GitSignsChangeNr", "DiffChange")
            link("GitSignsChangedelete", "DiffChange")
            link("GitSignsChangedeleteLn", "DiffChange")
            link("GitSignsChangedeleteNr", "DiffChange")
            link("GitSignsDelete", "DiffDelete")
            link("GitSignsDeleteLn", "DiffDelete")
            link("GitSignsDeleteNr", "DiffDelete")
            link("GitSignsTopdelete", "DiffDelete")
            link("GitSignsTopdeleteLn", "DiffDelete")
            link("GitSignsTopdeleteNr", "DiffDelete")
        end,
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        config = function()
            local db = require "dashboard"
            db.setup {
                theme = "doom",
                config = {
                    header = {
                        "",
                        "",
                        '                                     ,o""""o                                        ',
                        '                                  ,o$"     o                                        ',
                        "                               ,o$$$                                                ",
                        "                             ,o$$$'                                                 ",
                        "                           ,o$\"o$'                                                  ",
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
                        "",
                        "",
                    },
                    center = {
                        {
                            icon = "  ",
                            desc = " Find File                          ",
                            action = "Telescope find_files",
                        },
                        {
                            icon = "  ",
                            desc = " New File                           ",
                            action = "enew",
                        },
                        {
                            icon = "  ",
                            desc = " Recently Opened Files              ",
                            action = "Telescope oldfiles",
                        },
                        {
                            icon = "󰈭  ",
                            desc = " Search Text                     ",
                            action = "Telescope live_grep",
                        },
                        {
                            icon = "🔧  ",
                            desc = "Config Files                        ",
                            action = "Telescope find_files cwd=~/.config/nvim",
                        },
                        {
                            icon = "💤  ",
                            desc = "Lazy                                ",
                            action = "Lazy",
                        },
                        {
                            icon = "❌  ",
                            desc = "Close                               ",
                            action = "bd",
                        },
                    },
                    footer = {
                        "",
                        "Bienvenido señor.\tNvim " .. version_str,
                    },
                },
            }
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
    {
        "mhartington/formatter.nvim",
        event = "VeryLazy",
        opts = function()
            return require "plugins.configs.formatter"
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            require "plugins.configs.lint"
        end,
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
            vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup {
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
                    border = "single", -- Double, single, shadow, none.
                },
                extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
            }
        end,
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
