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
        -- markdown
        "marksman",
        "misspell",
        -- lua
        "lua-language-server",
        "stylua",
        -- web dev
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        -- docker
        "dockerfile-language-server",
        "docker-compose-language-service",
        -- rust
        "rust-analyzer",
        "rustfmt",
        -- go
        "gopls",
        "glint",
        "go-debug-adapter",
        "goimports",
        "goimports-reviser",
        "golangci-lint",
        "golangci-lint-langserver",
        "golines",
        "gotests",
        "gotestsum",
        -- python
        "pyright",
        "flake8",
        "black",
        "mypy",
        "pydocstyle",
        "pylint",
        "pyre",
        "autoflake",
        "autopep8",
        "python-lsp-server",
        -- yaml
        "terraform-ls",
        "tflint",
        "yaml-language-server",
        "yamlfmt",
        "yamllint",
        -- sql
        "sqlfluff",
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
