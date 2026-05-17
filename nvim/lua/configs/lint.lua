local lint = require("lint")

lint.linters_by_ft = {

  -- =========================
  -- PYTHON
  -- =========================
  python = {
    "ruff",
    "mypy",
    "flake8",
    "pylint",
  },

  -- =========================
  -- JS / TS
  -- =========================
  javascript = {
    "eslint_d",
  },
  typescript = {
    "eslint_d",
  },
  javascriptreact = {
    "eslint_d",
  },
  typescriptreact = {
    "eslint_d",
  },

  vue = { "eslint_d" },
  svelte = { "eslint_d" },

  -- =========================
  -- WEB
  -- =========================
  html = {
    "htmlhint",
  },
  css = {
    "stylelint",
  },

  -- =========================
  -- GO
  -- =========================
  go = {
    "golangcilint",
    "revive",
  },

  -- =========================
  -- RUST
  -- =========================
  rust = {
    "clippy",
  },

  -- =========================
  -- LUA
  -- =========================
  lua = {
    "luacheck",
    "selene",
  },

  -- =========================
  -- YAML / JSON
  -- =========================
  yaml = {
    "yamllint",
  },
  json = {
    "jsonlint",
  },

  -- =========================
  -- DEVOPS
  -- =========================
  dockerfile = {
    "hadolint",
  },
  terraform = {
    "tflint",
  },

  -- =========================
  -- MARKDOWN
  -- =========================
  markdown = {
    "markdownlint",
    "vale",
  },

  -- =========================
  -- SHELL
  -- =========================
  sh = {
    "shellcheck",
  },
  bash = {
    "shellcheck",
  },
  zsh = {
    "shellcheck",
  },

  -- =========================
  -- C / C++
  -- =========================
  c = {
    "clangtidy",
  },
  cpp = {
    "clangtidy",
  },

  -- =========================
  -- JAVA
  -- =========================
  java = {
    "checkstyle",
  },

  -- =========================
  -- SQL
  -- =========================
  sql = {
    "sqlfluff",
  },

  -- =========================
  -- GENERIC
  -- =========================
  vim = {
    "vint",
  },
}
