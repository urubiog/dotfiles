-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

-- Load necessary modules
local os = require("os")

-- Function to get current date in a specific format
local function getCurrentDate()
    return os.date("%Y-%m-%d") -- Format as YYYY-MM-DD
end

---@type ChadrcConfig
local M = {}

M.general = {
    n = {
        ["<C-S-Left>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        ["<C-S-Right>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        ["<C-S-Down>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-S-Up>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
    }
}

-- Get Neovim version information
local nvim_version = vim.version()

-- Join major, minor, and patch with "."
local version_str = table.concat({ nvim_version.major, nvim_version.minor, nvim_version.patch }, ".")

M.base46 = {
    transparency = true,
}

M.ui = {
    theme = "catppuccin",
    transparency = true,
    colorify = {
        enabled = false,
    }
}

-- Insert date dynamically into the middle of the header
local dateStr = getCurrentDate()
local placeholder = "{DatePlhldr}"
local header = M.ui.nvdash.header

-- Find the index where the placeholder is located
local placeholderIndex
for i, line in ipairs(header) do
    if string.find(line, placeholder) then
        placeholderIndex = i
        break
    end
end

-- Replace the placeholder with the date
if placeholderIndex then
    header[placeholderIndex] = string.gsub(header[placeholderIndex], placeholder, dateStr)
end

-- M.cmds = require "autocmd"
-- M.dap_mappings = require "mappings"
-- M.plugins = "plugins.plugins"

return M
