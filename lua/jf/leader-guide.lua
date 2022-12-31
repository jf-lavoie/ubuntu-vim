-- print('loading which-key.lua')

require("which-key").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  --
  -- operators = { gc = "Comments" },
  operators = {}, -- default: { gc = "Comments" }

  window = {
    border = "shadow", -- none, single, double, shadow
  },
  layout = {
    align = "center", -- align columns left, center or right
  },
}


-- nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
-- vim.keymap.set('n', '<leader>', '<cmd>WhichKey \'<Space\'<CR>', { silent=true, remap=false })

-- https://neovim.io/doc/user/options.html#'ttimeoutlen'
-- default: 50
vim.o.timeoutlen = 200
