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
o.foldmethod = "indent"
o.foldlevel = 99     -- Evita que se pliegue automáticamente al abrir
o.foldenable = false -- No activar folding al abrir

o.showtabline = 0

opt.wrap = false

g.browser = "firefox"
g.BROWSER = "firefox"

vim.g.clipboard = "xclip"

vim.g.copilot_filetypes = {
    ["*"] = true,
    ["markdown"] = true,
    ["bash"] = true,
    ["text"] = false,
    ["help"] = false,
    ["TelescopePrompt"] = false,
}
