require "nvchad.options"
local opt = vim.opt
local o = vim.o
local g = vim.g

-- Indenting
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4
o.relativenumber = true

-- Folding por indentación
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99       -- Evita que se pliegue automáticamente al abrir
vim.o.foldenable = false   -- No activar folding al abrir

opt.wrap = false

vim.g.copilot_filetypes = {
    ["*"] = true,
    ["markdown"] = true,
    ["bash"] = true,
    ["text"] = false,
    ["help"] = false,
    ["TelescopePrompt"] = false,
}
