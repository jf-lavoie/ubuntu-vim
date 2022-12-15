print( "loading plugins.lua")

local use = require('packer').use

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager

  -- use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use 'scrooloose/nerdtree' -- File Tree Explorer

end)
