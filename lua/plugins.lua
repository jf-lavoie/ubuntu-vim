print("loading plugins.lua")

local use = require('packer').use

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager

  -- Configurations for Nvim LSP
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    'neovim/nvim-lspconfig'
  }

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
