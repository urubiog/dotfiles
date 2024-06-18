require "nvchad.mappings"

local map = vim.keymap.set
local cmd = vim.cmd

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>")
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>")

-- F2 vscode functionallity
map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
-- map("n", "<F2>", "<space>ra") -- Actual pretty renamer

-- Formaters
-- map("n", "<C-u>", "<cmd>!black %<CR><CR>")
map("n", "<C-y>", "<cmd>lua vim.lsp.buf.format()<CR>")
map("n", "<C-u>", "<cmd>FormatWriteLock<CR>")

-- Shortcuts
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-a>", "ggVG")
map("v", '<C-d>', '"_dd', { noremap = true, silent = true })
map("n", '<C-d>', '"_dd', { noremap = true, silent = true })

cmd("colorscheme nvchad")

