require "nvchad.mappings"

local map = vim.keymap.set

-- Motions 
map("n", "<C-d>", "<C-d>zz")
map("v", "<C-d>", "<C-d>zz")
map("n", "<C-e>", "<C-u>zz", { noremap = true, silent = true })
map("v", "<C-e>", "<C-u>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-x>")
map("n", "<S-Up>", "H")
map("n", "<S-Down>", "L")
map("n", "<C-s>", "<cmd>w<CR>")

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>")
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>")

-- F2 vscode functionallity (renamer)
map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

-- Signature help
map("n", "<F3>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })

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
map("v", '<leader>dd', '"_dd', { noremap = true, silent = true })
map("v", 'dd', 'Vd', { noremap = true, silent = true })
map("n", 'dd', 'Vd', { noremap = true, silent = true })
map("n", '<leader>dd', '"_dd', { noremap = true, silent = true })
map("n", "_", "<cmd>Dashboard<CR>")

-- Visualmode move codeblock
map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Debugging 
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")

local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"}
    }
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>drp"] = {
            function ()
                require("dap-python").test_method()
            end
        }
    }
}

return M
