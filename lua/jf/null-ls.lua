print('loading null-ls.lua')

local null_ls = require('null-ls')

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,
  },
  on_attach = require 'jf/lsp-configs-shared'.on_attach

})

require("mason-null-ls").setup({
    ensure_installed = {"shellcheck", "shfmt" },
    automatic_installation = true,
    automatic_setup = false,
})
