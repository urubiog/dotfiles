local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html", "cssls", "clangd", "rust_analyzer", "gopls",
  "pyright", "yamlls", "dockerls", "clojure_lsp", "cmake",
  "terraformls", "vimls", "lua_ls"
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

-- -- typescript
-- lspconfig.ts_ls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   init_option = {
--     preferences = {
--       disableSuggestions = true,
--     }
--   }
-- }

-- lua 
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"lua"}
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

-- C, C++
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"c", "cpp"}, -- Asegúrate de incluir C++
    init_options = {
        usePlaceholders = true,
        completion = {
            enableSnippets = true,
        },
    },
    root_dir = function(fname)
        -- Intenta encontrar el directorio que contiene .clang-format, .git, etc.
        local dir = lspconfig.util.root_pattern(".clang-format", ".git", "compile_commands.json", "CMakeLists.txt")(fname)

        -- Retornar el directorio encontrado o la ruta al directorio que contiene .clang-format
        if dir then
            return dir
        else
            -- Retornar el directorio del usuario que contiene el archivo .clang-format
            return vim.fn.expand("~/") -- Esto retorna el directorio del HOME
        end
    end,
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
