require "nvchad.mappings"

local map = vim.keymap.set

-- -- Sistema de marcas persistentes
-- local persistent_marks = {}
--
-- -- Ruta del archivo donde guardar las marcas
-- local marks_file = vim.fn.stdpath("data") .. "/persistent_marks.lua"
--
-- -- Cargar marcas guardadas
-- local function load_persistent_marks()
--     local ok, data = pcall(dofile, marks_file)
--     if ok and data then
--         persistent_marks = data
--     else
--         persistent_marks = {}
--     end
-- end
--
-- -- Guardar marcas
-- local function save_persistent_marks()
--     local file = io.open(marks_file, "w")
--     if file then
--         file:write("return {\n")
--         for mark_name, mark_data in pairs(persistent_marks) do
--             if mark_data and mark_data.file then
--                 file:write(string.format("  [%q] = { file = %q, line = %d, col = %d },\n",
--                     mark_name, mark_data.file, mark_data.line or 1, mark_data.col or 1))
--             end
--         end
--         file:write("}\n")
--         file:close()
--     end
-- end
--
-- -- Validar y limpiar marcas
-- local function validate_and_clean_marks()
--     local valid_marks = {}
--     local cleaned_count = 0
--
--     for mark_char, mark_data in pairs(persistent_marks) do
--         if mark_data and
--             mark_data.file and
--             type(mark_data.line) == "number" and
--             type(mark_data.col) == "number" and
--             vim.fn.filereadable(mark_data.file) == 1 then
--             valid_marks[mark_char] = mark_data
--         else
--             cleaned_count = cleaned_count + 1
--         end
--     end
--
--     if cleaned_count > 0 then
--         vim.notify("Cleaned " .. cleaned_count .. " invalid marks", vim.log.levels.INFO)
--     end
--
--     persistent_marks = valid_marks
--     save_persistent_marks()
-- end
--
-- -- Establecer marca persistente
-- local function set_persistent_mark(mark_char)
--     local file_path = vim.fn.expand("%:p")
--     local line = vim.fn.line(".")
--     local col = vim.fn.col(".")
--
--     if file_path == "" then
--         vim.notify("Cannot set mark in unnamed buffer", vim.log.levels.WARN)
--         return false
--     end
--
--     -- Validar caracter de marca
--     if not string.match(mark_char, "^[A-Za-z]$") then
--         vim.notify("Invalid mark character. Use single letters only.", vim.log.levels.WARN)
--         return false
--     end
--
--     -- Usar siempre mayúsculas para consistencia
--     mark_char = string.upper(mark_char)
--
--     persistent_marks[mark_char] = {
--         file = file_path,
--         line = line,
--         col = col
--     }
--
--     save_persistent_marks()
--     vim.notify("Persistent mark '" .. mark_char .. "' set at " .. vim.fn.fnamemodify(file_path, ":t") .. ":" .. line)
--     return true
-- end
--
-- -- Ir a marca persistente
-- local function goto_persistent_mark(mark_char)
--     -- Validar caracter
--     if not string.match(mark_char, "^[A-Za-z]$") then
--         vim.notify("Invalid mark character. Use single letters only.", vim.log.levels.WARN)
--         return false
--     end
--
--     mark_char = string.upper(mark_char)
--     local mark_data = persistent_marks[mark_char]
--
--     if not mark_data then
--         vim.notify("Persistent mark '" .. mark_char .. "' not found", vim.log.levels.WARN)
--         return false
--     end
--
--     -- Verificar si el archivo existe
--     if vim.fn.filereadable(mark_data.file) == 0 then
--         vim.notify("File not found: " .. mark_data.file, vim.log.levels.ERROR)
--         -- Eliminar marca inválida
--         persistent_marks[mark_char] = nil
--         save_persistent_marks()
--         return false
--     end
--
--     -- Abrir el archivo
--     local current_buf = vim.api.nvim_get_current_buf()
--     local current_file = vim.fn.expand("%:p")
--
--     if current_file ~= mark_data.file then
--         vim.cmd("edit " .. vim.fn.fnameescape(mark_data.file))
--     end
--
--     -- Mover cursor a la posición
--     vim.fn.cursor(mark_data.line, mark_data.col)
--
--     -- Centrar la ventana
--     vim.cmd("normal! zz")
--
--     vim.notify("Jumped to persistent mark '" .. mark_char .. "' in " .. vim.fn.fnamemodify(mark_data.file, ":t"))
--     return true
-- end
--
-- -- Listar todas las marcas persistentes
-- local function list_persistent_marks()
--     if vim.tbl_isempty(persistent_marks) then
--         vim.notify("No persistent marks set", vim.log.levels.INFO)
--         return
--     end
--
--     local marks_list = {}
--     for mark_char, mark_data in pairs(persistent_marks) do
--         if mark_data and mark_data.file then
--             local filename = vim.fn.fnamemodify(mark_data.file, ":t")
--             local exists = vim.fn.filereadable(mark_data.file) == 1
--             local status = exists and "✓" or "✗"
--
--             table.insert(marks_list, {
--                 value = mark_char,
--                 display = string.format("%s %s: %s:%d:%d", status, mark_char, filename, mark_data.line, mark_data.col),
--                 file = mark_data.file,
--                 line = mark_data.line,
--                 col = mark_data.col,
--                 exists = exists
--             })
--         end
--     end
--
--     if #marks_list == 0 then
--         vim.notify("No valid persistent marks", vim.log.levels.INFO)
--         return
--     end
--
--     table.sort(marks_list, function(a, b) return a.value < b.value end)
--
--     vim.ui.select(marks_list, {
--         prompt = "Persistent Marks:",
--         format_item = function(item)
--             return item.display
--         end,
--     }, function(choice)
--         if choice then
--             if choice.exists then
--                 goto_persistent_mark(choice.value)
--             else
--                 vim.notify("File no longer exists: " .. choice.file, vim.log.levels.ERROR)
--                 -- Opción para eliminar la marca
--                 vim.ui.select({ "Delete mark", "Cancel" }, {
--                     prompt = "File not found. Delete this mark?",
--                 }, function(action)
--                     if action == "Delete mark" then
--                         persistent_marks[choice.value] = nil
--                         save_persistent_marks()
--                         vim.notify("Mark '" .. choice.value .. "' deleted")
--                     end
--                 end)
--             end
--         end
--     end)
-- end
--
-- -- Eliminar marca específica
-- local function delete_persistent_mark(mark_char)
--     if not string.match(mark_char, "^[A-Za-z]$") then
--         vim.notify("Invalid mark character", vim.log.levels.WARN)
--         return false
--     end
--
--     mark_char = string.upper(mark_char)
--
--     if persistent_marks[mark_char] then
--         persistent_marks[mark_char] = nil
--         save_persistent_marks()
--         vim.notify("Persistent mark '" .. mark_char .. "' deleted")
--         return true
--     else
--         vim.notify("Persistent mark '" .. mark_char .. "' not found", vim.log.levels.WARN)
--         return false
--     end
-- end
--
-- -- Cargar y validar marcas al iniciar
-- load_persistent_marks()
-- validate_and_clean_marks()

