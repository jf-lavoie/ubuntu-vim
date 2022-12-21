print('loading null-ls.lua')

local null_ls = require('null-ls')

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.prettierd,
  },
  on_attach = require 'jf/lsp-configs-shared'.on_attach

})

require("mason-null-ls").setup({
    ensure_installed = {"shellcheck", "shfmt", "prettier" },
    automatic_installation = true,
    automatic_setup = false,
})
