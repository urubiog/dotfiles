require "nvchad.mappings"

local map = vim.keymap.set

-- Sistema de marcas persistentes (versión simplificada y segura)
local persistent_marks = {}
local marks_file = vim.fn.stdpath "data" .. "/persistent_marks.lua"

-- Cargar marcas guardadas
local function load_persistent_marks()
    local ok, data = pcall(dofile, marks_file)
    if ok and data then
        persistent_marks = data
    else
        persistent_marks = {}
    end
end

-- Guardar marcas
local function save_persistent_marks()
    local file = io.open(marks_file, "w")
    if file then
        file:write "return {\n"
        for mark_name, mark_data in pairs(persistent_marks) do
            if mark_data and mark_data.file then
                file:write(
                    string.format(
                        "  [%q] = { file = %q, line = %d, col = %d },\n",
                        mark_name,
                        mark_data.file,
                        mark_data.line or 1,
                        mark_data.col or 1
                    )
                )
            end
        end
        file:write "}\n"
        file:close()
    end
end

-- Validar marca
local function is_valid_mark(mark_data)
    return mark_data
        and mark_data.file
        and type(mark_data.line) == "number"
        and type(mark_data.col) == "number"
        and vim.fn.filereadable(mark_data.file) == 1
end

-- Limpiar marcas inválidas
local function clean_invalid_marks()
    local valid_marks = {}
    for mark_char, mark_data in pairs(persistent_marks) do
        if is_valid_mark(mark_data) then
            valid_marks[mark_char] = mark_data
        end
    end
    persistent_marks = valid_marks
    save_persistent_marks()
end

-- Establecer marca persistente (versión segura)
local function set_persistent_mark(mark_char)
    local file_path = vim.fn.expand "%:p"
    local line = vim.fn.line "."
    local col = vim.fn.col "."

    if file_path == "" then
        vim.notify("Cannot set mark in unnamed buffer", vim.log.levels.WARN)
        return false
    end

    if not string.match(mark_char, "^[A-Za-z]$") then
        vim.notify("Invalid mark character. Use single letters only.", vim.log.levels.WARN)
        return false
    end

    mark_char = string.upper(mark_char)

    persistent_marks[mark_char] = {
        file = file_path,
        line = line,
        col = col,
    }

    save_persistent_marks()
    vim.notify("Persistent mark '" .. mark_char .. "' set at " .. vim.fn.fnamemodify(file_path, ":t") .. ":" .. line)
    return true
end

-- Ir a marca persistente (versión segura)
local function goto_persistent_mark(mark_char)
    if not string.match(mark_char, "^[A-Za-z]$") then
        vim.notify("Invalid mark character. Use single letters only.", vim.log.levels.WARN)
        return false
    end

    mark_char = string.upper(mark_char)
    local mark_data = persistent_marks[mark_char]

    if not mark_data then
        vim.notify("Persistent mark '" .. mark_char .. "' not found", vim.log.levels.WARN)
        return false
    end

    if not is_valid_mark(mark_data) then
        vim.notify("Mark '" .. mark_char .. "' points to invalid file: " .. mark_data.file, vim.log.levels.ERROR)
        persistent_marks[mark_char] = nil
        save_persistent_marks()
        return false
    end

    -- Usar una forma más segura de abrir archivos
    local ok, result = pcall(function()
        vim.cmd("edit " .. vim.fn.fnameescape(mark_data.file))
        vim.fn.cursor(mark_data.line, mark_data.col)
        vim.cmd "normal! zz"
    end)

    if ok then
        vim.notify("Jumped to persistent mark '" .. mark_char .. "' in " .. vim.fn.fnamemodify(mark_data.file, ":t"))
        return true
    else
        vim.notify("Error jumping to mark: " .. result, vim.log.levels.ERROR)
        return false
    end
end

-- Navegación entre marcas globales (versión simplificada)
local function goto_next_global_mark()
    local global_marks = {}

    -- Recopilar marcas globales válidas
    for mark_char, mark_data in pairs(persistent_marks) do
        if string.match(mark_char, "^[A-Z]$") and is_valid_mark(mark_data) then
            table.insert(global_marks, {
                char = mark_char,
                data = mark_data,
            })
        end
    end

    if #global_marks == 0 then
        vim.notify("No global marks set", vim.log.levels.INFO)
        return
    end

    -- Ordenar alfabéticamente
    table.sort(global_marks, function(a, b)
        return a.char < b.char
    end)

    -- Navegación simple: ir a la primera marca
    local first_mark = global_marks[1]
    if first_mark then
        goto_persistent_mark(first_mark.char)
    end
end

