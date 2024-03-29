-- print('loading lua/plugins/init.lua')

require 'jf/packer'

require 'jf/neodev' --must come before the lsp configs
require 'jf/lsp-configs'

require 'jf/lualine'
require 'jf/treesitter'
require 'jf/null-ls'
require 'jf/which-key'
require 'jf/nvim-cmp'
-- package.loaded['jf/neotree'] = nil
require 'jf/neotree'
require 'jf/dap'
