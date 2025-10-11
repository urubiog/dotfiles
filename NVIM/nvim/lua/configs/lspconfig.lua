-- ~/.config/nvim/lua/configs/lspconfig.lua

local util = require("lspconfig.util")
local lsp_signature = require("lsp_signature")

-- Configuraciones predeterminadas de NvChad
local base_on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",  -- Puede usar →, ▸, etc.
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
})


-- Definir un on_attach que incluya lsp_signature
local on_attach = function(client, bufnr)
    -- Llamar al on_attach base de NvChad
    base_on_attach(client, bufnr)

    -- Activar lsp_signature
    lsp_signature.on_attach({
        bind = true,
        handler_opts = { border = "rounded" },
        floating_window_above_cur_line = true,
        hint_prefix = "",
        hint_enable = false,
    }, bufnr)
end

-- Servidores que usan configuración predeterminada
local default_servers = {
    "html", "cssls", "pyright", "lua_ls",
    "marksman", "jdtls", "texlab", "yamlls",
    "dockerls", "clojure_lsp", "cmake",
    "terraformls", "vimls", "rust_analyzer", "jsonls", "clangd"
}

for _, server in ipairs(default_servers) do
    vim.lsp.config(server, {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
    vim.lsp.enable(server)
end

-- Configuraciones especiales de servidores

-- gopls
vim.lsp.config('gopls', {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
        },
    },
})
vim.lsp.enable('gopls')
