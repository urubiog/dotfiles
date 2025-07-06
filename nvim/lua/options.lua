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

vim.g.copilot_filetypes = {
    ["*"] = true,
    ["markdown"] = true,
    ["bash"] = true,
    ["text"] = false,
    ["help"] = false,
    ["TelescopePrompt"] = false,
}
