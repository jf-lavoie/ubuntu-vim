-- print('loading null-ls.lua')
local null_ls = require('null-ls')

require("mason-null-ls").setup({
  ensure_installed = {
    "shellcheck", "shfmt", "eslint_d", "prettier", "prettierd", "goimports", "golangci_lint", "gomodifytags",
    "lua_format", "isort", "ruff", "flake8", "yapf", "gopls"

  },
  automatic_installation = true,
  automatic_setup = false
})

-- taken here: https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
  -- debug = true,
  sources = {
    null_ls.builtins.code_actions.shellcheck, -- sh
    null_ls.builtins.diagnostics.shellcheck, -- sh
    null_ls.builtins.formatting.shfmt, -- sh
    -- null_ls.builtins.diagnostics.flake8.with({ extra_args = { "--max-line-length 120" } }), -- python
    null_ls.builtins.code_actions.eslint_d, -- eslint
    null_ls.builtins.diagnostics.eslint_d, -- eslint
    -- null_ls.builtins.formatting.prettierd, -- javscript, typescript, json, ...
    null_ls.builtins.formatting.prettier.with({extra_args = {"--loglevel", "debug"}}), -- javscript, typescript, json, ...
    null_ls.builtins.code_actions.gomodifytags, -- golang
    null_ls.builtins.formatting.goimports, -- golang
    null_ls.builtins.formatting.lua_format -- lua
    .with({
      extra_args = {"--indent-width=2", "--tab-width=2", "--column-limit=120", "--no-keep-simple-function-one-line"}
    }), null_ls.builtins.formatting.isort, -- python
    null_ls.builtins.formatting.yapf -- python

  },
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({bufnr = bufnr})
        end
      })
    end
    require'jf/lsp-configs-shared'.on_attach(_, bufnr)
  end
})
