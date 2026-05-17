-- ~/.config/nvim/lua/configs/lspconfig.lua

-- local util = require("lspconfig.util")
local lsp_signature = require "lsp_signature"

-- Configuraciones predeterminadas de NvChad
local base_on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

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

vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  return vim.lsp.handlers.hover(
    err,
    result,
    ctx,
    vim.tbl_deep_extend("force", config or {}, {
      border = "rounded",
      max_width = 80,
      max_height = 20,
    })
  )
end

vim.diagnostic.config {
  virtual_text = {
    prefix = "●", -- Puede usar →, ▸, etc.
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
}

-- Servidores que usan configuración predeterminada
local default_servers = {
  -- CORE
  "lua_ls",
  "pyright",
  "gopls",
  "clangd",
  "rust_analyzer",
  "jdtls",
  "texlab",
  "bashls",

  -- WEB
  "html",
  "cssls",
  "ts_ls",

  -- INFRA
  "dockerls",
  "terraformls",
  "yamlls",
  "jsonls",

  -- SQL (opcional)
  "sqlls",
}

for _, server in ipairs(default_servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end
