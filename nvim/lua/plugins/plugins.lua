local plugins = {
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function()
      return require "plugins.configs.formatter"
    end
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require "plugins.configs.lint"
    end
  },
  {
    "catppuccin/nvim",
    as = "catppuccin"
  },
  {
    "tribela/vim-transparent"
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "plugins.configs.null-ls"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Type checkers and formatters for various languages
        "pyright",  -- TypeScript type checker
        "mypy",  -- Python type checker
        "black",  -- Python code formatter
        "typescript-language-server", -- TypeScript language server
        "eslint-lsp",  -- JavaScript/TypeScript linter and formatter
        "prettier",  -- JavaScript/TypeScript/Markdown formatter
        "gopls",
        "jdtls", -- Java language server
        "html-lsp", -- HTML 
        "css-lsp", -- CSS
        "marksman", -- Markdown
        "texlab", -- Latex
        -- "dotnet",  -- C# compiler
        -- "dotnet-format",  -- C# code formatter
        -- "goimports",  -- Go code formatter
        -- "rustc",  -- Rust compiler
        -- "rustfmt",  -- Rust code formatter
        -- "sqlformat",  -- SQL formatter
        "clangd",  -- C/C++ language server
        "clang-format",  -- C/C++ code formatter
        -- "rubocop",  -- Ruby code analyzer and formatter
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })
    end,
  },
}

return plugins
