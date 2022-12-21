print("loading packer.lua")

local use = require('packer').use
local util = require 'packer.util'


-- this is the default: https://github.com/wbthomason/packer.nvim#custom-initialization
local packagePath = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')

local runHelptags = function(...)

  local packed = { ... }

  return function()
    local docPath = util.join_paths(packagePath, 'packer', 'start', unpack(packed))

    local status, value = pcall(vim.api.nvim_command, 'helptags ' .. docPath)
    if status then
      print('no error', value)
    else
      print('error: ', value)
    end
    print(value)
  end

end



require('packer').startup({ function()

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


  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline"
    }
  }

  -- for ultisnips users.
  use "SirVer/ultisnips"
  use "honza/vim-snippets"
  use "quangnguyen30192/cmp-nvim-ultisnips"

  --
  use 'scrooloose/nerdtree' -- File Tree Explorer

  -- git related
  use {
    "tpope/vim-fugitive",
    run = runHelptags('vim-fugitive', 'doc')
  }
  use {
    "airblade/vim-gitgutter",
    run = runHelptags('vim-gitgutter', 'doc')
  }

  -- additionanl utilities
  use "tpope/vim-commentary"
  use {
    "Raimondi/delimitMate",
    run = runHelptags('delimitMate', 'doc')
  }
  use "alvan/vim-closetag"
  use {
    "Yggdroot/indentLine",
    run = runHelptags('indentLine', 'doc')
  }
  use "svermeulen/vim-subversive"
  use "machakann/vim-highlightedyank"
  use "junegunn/fzf.vim"

  -- markdown
  use "plasticboy/vim-markdown"
  use {
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  }
  -- expects that code-minimap is available in the environment
  use "wfxr/minimap.vim"

  -- ui related
  use "dracula/vim" -- colorsheme
  use "itchyny/lightline.vim" -- status line

  -- language specifics
  use "pangloss/vim-javascript"
  use "MaxMEllon/vim-jsx-pretty"
  use {
    "fatih/vim-go",
    run = ':GoInstallBinaries'
  }
  use "hashivim/vim-terraform"

end,
  config = {
    package_root = packagePath
  } })


-- re-source plugins.lua on change
-- from: https://github.com/wbthomason/packer.nvim#quickstart
vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost *packer.lua source <afile> | PackerCompile
  augroup end
]])
