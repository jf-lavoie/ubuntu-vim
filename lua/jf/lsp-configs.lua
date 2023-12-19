-- print('loading lsp-configs.lua')
local util = require "lspconfig/util"

require'mason'.setup()
require'mason-lspconfig'.setup({
  ensure_installed = {
    'lua_ls', -- lua
    'tsserver', -- javascript/typescript
    'jsonls', -- jsonls
    'pyright', -- python
    'terraformls', -- terraform
    'gopls', -- go
    'jdtls' -- java
  }
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = require'jf/lsp-configs-shared'.on_attach

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150
}

vim.lsp.set_log_level('trace')

vim.diagnostic.config({
  update_in_insert = false,
  -- virtual_text = {
  --   source = "always" -- Or "if_many"
  -- },
  virtual_text = {
    source = false -- Or "if_many"
  },
  float = {
    -- source = "always" -- Or "if_many"
    source = "always"
    -- border = "rounded"
  }
}, nil)

-- taken from: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
require'lspconfig'['lua_ls'].setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {enable = false}
    }
  },
  on_attach = on_attach,
  flags = lsp_flags
}

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require'lspconfig'['pyright'].setup {on_attach = on_attach, flags = lsp_flags, capabilities = capabilities}

-- local tlsPath = "/home/jfl/projects/typescript-language-server/lib/cli.mjs"
-- if os.getenv("TSS_DEBUG_BRK") ~= nil then tlsPath = "/home/jfl/projects/typescript-language-server/lib-debug/cli.mjs" end
-- print("jf-debug-> 'tlsPath': " .. tostring(tlsPath));
require'lspconfig'['tsserver'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,

  -- debugging
  --
  -- cmd = {"/home/jfl/projects/typescript-language-server/lib/cli.mjs", "--stdio", "--log-level=4"},
  -- cmd = {tlsPath, "--stdio", "--log-level=4"},
  -- cmd = {"typescript-language-server", "--stdio", "--log-level=4"},
  -- filetypes = {
  --   "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "json"
  -- },

  -- taken from
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/lspconfig.txt
  -- https://github.com/typescript-language-server/typescript-language-server#initializationoptions
  init_options = {
    -- disableAutomaticTypingAcquisition = false,
    -- locale = "fr",
    tsserver = {
      -- path = "/home/jfl/projects/TypeScript/built/local/tsserver.js",
      -- logDirectory = vim.fn.getcwd() .. "/.log/"
      -- logVerbosity?: 'off' | 'terse' | 'normal' | 'requestTime' | 'verbose';
      -- logVerbosity = "verbose",
      -- trace = "verbose"
    }
  }
}

require'lspconfig'['jsonls'].setup {capabilities = capabilities}

require'lspconfig'['gopls'].setup {
  -- settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
  cmd = {"gopls", "serve"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities

}

require'lspconfig'['jdtls'].setup {on_attach = on_attach, flags = lsp_flags, capabilities = capabilities}

-- local augroup = vim.api.nvim_create_augroup("terraform-LspFormatting", {})
local augroup = require'jf/lsp-configs-shared'.group_lspformatting
require'lspconfig'['terraformls'].setup {

  on_attach = function(_, bufnr)
    vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({bufnr = bufnr})
      end
    })
    require'jf/lsp-configs-shared'.on_attach(_, bufnr)
  end
}
-- local augroup = vim.api.nvim_create_augroup("terraform-LspFormatting", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = augroup,
--   pattern = {"*.tf", "*.tf.json", "*.tfvars", "*.terraform", "*.tfvars", "*.hcl"},
--   callback = function(ev)
--     local bufnr = ev.buf
--     vim.lsp.buf.format({bufnr = bufnr})
--   end
-- })
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = augroup,
--   pattern = {"*.tf", "*.tf.json", "*.tfvars", "*.terraform", "*.tfvars", "*.hcl"},
--   callback = function(ev)
--     local bufnr = ev.buf
--     require'jf/lsp-configs-shared'.on_attach(_, bufnr)
--   end
-- })
