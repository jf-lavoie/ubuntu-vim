print('loading lsp-configs-shared.lua')

local shared = {}

local wk = require 'which-key'


local merge = function(a, b)
  local c = {}
  for k, v in pairs(a) do c[k] = v end
  for k, v in pairs(b) do c[k] = v end
  return c
end


-- copy/paste from https://github.com/neovim/nvim-lspconfig
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }

local lspGroupKey = "<leader>l"


wk.register({
  [lspGroupKey] = {
    name = "Diagnostic", -- optional group name
    -- n = { "Test" },
    v = { vim.diagnostic.open_float, "View diagnostic (vim.diagnostic.open_float)" },
    n = { vim.diagnostic.goto_next, "Next diagnostic (vim.diagnostic.goto_next)" },
    p = { vim.diagnostic.goto_prev, "Prev diagnostic (vim.diagnostic.goto_prev)" },
    q = { vim.diagnostic.setloclist, "Set Location List (vim.diagnostic.setloclist)" }
  },
}, opts)


shared.on_attach = function(_, bufnr) -- _ = client
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local definition = { vim.lsp.buf.definition, "Go to definition" }
  local declaration = { vim.lsp.buf.declaration, "Go to declaration" }
  local implementation = { vim.lsp.buf.implementation, "Go to implementation" }
  local hover = { vim.lsp.buf.hover, "Open hover" }
  local signature = { vim.lsp.buf.signature_help, "Signature help" }


  vim.keymap.set('n', 'K', hover[1], merge(bufopts, { desc = hover[2] }))
  vim.keymap.set('n', '<C-k>', signature[1], merge(bufopts, { desc = signature[2] }))

  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)

  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, merge(bufopts, { desc = "Type definition" }))
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, merge(bufopts, { desc = "Rename" }))
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, merge(bufopts, { desc = "Code Actions" }))
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, merge(bufopts, { desc = "References" }))
  -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end,
  --   merge(bufopts, { desc = "Format" }))

  wk.register({

    g = {
      -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, merge(bufopts, { desc = "Go to declaration" }))
      -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, merge(bufopts, { desc = "Go to definition" }))
      -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, merge(bufopts, { desc = "Go to implementation" }))
      D = declaration,
      d = definition,
      i = implementation,
    },

    [lspGroupKey] = {
      name = "LSP", -- optional group name
      -- n = { "Test" },

      D = declaration,
      d = definition,
      K = hover,
      k = signature,
      i = implementation,

      t = { vim.lsp.buf.type_definition, "Type definition" },
      r = { vim.lsp.buf.references, "References" },
    },

    ["<leader>la"] = {
      name = "LSP-Action", -- optional group name
      r = { vim.lsp.buf.rename, "Rename" },
      a = { vim.lsp.buf.code_action, "Code Actions" },
      f = { function() vim.lsp.buf.format { async = true } end, "Format" }

    },
  }, bufopts)
end

LspConfigShared = shared

return LspConfigShared
