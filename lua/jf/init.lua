-- print('loading lua/plugins/init.lua')

require 'jf/packer'

require 'jf/neodev' --must come before the lsp configs
require 'jf/lsp-configs'

require 'jf/treesitter'
require 'jf/null-ls'
require 'jf/which-key'
require 'jf/nvim-cmp'
require 'jf/neotree'
