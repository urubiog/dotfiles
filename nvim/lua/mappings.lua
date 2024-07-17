require "nvchad.mappings"

local map = vim.keymap.set
local cmd = vim.cmd
local M = {}

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
map("v", "<F5>", "<")
map("v", "<F6>", ">")


-- Formaters
-- map("n", "<C-u>", "<cmd>!black %<CR><CR>")
map("n", "<C-y>", "<cmd>lua vim.lsp.buf.format()<CR>")
map("n", "<C-u>", "<cmd>FormatWriteLock<CR>")

-- Shortcuts
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-a>", "ggVG")
map("v", '<C-d>', '"_dd', { noremap = true, silent = true })
map("n", '<C-d>', '"_dd', { noremap = true, silent = true })
map("v", '<C-d>', '"_dd', { noremap = true, silent = true })
map("n", "_", "<cmd>Dashboard<CR>")

cmd("lua require('lazygit')")
cmd("colorscheme nvchad")
cmd("highlight Visual guibg=#808080 guifg=#ffffff ctermbg=4 ctermfg=15")
