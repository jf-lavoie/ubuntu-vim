-- print('loading lsp-configs.lua')
require 'mason'.setup()
require 'mason-lspconfig'.setup({
  ensure_installed = {
    'sumneko_lua', -- lua
    'tsserver', -- javascript/typescript
    'jsonls', -- jsonls
    'pyright', -- python
    'terraformls' -- terraform
    -- 'delve', -- golang
  }
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = require 'jf/lsp-configs-shared'.on_attach

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150
}

-- vim.lsp.set_log_level('debug')

-- taken from: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
require 'lspconfig'['sumneko_lua'].setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false }
    }
  },
  on_attach = on_attach,
  flags = lsp_flags
}

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require 'lspconfig'['pyright'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
}
require 'lspconfig'['tsserver'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
}

require 'lspconfig'['jsonls'].setup { capabilities = capabilities }

require 'lspconfig'['gopls'].setup {
  settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
  on_attach = on_attach,
  capabilities = capabilities
}
