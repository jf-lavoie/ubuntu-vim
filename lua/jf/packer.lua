-- print("loading packer.lua")

local packer = require 'packer'
local use = packer.use
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

  -- tree-sitter, synxtax highlight and incremental searches?
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
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


  -- autocomplete
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline"
    }
  }

  -- for ultisnips users.
  use "SirVer/ultisnips"
  use "honza/vim-snippets"
  use "quangnguyen30192/cmp-nvim-ultisnips"

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

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
  use {
    "mbbill/undotree",
    run = runHelptags('undotree', 'doc')
  }

  -- markdown
  -- expects that code-minimap is available in the environment
  use "wfxr/minimap.vim"

  -- ui related
  use "dracula/vim" -- colorsheme
  use "itchyny/lightline.vim" -- status line

  -- language specifics
  use "pangloss/vim-javascript"
  use "MaxMEllon/vim-jsx-pretty"
  use "hashivim/vim-terraform"
  use "folke/neodev.nvim" -- lua lsp hover and signature help
  use "plasticboy/vim-markdown"
  use {
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  }

end,
  config = {
    package_root = packagePath,

    -- display = {
    --   open_fn = function()
    --     require 'packer.util'.float { border = "rounded" }
    --   end
    -- }
  } })


-- re-source plugins.lua on change
-- from: https://github.com/wbthomason/packer.nvim#quickstart
vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost *packer.lua source <afile> | PackerCompile
  augroup end
]])
