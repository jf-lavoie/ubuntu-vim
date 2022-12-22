-- print('loading null-ls.lua')

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
  ensure_installed = { "shellcheck", "shfmt", "prettier" },
  automatic_installation = true,
  automatic_setup = false,
})

vim.api.nvim_create_augroup('formatOnSave', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = "Format buffer on save",
  pattern = {
    -- shfmt
    '*.sh', '*.bash',
    -- prettier
    "*.js", '*.mjs', '*.jsx', '*.ts', '*.tsx', '*.vue', '*.css', '*.scss', '*.less', '*.html', '*.htm', '*.json',
    '*.jsonc', "*.yaml", '*.yml', "*.markdown", '*.md', "*.mdx", "*.graphql", '*.gql', "*.handlebars", '*.hbs',

    -- works? but from where?
    '*.lua'
  },
  group = "formatOnSave",
  callback = function()
    vim.lsp.buf.format { async = true }
  end
})