-- Motions (tus mappings existentes)
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
map("v", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
map("n", "<C-e>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up half page and center" })
map("v", "<C-e>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up half page and center" })
map("n", "<C-u>", "<C-x>", { desc = "Scroll up one line" })
map("n", "<S-Up>", "H", { noremap = true, silent = true, desc = "Move to top of screen" })
map("n", "<S-Down>", "L", { noremap = true, silent = true, desc = "Move to bottom of screen" })
map("n", "<C-s>", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Save file" })

-- Window navigation
map("n", "<A-Left>", "<C-w>h", { noremap = true, silent = true, desc = "Move to left window" })
map("n", "<A-Right>", "<C-w>l", { noremap = true, silent = true, desc = "Move to right window" })
map("n", "<A-Up>", "<C-w>j", { noremap = true, silent = true, desc = "Move to bottom window" })
map("n", "<A-Down>", "<C-w>k", { noremap = true, silent = true, desc = "Move to top window" })

-- Window resizing
map("n", "<C-S-Left>", "<C-w><lt>", { noremap = true, silent = true, desc = "Decrease window width" })
map("n", "<C-S-Right>", "<C-w>>", { noremap = true, silent = true, desc = "Increase window width" })
map("n", "<C-S-Up>", "<C-w>+", { noremap = true, silent = true, desc = "Increase window height" })
map("n", "<C-S-Down>", "<C-w>-", { noremap = true, silent = true, desc = "Decrease window height" })

-- -- Sistema de marcas persistentes MEJORADO
-- map("n", "m", function()
--     local char = vim.fn.nr2char(vim.fn.getchar())
--     set_persistent_mark(char)
-- end, { noremap = true, silent = true, desc = "Set persistent mark" })
--
-- map("n", "'", function()
--     local char = vim.fn.nr2char(vim.fn.getchar())
--     goto_persistent_mark(char)
-- end, { noremap = true, silent = true, desc = "Go to persistent mark" })
--
-- -- Mappings adicionales para mejor control
-- map("n", "<leader>ml", list_persistent_marks, { noremap = true, silent = true, desc = "List persistent marks" })
--
-- map("n", "<leader>md", function()
--     local char = vim.fn.nr2char(vim.fn.getchar())
--     delete_persistent_mark(char)
-- end, { noremap = true, silent = true, desc = "Delete persistent mark" })
--
-- map("n", "<leader>mc", function()
--     vim.ui.select({ "Yes", "No" }, {
--         prompt = "Clear ALL persistent marks?",
--     }, function(choice)
--         if choice == "Yes" then
--             persistent_marks = {}
--             save_persistent_marks()
--             vim.notify("All persistent marks cleared", vim.log.levels.INFO)
--         end
--     end)
-- end, { noremap = true, silent = true, desc = "Clear all persistent marks" })
--
-- map("n", "<leader>mv", validate_and_clean_marks, { noremap = true, silent = true, desc = "Validate and clean marks" })
--
-- -- Navegación entre marcas (compatible con marcas nativas)
-- map("n", "<Tab>", "<leader>ml1<CR>", { noremap = true, silent = true, desc = "Go to next mark" })
-- -- map("n", "<S-Tab>", "'[", { noremap = true, silent = true, desc = "Go to previous mark" })
--
-- -- Autocomando para limpiar marcas cuando se elimina un buffer
-- vim.api.nvim_create_autocmd("BufDelete", {
--     callback = function(args)
--         local bufname = vim.api.nvim_buf_get_name(args.buf)
--         if bufname ~= "" then
--             validate_and_clean_marks()
--         end
--     end,
-- })

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })

