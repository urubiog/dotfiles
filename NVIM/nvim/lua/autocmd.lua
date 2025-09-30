require "nvchad.autocmds"

local cmd = vim.cmd

cmd "lua require('lazygit')"

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.schedule(function()
            vim.cmd "colorscheme nvchad"
        end)
    end,
})

-- ===========================================================
-- Función para verificar si un buffer debe protegerse
-- ===========================================================
local function is_protected_buffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
        return true
    end

    local bufname = vim.api.nvim_buf_get_name(buf)
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    local bufhidden = vim.api.nvim_buf_get_option(buf, "bufhidden")
    local buflisted = vim.api.nvim_buf_get_option(buf, "buflisted")

    -- Proteger buffers efímeros y flotantes (ej. hovers/signature de LSP)
    if buftype == "nofile" or buftype == "prompt" or buftype == "popup" then
        return true
    end
    if bufhidden == "wipe" or buflisted == 0 then
        return true
    end

    -- Buffers especiales sin nombre o entre corchetes ([LSP Hover], [No Name]…)
    if bufname == "" or bufname:match "^%[.*%]$" then
        return true
    end

    -- Filetypes de plugins y auxiliares
    local protected_filetypes = {
        "dashboard",
        "NvimTree",
        "neo-tree",
        "TelescopePrompt",
        "TelescopeResults",
        "toggleterm",
        "terminal",
        "help",
        "qf",
        "packer",
        "lazy",
        "mason",
        "lspinfo",
        "null-ls-info",
        "dap-repl",
    }

    for _, ft in ipairs(protected_filetypes) do
        if filetype == ft then
            return true
        end
    end

    return false
end

-- ===========================================================
-- Utilidad: ignorar floating windows
-- ===========================================================
local function is_floating_win(win)
    return vim.api.nvim_win_get_config(win).relative ~= ""
end

-- ===========================================================
-- Registro de buffers previos por ventana
-- ===========================================================
local previous_buffers = {}

-- ===========================================================
-- WinNew: crear buffer vacío en ventanas “reales”
-- ===========================================================
vim.api.nvim_create_autocmd("WinNew", {
    callback = function()
        vim.defer_fn(function()
            local win = vim.api.nvim_get_current_win()

            -- Ignorar ventanas flotantes
            if is_floating_win(win) then
                return
            end

            local buf = vim.api.nvim_win_get_buf(win)

            -- Ignorar buffers protegidos
            if is_protected_buffer(buf) then
                return
            end

            local bufname = vim.fn.bufname(buf)
            local line_count = vim.fn.line "$"
            local first_line = vim.fn.getline(1)

            -- Si el buffer tiene contenido real, registrar y abrir uno nuevo
            if bufname ~= "" or line_count > 1 or first_line ~= "" then
                previous_buffers[win] = buf
                vim.cmd "enew"
            end
        end, 50) -- margen para que LSP configure floating windows
    end,
})

-- =========================================
-- BufEnter: limpiar buffer previo de la MISMA ventana
-- =========================================
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_get_current_buf()

        if is_floating_win(win) then
            return
        end

        if is_protected_buffer(buf) then
            return
        end

        -- Solo limpiar el buffer previo de la misma ventana
        local prev_buf = previous_buffers[win]
        if prev_buf and prev_buf ~= buf and vim.api.nvim_buf_is_valid(prev_buf) then
            -- Verificar que el buffer no esté visible en otras ventanas
            local wins = vim.fn.win_findbuf(prev_buf)
            local is_visible_elsewhere = false
            for _, w in ipairs(wins) do
                if w ~= win and vim.api.nvim_win_is_valid(w) then
                    is_visible_elsewhere = true
                    break
                end
            end

            if
                not is_protected_buffer(prev_buf)
                and not vim.api.nvim_buf_get_option(prev_buf, "modified")
                and not is_visible_elsewhere
            then
                pcall(function()
                    vim.api.nvim_buf_delete(prev_buf, { force = true })
                end)
            end
        end

        previous_buffers[win] = buf
    end,
})

-- ===========================================================
-- BufLeave: registrar buffer previo
-- ===========================================================
vim.api.nvim_create_autocmd("BufLeave", {
    callback = function(args)
        local win = vim.api.nvim_get_current_win()
        if is_floating_win(win) then
            return
        end

        local buf = args.buf
        if is_protected_buffer(buf) then
            return
        end

        local bufname = vim.fn.bufname(buf)
        local line_count = vim.fn.line "$"
        local first_line = vim.fn.getline(1)

        if bufname ~= "" or line_count > 1 or first_line ~= "" then
            previous_buffers[win] = buf
        end
    end,
})

-- ===========================================================
-- WinClosed: limpiar registro
-- ===========================================================
vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
        local win_id = tonumber(args.match)
        previous_buffers[win_id] = nil
    end,
})

-- ===========================================================
-- Manejo de cierre de ventanas con buffers modificados
-- ===========================================================
vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
        local win_id = tonumber(args.match)
        if is_floating_win(win_id) then
            return
        end

        local buf = vim.api.nvim_win_get_buf(win_id)

        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(buf) then
                return
            end
            if is_protected_buffer(buf) then
                return
            end

            local bufname = vim.api.nvim_buf_get_name(buf)
            local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "Buffer " .. buf

            if vim.api.nvim_buf_get_option(buf, "modified") then
                if vim.ui then
                    vim.ui.select({
                        "💾 Save file",
                        "❌ Close anyways",
                        "🔙 Go back",
                    }, {
                        prompt = "File '" .. filename .. "' has unsaved changes:",
                        format_item = function(item)
                            return item
                        end,
                    }, function(choice)
                        if choice == "💾 Save file" then
                            vim.api.nvim_buf_call(buf, function()
                                vim.cmd "w"
                            end)
                            vim.api.nvim_buf_delete(buf, { force = true })
                        elseif choice == "❌ Close anyways" then
                            vim.api.nvim_buf_delete(buf, { force = true })
                        end
                    end)
                else
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(buf, { force = false })
                    end)
                end
            else
                local buf_windows = vim.fn.win_findbuf(buf)
                local is_visible = false
                for _, win in ipairs(buf_windows) do
                    if vim.api.nvim_win_is_valid(win) then
                        is_visible = true
                        break
                    end
                end
                if not is_visible then
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            end
        end, 10)
    end,
})

-- ===========================================================
-- Autocomando específico para dashboard
-- ===========================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dashboard",
    callback = function()
        vim.opt_local.bufhidden = "hide"
        vim.opt_local.buflisted = false
    end,
})
