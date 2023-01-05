local configs = require("nvim-treesitter.configs")

configs.setup {
  ensure_installed = "all",
  sync_install = true,
  ignore_install = {""}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {""}, -- list of language that will be disabled
    additional_vim_regex_highlighting = true

  },

  -- disable python because not well supported. source: https://www.reddit.com/r/neovim/comments/ok9frp/comment/h57na2w/?utm_source=reddit&utm_medium=web2x&context=3
  indent = {enable = true, disable = {"yaml", "python"}}
}
