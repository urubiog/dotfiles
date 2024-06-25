local null_ls = require("null-ls")

local opts = {
  sources = {
  -- Python
  null_ls.builtins.diagnostics.mypy,
  null_ls.builtins.formatting.black,
  },
}

return opts