local function goto_prev_global_mark()
    local global_marks = {}

    -- Recopilar marcas globales válidas
    for mark_char, mark_data in pairs(persistent_marks) do
        if string.match(mark_char, "^[A-Z]$") and is_valid_mark(mark_data) then
            table.insert(global_marks, {
                char = mark_char,
                data = mark_data,
            })
        end
    end

    if #global_marks == 0 then
        vim.notify("No global marks set", vim.log.levels.INFO)
        return
    end

    -- Ordenar alfabéticamente
    table.sort(global_marks, function(a, b)
        return a.char < b.char
    end)

    -- Navegación simple: ir a la última marca
    local last_mark = global_marks[#global_marks]
    if last_mark then
        goto_persistent_mark(last_mark.char)
    end
end

-- Listar marcas (versión segura)
local function list_persistent_marks()
    if vim.tbl_isempty(persistent_marks) then
        vim.notify("No persistent marks set", vim.log.levels.INFO)
        return
    end

    local marks_list = {}
    for mark_char, mark_data in pairs(persistent_marks) do
        if mark_data and mark_data.file then
            local filename = vim.fn.fnamemodify(mark_data.file, ":t")
            local exists = is_valid_mark(mark_data)
            local status = exists and "✓" or "✗"

            table.insert(marks_list, {
                value = mark_char,
                display = string.format("%s %s: %s:%d:%d", status, mark_char, filename, mark_data.line, mark_data.col),
                file = mark_data.file,
                exists = exists,
            })
        end
    end

    table.sort(marks_list, function(a, b)
        return a.value < b.value
    end)

    vim.ui.select(marks_list, {
        prompt = "Persistent Marks:",
        format_item = function(item)
            return item.display
        end,
    }, function(choice)
        if choice and choice.exists then
            goto_persistent_mark(choice.value)
        elseif choice then
            vim.notify("File no longer exists: " .. choice.file, vim.log.levels.ERROR)
        end
    end)
end

-- Cargar y limpiar marcas al iniciar
load_persistent_marks()
clean_invalid_marks()

-- Motions básicas (sin cambios)
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
map("v", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
map("n", "<C-s>", "<cmd>w<CR>", { noremap = true, silent = true, desc = "Save file" })
map("n", "<C-e>", "<C-u>zz", { desc = "Scroll up half page and center" })

-- Window navigation
map("n", "<A-Left>", "<C-w>h", { noremap = true, silent = true, desc = "Move to left window" })
map("n", "<A-Right>", "<C-w>l", { noremap = true, silent = true, desc = "Move to right window" })
map("n", "<A-Up>", "<C-w>j", { noremap = true, silent = true, desc = "Move to up window" })
map("n", "<A-Down>", "<C-w>k", { noremap = true, silent = true, desc = "Move to down window" })

map("n", "<C-S-Left>", "<C-w><", { noremap = true, silent = true, desc = "Increment window size to left" })
map("n", "<C-S-Right>", "<C-w>>", { noremap = true, silent = true, desc = "Increment window size to right" })
map("n", "<C-S-Up>", "<C-w>+", { noremap = true, silent = true, desc = "Increment window vertical size" })
map("n", "<C-S-Down>", "<C-w>-", { noremap = true, silent = true, desc = "Decrement window vertical size" })

-- Sistema de marcas persistentes (SIMPLIFICADO)
map("n", "m", function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    set_persistent_mark(char)
end, { noremap = true, silent = true, desc = "Set persistent mark" })

map("n", "'", function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    goto_persistent_mark(char)
end, { noremap = true, silent = true, desc = "Go to persistent mark" })

-- Navegación entre marcas GLOBALES (versión simplificada)
map("n", "<Tab>", goto_next_global_mark, { noremap = true, silent = true, desc = "Go to next global mark" })
map("n", "<S-Tab>", goto_prev_global_mark, { noremap = true, silent = true, desc = "Go to previous global mark" })

-- Comando para listar marcas
map("n", "<leader>ml", list_persistent_marks, { noremap = true, silent = true, desc = "List persistent marks" })

-- Limpiar todas las marcas
map("n", "<leader>mc", function()
    persistent_marks = {}
    save_persistent_marks()
    vim.notify("All persistent marks cleared", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Clear all persistent marks" })

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>")
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>")

-- F2 vscode functionallity (renamer)
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })

-- Signature help
map("n", "<C-Space>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })

-- Code actions
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = false })

-- Lsp Hover
map("n", "<C-Space>", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

-- Lsp diagnostic
map("n", "<F4>", "<cmd>lopen<CR>", { noremap = true, silent = true })

-- Indentation and "<",">"
map("n", "<F5>", "<cmd><<CR>")
map("n", "<F6>", "<cmd>><CR>")
map("i", "<F5>", "<")
map("i", "<F6>", ">")
map("v", "<F5>", "<")
map("v", "<F6>", ">")

-- Formaters
map("n", "<C-y>", "<cmd>lua vim.lsp.buf.format()<CR>")

-- Shortcuts
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>a", "ggVG")
map("v", "<leader>dd", '"_dd', { noremap = true, silent = true })
map("v", "dd", "Vd", { noremap = true, silent = true })
map("n", "dd", "Vd", { noremap = true, silent = true })
map("n", "<leader>dd", '"_dd', { noremap = true, silent = true })
map("n", "_", "<cmd>Dashboard<CR>")
map("i", "<C-H>", "<C-w>")

-- Visualmode move codeblock
map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Bracket wrap
map("v", "(", "c(<C-r>+)")

-- Debugging
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")

-- Folding
local function toggle_all_folds()
    -- foldlevel alto = todo abierto, foldlevel bajo = todo cerrado
    if vim.wo.foldlevel > 0 then
        vim.cmd "normal! zM" -- Cierra todo
    else
        vim.cmd "normal! zR" -- Abre todo
    end
end

map("n", "zA", toggle_all_folds, { desc = "Toggle all folds in buffer" })

local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
    },
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>drp"] = {
            function()
                require("dap-python").test_method()
            end,
        },
    },
}

return M
