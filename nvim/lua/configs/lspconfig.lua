local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html", "cssls", "tsserver", "clangd", "rust_analyzer", "gopls",
  "pyright", "yamlls", "dockerls", "clojure_lsp", "cmake",
  "terraformls", "vimls"
}
local util = "lspconfig/util"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_option = {
    preferences = {
      disableSuggestions = true,
    }
  }
}


-- html
lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"html"}
}

-- css
lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"css"}
}

-- Markdown
lspconfig.marksman.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"markdown"}
}

-- python
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})

-- C
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"c"}
}

-- java
lspconfig.jdtls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"java"},
}
--
-- lspconfig.omnisharp.setup {
--   on_attach = on_attach,  -- Replace with your custom on_attach function
--   capabilities = capabilities,  -- Replace with your custom capabilities table
--   filetypes = {"csharp"}  -- Limit the LSP to C# files
-- }
--
lspconfig.gopls.setup {
  on_attach = on_attach,  -- Replace with your custom on_attach function
  capabilities = capabilities,  -- Replace with your custom capabilities table
  cmd = {"gopls"},  -- Limit the LSP to Go files
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  -- root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

--
-- lspconfig.rust_analyzer.setup {
--   on_attach = on_attach,  -- Replace with your custom on_attach function
--   capabilities = capabilities,  -- Replace with your custom capabilities table
--   filetypes = {"rust"}  -- Limit the LSP to Rust files
-- }
--
-- lspconfig.sqls.setup {
--   on_attach = on_attach,  -- Replace with your custom on_attach function
--   capabilities = capabilities,  -- Replace with your custom capabilities table
--   filetypes = {"sql"}  -- Limit the LSP to SQL files
-- }
--
-- lspconfig.clangd.setup {
--   on_attach = on_attach,  -- Replace with your custom on_attach function
--   capabilities = capabilities,  -- Replace with your custom capabilities table
--   filetypes = {"c", "cpp"}  -- Limit the LSP to C and C++ files
-- }
--
-- lspconfig.solargraph.setup {
--   on_attach = on_attach,  -- Replace with your custom on_attach function
--   capabilities = capabilities,  -- Replace with your custom capabilities table
--   filetypes = {"ruby"}  -- Limit the LSP to Ruby files
-- }
-- lspconfig.sumneko_lua.setup {
--   cmd = {"lua-language-server"},  -- Replace with path to your lua-language-server executable
--   on_attach = on_attach,  -- Replace with your custom on_attach function
--   capabilities = capabilities,  -- Replace with your custom capabilities table
--   filetypes = {"markdown"}  -- Limit the LSP to Markdown files
-- }

-- LaTeX
lspconfig.texlab.setup {
  on_attach = on_attach,  -- Replace with your custom on_attach function
  capabilities = capabilities,  -- Replace with your custom capabilities table
  filetypes = {"tex"}  -- Limit the LSP to LaTeX files
}
