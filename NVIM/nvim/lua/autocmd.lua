require "nvchad.autocmds"

local cmd = vim.cmd

cmd("lua require('lazygit')")

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.schedule(function()
            vim.cmd("colorscheme nvchad")
        end)
    end,
})

-- Mantener registro del buffer anterior por ventana
local previous_buffers = {}

-- Función para verificar si es un buffer que debe protegerse
local function is_protected_buffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
        return true
    end

    local bufname = vim.api.nvim_buf_get_name(buf)
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

    -- Buffers que NO deben eliminarse automáticamente
    local protected_buffers = {
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
        ""
    }

    for _, protected in ipairs(protected_buffers) do
        if filetype == protected or bufname == protected then
            return true
        end
    end

    -- Verificar si es un buffer de plugin
    if string.match(bufname, "dashboard") or
        string.match(bufname, "NvimTree") or
        string.match(bufname, "Telescope") then
        return true
    end

    return false
end

-- Autocomando para cuando se crea una nueva ventana
vim.api.nvim_create_autocmd("WinNew", {
    callback = function()
        vim.defer_fn(function()
            local current_win = vim.api.nvim_get_current_win()
            local current_buf = vim.api.nvim_win_get_buf(current_win)

            -- No hacer nada si es un buffer protegido
            if is_protected_buffer(current_buf) then
                return
            end

            -- Solo proceder si el buffer actual no está vacío
            local bufname = vim.fn.bufname(current_buf)
            local line_count = vim.fn.line("$")
            local first_line = vim.fn.getline(1)

            if bufname ~= "" or line_count > 1 or first_line ~= "" then
                previous_buffers[current_win] = current_buf
                vim.cmd("enew")
            end
        end, 10)
    end,
})

-- -- Manejar cuando un buffer entra en una ventana
-- vim.api.nvim_create_autocmd("BufEnter", {
--     callback = function()
--         local current_win = vim.api.nvim_get_current_win()
--         local current_buf = vim.api.nvim_get_current_buf()
--         local prev_buf = previous_buffers[current_win]
--
--         -- No hacer nada si el buffer actual está protegido
--         if is_protected_buffer(current_buf) then
--             return
--         end
--
--         -- Limpiar buffer anterior si existe y es seguro hacerlo
--         if prev_buf and prev_buf ~= current_buf and vim.api.nvim_buf_is_valid(prev_buf) then
--             -- Verificar si el buffer anterior está protegido
--             if is_protected_buffer(prev_buf) then
--                 previous_buffers[current_win] = nil
--                 return
--             end
--
--             -- Verificar condiciones para eliminar
--             local windows_with_prev_buf = vim.fn.win_findbuf(prev_buf)
--             local is_modified = vim.api.nvim_buf_get_option(prev_buf, "modified")
--
--             if #windows_with_prev_buf == 0 and not is_modified then
--                 -- Intentar eliminar de manera segura
--                 pcall(function()
--                     vim.api.nvim_buf_delete(prev_buf, { force = true })
--                 end)
--             end
--             previous_buffers[current_win] = nil
--         end
--     end,
-- })
--
-- -- Limpiar buffer anterior cuando se cambia a un nuevo buffer
-- vim.api.nvim_create_autocmd("BufLeave", {
--     callback = function(args)
--         local buf = args.buf
--         local current_win = vim.api.nvim_get_current_win()
--
--         -- No registrar buffers protegidos
--         if is_protected_buffer(buf) then
--             return
--         end
--
--         -- Solo registrar buffers no vacíos
--         local bufname = vim.fn.bufname(buf)
--         local line_count = vim.fn.line("$")
--         local first_line = vim.fn.getline(1)
--
--         if bufname ~= "" or line_count > 1 or first_line ~= "" then
--             previous_buffers[current_win] = buf
--         end
--     end,
-- })

-- Limpiar registro cuando se cierra una ventana
vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
        local win_id = tonumber(args.match)
        previous_buffers[win_id] = nil
    end,
})

-- Manejo de cierre de ventanas CON POPUP para buffers modificados
vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
        local win_id = tonumber(args.match)
        local buf = vim.api.nvim_win_get_buf(win_id)

        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(buf) then return end

            -- No procesar buffers protegidos
            if is_protected_buffer(buf) then
                return
            end

            local bufname = vim.api.nvim_buf_get_name(buf)
            local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "Buffer " .. buf

            if vim.api.nvim_buf_get_option(buf, "modified") then
                -- Usar vim.ui.select si está disponible (con plugins como telescope, fzf, etc.)
                if vim.ui then
                    vim.ui.select({
                        "💾 Save file",
                        "❌ Close anyways",
                        "🔙 Go back"
                    }, {
                        prompt = "File '" .. filename .. "' has unsaved changes:",
                        format_item = function(item)
                            return item
                        end,
                    }, function(choice)
                        if choice == "💾 Save file" then
                            vim.api.nvim_buf_call(buf, function()
                                vim.cmd("w")
                            end)
                            vim.api.nvim_buf_delete(buf, { force = true })
                        elseif choice == "❌ Close anyways" then
                            vim.api.nvim_buf_delete(buf, { force = true })
                        end
                        -- Si es "Go back", no hacer nada
                    end)
                else
                    -- Fallback al método nativo
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(buf, { force = false }) -- force=false muestra confirmación nativa
                    end)
                end
            else
                -- No tiene cambios, verificar si está visible en otras ventanas
                local buf_windows = vim.fn.win_findbuf(buf)
                local is_visible = false

                for _, win in ipairs(buf_windows) do
                    if vim.api.nvim_win_is_valid(win) then
                        is_visible = true
                        break
                    end
                end

                -- Solo eliminar si no está visible en otras ventanas
                if not is_visible then
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            end
        end, 10)
    end,
})

-- Autocomando adicional para proteger específicamente el dashboard
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dashboard",
    callback = function()
        vim.opt_local.bufhidden = "hide"
        vim.opt_local.buflisted = false
    end,
})
