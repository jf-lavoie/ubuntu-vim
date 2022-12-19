print('loading lsp-configs-shared.lua')

local shared = {}


local merge = function(a, b)
  local c = {}
  for k, v in pairs(a) do c[k] = v end
  for k, v in pairs(b) do c[k] = v end
  return c
end

shared.on_attach = function(_, bufnr) -- _ = client
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, merge(bufopts, { desc = "Go to declaration" }))
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, merge(bufopts, { desc = "Go to definition" }))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, merge(bufopts, { desc = "Open hover" }))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, merge(bufopts, { desc = "Go to implementation" }))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, merge(bufopts, { desc = "Signature help" }))
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, merge(bufopts, { desc = "Type definition" }))
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, merge(bufopts, { desc = "Rename" }))
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, merge(bufopts, { desc = "Code Actions" }))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, merge(bufopts, { desc = "References" }))
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, merge(bufopts, { desc = "Format" }))

  -- taken from: https://smarttech101.com/nvim-lsp-configure-language-servers-shortcuts-highlights/#code_actions_in_nvim_lsp
  -- vim.keymap.set('n', '<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

LspConfigShared = shared

return LspConfigShared
