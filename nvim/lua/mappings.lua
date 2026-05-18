require "nvchad.mappings"

local map = vim.keymap.set

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

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })
map("n", "<C-c>", function()
  require("telescope.builtin").find_files {
    cwd = vim.fn.stdpath "config",
  }
end, { desc = "Neovim config files" })

-- LSP
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true, desc = "Rename symbol" })
map("n", "<C-Space>", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true, desc = "Signature help" })
map(
  "n",
  "<leader>ca",
  "<cmd>lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true, desc = "Code actions" }
)

-- Indentation
map("n", "<F5>", "<cmd><<CR>", { noremap = true, silent = true, desc = "Decrease indent" })
map("n", "<F6>", "<cmd>><CR>", { noremap = true, silent = true, desc = "Increase indent" })
map("i", "<F5>", "<", { noremap = true, silent = true, desc = "Insert less than" })
map("i", "<F6>", ">", { noremap = true, silent = true, desc = "Insert greater than" })
map("v", "<F5>", "<", { noremap = true, silent = true, desc = "Shift left" })
map("v", "<F6>", ">", { noremap = true, silent = true, desc = "Shift right" })

-- Formatting
map("n", "<C-y>", "<cmd>lua require('conform').format()<CR>", { noremap = true, silent = true, desc = "Format buffer" })

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
map("v", "<S-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
map("v", "<S-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Bracket wrapping
map("v", "(", 'c(<C-r>")', { noremap = true, silent = true, desc = "Wrap selection in parentheses" })

-- Markdown writting
map("i", "<C-i>", "**<Left>", { noremap = true, silent = true, desc = "Italic text" })
map("i", "<C-b>", "****<Left><Left>", { noremap = true, silent = true, desc = "Bold text" })
map("i", "<C-t>", "~~<Left>", { noremap = true, silent = true, desc = "Strikethrough text" })
map("v", "<C-i>", "c*<C-r>+*", { noremap = true, silent = true, desc = "Italic text" })
map("v", "<C-b>", "c**<C-r>+**", { noremap = true, silent = true, desc = "Bold text" })
map("v", "<C-t>", "c~<C-r>+~", { noremap = true, silent = true, desc = "Strikethrough text" })

-- LspSaga
map("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", { noremap = true, silent = true, desc = "Peek definition" })

-- Folding
local function toggle_all_folds()
  if vim.wo.foldlevel > 0 then
    vim.cmd "normal! zM" -- Cierra todo
  else
    vim.cmd "normal! zR" -- Abre todo
  end
end

map("n", "zA", toggle_all_folds, { noremap = true, silent = true, desc = "Toggle all folds in buffer" })
