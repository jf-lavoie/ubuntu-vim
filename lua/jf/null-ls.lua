-- print('loading null-ls.lua')
local null_ls = require('null-ls')

require("mason-null-ls").setup({
  ensure_installed = {
    "shellcheck", "shfmt", "prettier", "goimports", "golangci_lint",
    "lua_format"
  },
  automatic_installation = true,
  automatic_setup = false
})

-- taken here: https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
  -- debug = true,
  sources = {
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck, null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.lua_format.with({ extra_args = { "--indent-width=2", "--tab-width=2",
      "--column_limit=120" } })
  },
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end
      })

    end
    require 'jf/lsp-configs-shared'.on_attach(_, bufnr)
  end
})
