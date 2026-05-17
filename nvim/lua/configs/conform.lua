local conform = require "conform"

conform.setup {
  formatters_by_ft = {

    -- =========================
    -- LUA
    -- =========================
    lua = { "stylua" },

    -- =========================
    -- PYTHON
    -- =========================
    python = {
      "ruff_format",
      "black",
      "autopep8",
      "docformatter",
    },

    -- =========================
    -- PYTHON PROJECT CONFIG
    -- =========================
    toml = {
      "pyproject_fmt",
    },

    -- =========================
    -- JAVASCRIPT / TYPESCRIPT
    -- =========================
    javascript = { "prettier", "eslint_d" },
    typescript = { "prettier", "eslint_d" },
    javascriptreact = { "prettier", "eslint_d" },
    typescriptreact = { "prettier", "eslint_d" },

    vue = { "prettier" },
    svelte = { "prettier" },

    -- =========================
    -- WEB
    -- =========================
    html = { "prettier", "htmlbeautifier" },
    css = { "prettier", "stylelint" },

    -- =========================
    -- GO
    -- =========================
    go = {
      "goimports",
      "goimports_reviser",
      "gomodifytags",
      "gofmt",
      "golines",
    },

    -- =========================
    -- RUST
    -- =========================
    rust = {
      "rustfmt",
    },

    -- =========================
    -- MARKDOWN
    -- =========================
    markdown = {
      "prettier",
      "markdownlint",
    },

    -- =========================
    -- LATEX / TEX
    -- =========================
    tex = {
      "latexindent",
    },
    latex = {
      "latexindent",
    },

    -- =========================
    -- YAML / JSON
    -- =========================
    yaml = {
      "prettier",
      "yamlfmt",
    },
    json = {
      "prettier",
      "jq",
    },

    -- =========================
    -- SHELL
    -- =========================
    sh = { "shfmt", "beautysh" },
    bash = { "shfmt", "beautysh" },
    zsh = { "shfmt", "beautysh" },

    -- =========================
    -- TERRAFORM
    -- =========================
    terraform = {
      "terraform_fmt",
    },

    -- =========================
    -- C / C++
    -- =========================
    c = {
      "clang_format",
      "cmakelang",
    },
    cpp = {
      "clang_format",
      "cmakelang",
    },

    -- =========================
    -- SQL
    -- =========================
    sql = {
      "sql_formatter",
      "sqlfluff",
    },

    -- =========================
    -- DOCKER / INFRA
    -- =========================
    dockerfile = {
      "hadolint",
    },
  },

  formatters = {
    prettier = {
      prepend_args = {
        "--tab-width", "4",
      },
    },
  },
}
