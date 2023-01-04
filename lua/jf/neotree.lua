-- print('loading neotree.lua')

require 'nvim-web-devicons'.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    -- zsh = {
    --   icon = "",
    --   color = "#428850",
    --   cterm_color = "65",
    --   name = "Zsh"
    -- }
  };
  -- globally enable different highlight colors per icon (default to true)
  -- if set to false all icons will have the default icon's color
  color_icons = true;
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  -- default = true;
}

-- originally from here: https://github.com/AstroNvim/AstroNvim/issues/344
vim.api.nvim_create_augroup("neotree", {})
-- vim.api.nvim_create_autocmd("StdinReadPost", {
--   desc = "Set script variable std_in",
--   group = "neotree",
--   callback = function()
--     print 'test'
--     vim.api.nvim_command(':let s:std_in=1')
--   end
-- })
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open Neotree automatically",
  group = "neotree",
  callback = function()
    -- do not open neotree if in diff mode
    if vim.api.nvim_win_get_option(0, "diff") then
      return
    end

    for i = vim.fn.argc(), 0, -1 do
      print(string.format("%d: %s", i, vim.fn.argv(i)))
    end

    -- if vim.fn.argc() == 0 and not vim.fn.exists "s:std_in" then
    if vim.fn.argc() == 0 then -- do not open neotree if one or more files are given as argument
      vim.cmd "Neotree toggle"
    end
  end
})
