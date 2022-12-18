require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    --
  -- operators = { gc = "Comments" },
  operators = { }, -- default: { gc = "Comments" }
  }

-- nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
-- vim.keymap.set('n', '<leader>', '<cmd>WhichKey \'<Space\'<CR>', { silent=true, remap=false })

-- https://neovim.io/doc/user/options.html#'ttimeoutlen'
-- default: 50
vim.o.timeoutlen=500
