-- print('loading lsp-configs-shared.lua')
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
local opts = {noremap = true, silent = true}

local lspGroupKey = "<leader>l"

wk.register({
  [lspGroupKey] = {
    name = "Diagnostic", -- optional group name
    v = {vim.diagnostic.open_float, "View diagnostic (vim.diagnostic.open_float)"},
    n = {vim.diagnostic.goto_next, "Next diagnostic (vim.diagnostic.goto_next)"},
    p = {vim.diagnostic.goto_prev, "Prev diagnostic (vim.diagnostic.goto_prev)"},
    q = {vim.diagnostic.setloclist, "Set Location List (vim.diagnostic.setloclist)"}
  }
}, opts)

shared.group_lspformatting = vim.api.nvim_create_augroup("LspFormatting", {})

---Sets default lsp/diagnostic shortcuts
---@param _ table This is the client
---@param bufnr number bufnr The buffer number to attach the shortcuts to.
shared.on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = {noremap = true, silent = true, buffer = bufnr}
  local definition = {vim.lsp.buf.definition, "Go to definition (vim.lsp.buf.definition)"}
  local declaration = {vim.lsp.buf.declaration, "Go to declaration (vim.lsp.buf.declaration)"}
  local implementation = {vim.lsp.buf.implementation, "Go to implementation (vim.lsp.buf.implementation)"}
  local hover = {vim.lsp.buf.hover, "Open hover (vim.lsp.buf.hover)"}
  local signature = {vim.lsp.buf.signature_help, "Signature help (vim.lsp.buf.signature_help)"}

  vim.keymap.set('n', 'K', hover[1], merge(bufopts, {desc = hover[2]}))
  vim.keymap.set('n', '<C-k>', signature[1], merge(bufopts, {desc = signature[2]}))

  wk.register({
    g = {D = declaration, d = definition, i = implementation},
    [lspGroupKey] = {
      name = "LSP", -- optional group name

      D = declaration,
      d = definition,
      K = hover,
      k = signature,
      i = implementation,

      t = {vim.lsp.buf.type_definition, "Type definition (vim.lsp.buf.type_definition)"},
      r = {vim.lsp.buf.references, "References (vim.lsp.buf.references)"}
    },
    ["<leader>la"] = {
      name = "LSP-Action", -- optional group name
      a = {vim.lsp.buf.code_action, "Code Actions (vim.lsp.buf.code_action)"},
      f = {
        function()
          vim.lsp.buf.format {async = true}
        end, "Format async (vim.lsp.buf.format { async = true })"
      },
      r = {vim.lsp.buf.rename, "Rename (vim.lsp.buf.rename)"},
      d = {
        function()
          -- this group is coming from a custom command in null-ls configuration
          vim.api.nvim_clear_autocmds({event = "BufWritePre", buffer = bufnr, group = shared.group_lspformatting})
        end, "disable buffer formatting autocmd"
      }
      -- v = {
      --   function()
      --     local lsp_util = vim.lsp.util

      --     local context = {diagnostics = vim.lsp.diagnostic.get_line_diagnostics()}
      --     local params = lsp_util.make_range_params()
      --     params.context = context
      --     vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx, config)
      --       print("jf-debug-> 'config': " .. vim.inspect(config));
      --       print("jf-debug-> 'ctx': " .. vim.inspect(ctx));
      --       print("jf-debug-> 'err': " .. vim.inspect(err));
      --       print("jf-debug-> 'result': " .. vim.inspect(result));
      --       -- do something with result - e.g. check if empty and show some indication such as a sign
      --     end)
      --   end, "View available code actions"
      -- }

    }
  }, bufopts)
end

LspConfigShared = shared

return LspConfigShared