-- LSP
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true, desc = "Rename symbol" })
map("n", "<C-Space>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    { noremap = true, silent = true, desc = "Signature help" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true, desc = "Code actions" })

-- Diagnostics
map("n", "<F4>", "<cmd>lopen<CR>", { noremap = true, silent = true, desc = "Open location list" })

-- Indentation
map("n", "<F5>", "<cmd><<CR>", { noremap = true, silent = true, desc = "Decrease indent" })
map("n", "<F6>", "<cmd>><CR>", { noremap = true, silent = true, desc = "Increase indent" })
map("i", "<F5>", "<", { noremap = true, silent = true, desc = "Insert less than" })
map("i", "<F6>", ">", { noremap = true, silent = true, desc = "Insert greater than" })
map("v", "<F5>", "<", { noremap = true, silent = true, desc = "Shift left" })
map("v", "<F6>", ">", { noremap = true, silent = true, desc = "Shift right" })

-- Formatting
map("n", "<C-y>", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true, desc = "Format buffer" })

-- Shortcuts
map("n", ";", ":", { noremap = true, desc = "Enter command mode" })
map("n", "<leader>a", "ggVG", { noremap = true, silent = true, desc = "Select all" })
map("v", "<leader>dd", '"_dd', { noremap = true, silent = true, desc = "Delete selection without yanking" })
map("v", "dd", "Vd", { noremap = true, silent = true, desc = "Delete line in visual mode" })
map("n", "dd", "Vd", { noremap = true, silent = true, desc = "Delete line" })
map("n", "<leader>dd", '"_dd', { noremap = true, silent = true, desc = "Delete line without yanking" })
map("n", "_", "<cmd>Dashboard<CR>", { noremap = true, silent = true, desc = "Open dashboard" })
map("i", "<C-H>", "<C-w>", { noremap = true, silent = true, desc = "Delete word backwards" })

-- Visual mode line moving
map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Bracket wrapping
map("v", "(", "c(<C-r>+)", { noremap = true, silent = true, desc = "Wrap selection in parentheses" })

-- Debugging
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { noremap = true, silent = true, desc = "Toggle breakpoint" })

-- Folding
local function toggle_all_folds()
    if vim.wo.foldlevel > 0 then
        vim.cmd("normal! zM") -- Cierra todo
    else
        vim.cmd("normal! zR") -- Abre todo
    end
end

map("n", "zA", toggle_all_folds, { noremap = true, silent = true, desc = "Toggle all folds in buffer" })

local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {
            "<cmd> DapToggleBreakpoint <CR>",
            { noremap = true, silent = true, desc = "Toggle breakpoint" }
        }
    }
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>drp"] = {
            function()
                require("dap-python").test_method()
            end,
            { noremap = true, silent = true, desc = "Debug Python test method" }
        }
    }
}

return M
