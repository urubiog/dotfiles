local present, null_ls = pcall(require, "none-ls")

if not present then
    return
end

local b = null_ls.builtins

local sources = {
    -- webdev stuff
    b.formatting.deno_fmt,
    -- b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } },

    b.formatting.markdownlint,

    -- -- Lua
    -- b.formatting.stylua,

    -- -- cpp
    -- b.formatting.clang_format,

    -- -- python
    b.formatting.black,

    -- -- rust
    -- b.formatting.rustfmt,

    -- -- go
    -- b.formatting.gofmt,
    -- b.formatting.goimports,
}

null_ls.setup {
    debug = true,
    sources = sources,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        end
    end,
}
