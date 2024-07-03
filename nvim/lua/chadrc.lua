-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

-- Load necessary modules
local os = require("os")

-- Function to get current date in a specific format
local function getCurrentDate()
    return os.date("%Y-%m-%d")  -- Format as YYYY-MM-DD
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
local version_str = table.concat({nvim_version.major, nvim_version.minor, nvim_version.patch}, ".")

M.ui = {
  theme = "catppuccin",
  transparency=true,
  nvdash = {
    header = {
      "             _nnnn_                       Welcome...                                             ",
      "            dGGGGMMb                     .-------------------------------------------.           ",
      string.format("           @p~qp~~qMb                    |     {DatePlhldr}   ♔ PrivUr1x   v%s     |           ", version_str),
      "           M|@||@) M|                    ·-------------------------------------------·           ",
      "           @,----.JM|                                                                            ",
      "          JS^\\__/  qKL         ,---,---,---,---,---,---,---,---,---,---,---,---,---,-------,    ",
      "         dZP        qKRb        | ~ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | [ | ] | <-    |    ",
      "        dZP          qKKb       |---'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-----|    ",
      "       fZP            SMMb      | ->| | Q | W | E | R | T | Y | U | I | O | P | / | = |  \\  |    ",
      "       HZM            MMMM      |-----',--',--',--',--',--',--',--',--',--',--',--',--'-----|    ",
      "       FqM            MMMM      | Caps | A | S | D | F | G | H | J | K | L | Ñ | - |  Enter |    ",
      "     __| '.        |\\dS'qML     |------'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'--------|    ",
      "     |    `.       | `' \\Zq     |        | Z | X | C | V | B | N | M | , | . | - |          |    ",
      "    _)      \\.___.,|     .'     |------,-',--'--,'---'---'---'---'---'---'-,-'---',--,------|    ",
      "    \\____   )MMMMMP|   .'       | ctrl |  | alt |                          | alt  |  | ctrl |    ",
      "         `-'       `--' hjm     '------'  '-----'--------------------------'------'  '------'    ",
    },
    buttons = {
        { "  Find File", "<C-p>", "Telescope find_files" },
        { "󰈚  Recent Files", "<Spc-f-o>", "Telescope oldfiles" },
        { "󰈭  Find Word", "<C-f>", "Telescope live_grep" },
        { "  Themes", "<Spc-t-h>", "Telescope themes" },
        { "  Mappings", "<Spc-c-h>", "NvCheatsheet" },
        { "💤 Lazy", "", "Lazy" },
        { "❌ Close", "_", "q!" }
    },
  },
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

M.plugins = "plugins.plugins"

return M
