print("loading packer.lua")

local use = require('packer').use

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager

  -- Configurations for Nvim LSP
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    'neovim/nvim-lspconfig'
  }

  use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
          require("null-ls").setup()
      end,
      requires = { "nvim-lua/plenary.nvim", "jay-babu/mason-null-ls.nvim" },
  })

  use 'folke/which-key.nvim' -- show leader menu
  -- others:
  -- https://github.com/liuchengxu/vim-which-key
  -- https://github.com/hecal3/vim-leader-guide
  -- https://github.com/spinks/vim-leader-guide
  -- https://github.com/folke/which-key.nvim
  --
  use 'scrooloose/nerdtree' -- File Tree Explorer

end)


-- re-source plugins.lua on change
-- from: https://github.com/wbthomason/packer.nvim#quickstart
vim.cmd([[
    augroup packer_user_config
      autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
