local null_ls = require("null-ls")

local opts = {
  sources = {
  -- Python
  null_ls.builtins.diagnostics.mypy,
  null_ls.builtins.formatting.black,

  -- -- JavaScript/TypeScript
  -- null_ls.builtins.diagnostics.eslint,
  -- null_ls.builtins.formatting.prettier,
  --
  -- -- Java
  -- null_ls.builtins.diagnostics.javac,
  --
  -- -- C#
  -- null_ls.builtins.diagnostics.dotnet,
  -- null_ls.builtins.formatting.dotnet_format,
  --
  -- -- Go (Golang)
  -- null_ls.builtins.formatting.goimports,
  --
  -- -- Rust
  -- null_ls.builtins.diagnostics.rustc,
  -- null_ls.builtins.formatting.rustfmt,
  --
  -- -- SQL
  -- null_ls.builtins.formatting.sqlformat,
  --
  -- -- C/C++
  -- null_ls.builtins.diagnostics.clangd,
  -- null_ls.builtins.formatting.clang_format,
  --
  -- -- Ruby
  -- null_ls.builtins.formatting.rubocop,
  --
  -- -- Markdown
  -- null_ls.builtins.formatting.prettier,
  },
}

return opts
