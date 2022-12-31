-- print( "loading init.lua")

-- joint from
-- https://github.com/nanotee/nvim-lua-guide
-- and : packer.nvim quickstart guide
require 'jf'


-- nvim is always nocompatible
-- set nocompatible
--
-- not needed in neovim anymore: https://www.reddit.com/r/vim/comments/4y8b51/what_are_common_settings_for_vim_that_are/
-- filetype plugin indent on
-- syntax enable


vim.cmd('colorscheme dracula')

-- special check for windows terminal
-- https://github.com/microsoft/terminal/issues/1040
-- https://gist.github.com/XVilka/8346728
if (
    os.getenv("COLORTERM") == "truecolor" or
        (os.getenv("TERM") == "xterm-256color" and vim.vn.empty(os.getenv("WSL_DISTRO_NAME") == 1))) then
  vim.opt.termguicolors = true
end

-- 'autoread' is enabled
-- 'background' defaults to "dark" (unless set automatically by the terminal/UI)
-- 'backspace' defaults to "indent,eol,start"
-- 'backupdir' defaults to .,~/.local/state/nvim/backup// (xdg), auto-created
-- 'belloff' defaults to "all"
-- 'compatible' is always disabled
-- 'complete' excludes "i"
-- 'directory' defaults to ~/.local/state/nvim/swap// (xdg), auto-created
-- 'display' defaults to "lastline"
-- 'encoding' is UTF-8 (cf. 'fileencoding' for file-content encoding)
-- 'fillchars' defaults (in effect) to "vert:│,fold:·,sep:│"
-- 'formatoptions' defaults to "tcqj"
-- 'fsync' is disabled
-- 'hidden' is enabled
-- 'history' defaults to 10000 (the maximum)
-- 'hlsearch' is enabled
-- 'joinspaces' is disabled
-- 'langnoremap' is enabled
-- 'langremap' is disabled
-- 'laststatus' defaults to 2 (statusline is always shown)
-- 'listchars' defaults to "tab:> ,trail:-,nbsp:+"
-- 'mouse' defaults to "nvi"
-- 'mousemodel' defaults to "popup_setpos"
-- 'nrformats' defaults to "bin,hex"
-- 'ruler' is enabled
-- 'sessionoptions' includes "unix,slash", excludes "options"
-- 'shortmess' includes "F", excludes "S"
-- 'showcmd' is enabled
-- 'sidescroll' defaults to 1
-- 'smarttab' is enabled
-- 'startofline' is disabled
-- 'switchbuf' defaults to "uselast"
-- 'tabpagemax' defaults to 50
-- 'tags' defaults to "./tags;,tags"
-- 'ttimeoutlen' defaults to 50
-- 'ttyfast' is always set
-- 'undodir' defaults to ~/.local/state/nvim/undo// (xdg), auto-created
-- 'viewoptions' includes "unix,slash", excludes "options"
-- 'viminfo' includes "!"
-- 'wildmenu' is enabled
-- 'wildoptions' defaults to "pum,tagfile"


-- do not resize windows when closing a window
-- source: https://stackoverflow.com/questions/486027/close-a-split-window-in-vim-without-resizing-other-windows
vim.opt.equalalways = false


-- Display line number
vim.opt.number = true
vim.opt.relativenumber = true


-- Diff always vertical
vim.opt.diffopt = 'vertical'

-- make backspace work like most other apps
-- vim.opt.backspace='indent,eol,start'



-- Show all the white space character
-- vim.opt.list = true
-- sets trailing spaces and tabs to easily visible characters
-- vim.opt.listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
-- how-to see the non-visible while spaces
-- :vim.opt.listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
-- vim.opt.listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 5


-- function ToggleCursorLine()
--   -- why can't I just toggle it?
--   -- vim.opt_local.cursorline = not vim.opt_local.cursorline
--   if vim.opt_local.cursorline:get() then
--     -- vim.opt_local.cursorline:remove(true)
--     vim.opt_local.cursorline = false
--   else
--     -- vim.opt_local.cursorline:remove(false)
--     vim.opt_local.cursorline = true
--   end
-- end

-- vim.api.nvim_create_augroup("CursorLine", {})
-- vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
--   group = "CursorLine",
--   callback = ToggleCursorLine
-- })
-- -- vim.api.nvim_create_autocmd({ "WinLeave" }, {
-- --   callback = function()
-- --     vim.opt_local.cursorline = false
-- --   end
-- -- })

-- vim.keymap.set('n', '<leader>n', ToggleCursorLine, {
--   desc = "Toggle cursor line"
-- })

--------------------------------------------------------------------------------------
-- Search
--------------------------------------------------------------------------------------
vim.keymap.set('', '<F3>', function() vim.opt.hls = not vim.opt.hls end)
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- 'incsearch' is enabled
-- vim.opt.incsearch = true
vim.opt.inccommand = 'nosplit'



--------------------------------------------------------------------------------------
-- Tabulation and identation
--------------------------------------------------------------------------------------
-- 'autoindent' is enabled
-- vim.opt.autoindent = true
-- Do not wrap lines
vim.opt.wrap = false
-- indent/outdent to nearest tabstops
vim.opt.shiftround = true
-- indentation levels every two columns
vim.opt.tabstop = 2
-- --number of space characters inserted for indentation
vim.opt.shiftwidth = 2
-- this is to make sure vim replaces tabs by spaces
vim.opt.expandtab = true

-- python is special
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.py' },
  callback = function()

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    -- 'autoindent' is enabled
    -- vim.opt.autoindent = true
    vim.opt.fileformat = 'unix'
  end
})


--------------------------------------------------------------------------------------
-- Beeping
--------------------------------------------------------------------------------------
-- Do not ring the bell for error messages
vim.opt.errorbells = false
-- Use visual bell and remove flashing
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.opt.vb = false
    -- apparently unused in nvim
    -- vim.opt.t_vb = ''
  end
})


--------------------------------------------------------------------------------------
-- Remove the backup option (~ and .swp files)
--------------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false


-- " ---------------------------------------------------
-- " Trim extra white spaces at end of lines
-- " ---------------------------------------------------
-- " autocmd BufWritePre *.py normal m`:%s/\s\+$//e


--------------------------------------------------------------------------------------
-- Custom shortcuts
--------------------------------------------------------------------------------------

vim.keymap.set('n', '<F1>', ':h <C-r><C-w><enter>', {
  desc = "Help for word under cursor"
})
vim.keymap.set('v', '<F1>', 'y<esc>:h <C-r>"<enter>', {
  desc = "Help for visual selection"
})

vim.keymap.set('n', '<F5>', ':NeoTreeRevealToggle<CR>', {
  desc = "ReveaNeoTreeRevealToggle"
})

vim.keymap.set('n', '<F6>', ':UndotreeToggle<CR>', {
  desc = "UndotreeToggle"
})
vim.keymap.set('n', '<F7>', function() vim.fn.setreg("+", vim.fn.expand('%:p')) end, {
  desc = "copy file path to clipboard"
})

----------------------- terminal ---------------------------

-- taken from here: https://stackoverflow.com/questions/1236563/how-do-i-run-a-terminal-inside-of-vim/29293191#29293191
-- tnoremap <ESC><ESC> <C-\><C-n>
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  desc = "sets <esc><esc> to return to normal mode in terminal",
  callback = function(arguments)
    vim.keymap.set('t', '<Esc><Esc>', '<c-\\><c-n>', {
      buffer = arguments.buffer
    })
  end
})
-- required?
-- autocmd BufEnter * if &buftype=="terminal" | startinsert | endif


-- taken from here: https://github.com/junegunn/fzf.vim/issues/544#issuecomment-498202592
-- tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\\><c-n>"
-- vim.keymap.set('t', '<Esc>', '(&filetype == "fzf") ? "<Esc>" : "<c-\\><c-n>"', {
--   desc = "terminal <esc> to go back to normal mode",
--   expr = true,
--   replace_keycodes = true
-- })
-- from here: https://github.com/junegunn/fzf.vim/issues/544#issuecomment-457456166
vim.api.nvim_exec('autocmd FileType fzf tunmap <Esc><Esc>', false)

----------------------- JS specific shortcuts ---------------------------
-- in order to prevent some plugins (like delimiter) to interfer with the typed
-- characters, the content is provided to a register, and this register is printed
-- the delimiter plugin was adding double quote, single quotes, ....
-- using the registers make those mapping agnostic of the plugins.
-- the 'oi<BS><esc>' is just to et leverage the automatic indentation provided by vim 'o'
-- while still returning in normal mode with the <esc>
--
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = { "javascript", "typescript", "vue" },
    callback = function(info)
      vim.keymap.set('n', '<F2>',
        "yiwoi<BS><esc>:let @m = 'console.log(\"jf-debug-> ''' . @\" . ''': \", ' . @\" . ');'<enter><esc>\"mp", {
        desc = "console.log jf",
        buffer = info.buf
      })

      vim.keymap.set('v', '<F2>',
        "yoi<BS><esc>:let @m = 'console.log(\"jf-debug-> ''' . @\" . ''': \", ' . @\" . ');'<enter><esc>\"mp", {
        desc = "visual console.log jf",
      })

      vim.keymap.set('v', '<F3>',
        "oi<BS><esc>:let @m = 'console.log(\"jf-debug-> arguments: \", arguments);'<enter><esc>\"mp<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>"
        , {
        desc = "console.log jf arguments",
      })

      vim.keymap.set('n', '<F4>',
        "yiwoi<BS><esc>:let @m = 'console.log(\"jf-debug-> ''' . @\" . ''': \", require(\"util\").inspect(' . @\" . ', { depth: 100, colors: false }));'<enter><esc>\"mp"
        , {
        desc = "console.log jf inspect",
      })

      vim.keymap.set('v', '<F4>',
        "yoi<BS><esc>:let @m = 'console.log(\"jf-debug-> ''' . @\" . ''': \", require(\"util\").inspect(' . @\" . ', { depth: 100, colors: false }));'<enter><esc>\"mp"
        , {
        desc = "console.log jf inspect",
      })
    end
  })


----------------------- GO specific shortcuts ---------------------------
-- " in order to prevent some plugins (like delimiter) to interfer with the typed
-- " characters, the content is provided to a register, and this register is
-- " printed
-- " the delimiter plugin was adding double quote, single quotes, ....
-- " using the registers make those mapping agnostic of the plugins.
-- " the 'oi<BS><esc>' is just to et leverage the automatic indentation provided by vim 'o'
-- " while still returning in normal mode with the <esc>

vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = { "go" },
    callback = function(info)
      vim.keymap.set('n', '<F2>',
        "yiwoi<BS><esc>:let @m = 'fmt.Printf(\"jf-debug-> ''' . @\" . ''': %#v\n\", ' . @\" . ');'<enter><esc>\"mp", {
        desc = "console.log jf",
        buffer = info.buf
      })

      vim.keymap.set('v', '<F2>',
        "yoi<BS><esc>:let @m = 'fmt.Printf(\"jf-debug-> ''' . @\" . ''': %#v\n\", ' . @\" . ');'<enter><esc>\"mp", {
        desc = "visual console.log jf",
      })

    end
  })

----------------------- lua specific shortcuts ---------------------------
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = { "lua" },
    callback = function(info)
      vim.keymap.set('n', '<F2>',
        "yiwoi<BS><esc>:let @m = 'print(\"jf-debug-> ''' . @\" . ''': \"..'. @\" .');'<enter><esc>\"mp", {
        desc = "print jf",
        buffer = info.buf
      })

      vim.keymap.set('v', '<F2>',
        "yoi<BS><esc>:let @m = 'print(\"jf-debug-> ''' . @\" . ''': \"..'. @\" .');'<enter><esc>\"mp", {
        desc = "print jf",
        buffer = info.buf
      })

      vim.keymap.set('n', '<F4>',
        "yiwoi<BS><esc>:let @m = 'print(\"jf-debug-> ''' . @\" . ''': \" .. vim.inspect(' . @\" . '));'<enter><esc>\"mp"
        ,
        {
          desc = "visual console.log jf",
        })

      vim.keymap.set('v', '<F4>',
        "yoi<BS><esc>:let @m = 'print(\"jf-debug-> ''' . @\" . ''': \" .. vim.inspect(' . @\" . '));'<enter><esc>\"mp",
        {
          desc = "visual console.log jf",
        })

    end
  })


-- ---------------------------------------------------
-- Adding batch file comment type. Used with plugin commentary
-- ---------------------------------------------------
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { "dosbatch" },
    callback = function()
      vim.opt.commentstring = ":: %s"
    end
  })


-- ---------------------------------------------------
-- Chaning the font for MAC only because the base font is too small.
-- ---------------------------------------------------
if vim.fn.has('mac') then
  vim.opt.guifont = "Menlo Regular:h13"
  -- elseif has('unix')
  --   set guifont=Droid\ Sans\ Mono\ 11
end

-- from: https://neovide.dev/configuration.html
-- if vim.fn.exists('g:neovide') then
--   -- Put anything you want to happen only in Neovide here
--   -- let g:neovide_transparency = 0.8
--   -- let g:transparency = 0.1
--   -- let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))
--   -- let g:neovide_floating_blur_amount_x = 2.0
--   -- let g:neovide_floating_blur_amount_y = 2.0
-- end


-- generic solution to let syntastic, neoformat, ...
-- find locally installed node_modules and not requiring a global installation.
-- find here: https://github.com/npm/npm/issues/957
vim.api.nvim_exec([[
let $PATH = './node_modules/.bin:'.$PATH
]], false)


-- when using gf in javascript file, the extension is not set most of the time.
-- :help path
-- :help suffixesadd
-- found here: https://stackoverflow.com/questions/1932604/vim-problem-with-gf-command
-- https://til.hashrocket.com/posts/fef382f93e-use-suffixadd-to-save-yourself-some-life
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { "javascript", "typescript", "vue" },
    callback = function()
      if string.len(vim.bo.suffixesadd) > 0 then
        vim.bo.suffixesadd = vim.bo.suffixesadd .. ","
      end
      vim.bo.suffixesadd = vim.bo.suffixesadd .. ".js,.jsx,.ts,.tsx,.vue.json"
    end
  })

-- ---------------------------------------------------
-- FZF configs
-- ---------------------------------------------------



vim.opt.rtp:append(os.getenv('HOME') .. '/.fzf')
vim.keymap.set('n', '<C-p>', ":call fzf#run(fzf#wrap(fzf#vim#with_preview()))<enter>", {})

-- " taken here: https://github.com/junegunn/fzf.vim/issues/1081
-- " linked there: https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
RipgrepFzf = function(query, fullscreen)

  local command_fmt = "rg --column --line-number --no-heading --color=always --smart-case -- %s || true"
  local initial_command = string.format("'" .. command_fmt .. "'", string.format("%q", query))
  local reload_command = string.format(command_fmt, '{q}')

  local spec = "[ '--phony', '--query', '" ..
      query .. "', '--bind', 'change:reload:" .. reload_command .. "']"

  local cmd = string.format("call fzf#vim#grep(%s, 1, fzf#vim#with_preview({'options':%s}), %s)",
    initial_command,
    spec,
    fullscreen)
  print("jf-debug-> 'cmd': " .. cmd);
  vim.api.nvim_exec(cmd, true)
end

vim.api.nvim_create_user_command('RG', function(data)
  RipgrepFzf(data.args, 0)
end, {
  nargs = '*',
  bang = true,
  desc = "Fzf using Ripgrep"
})

vim.keymap.set('n', '<leader>fr', ':RG<enter>', {})

-- taken here: https://github.com/junegunn/fzf.vim#example-rg-command-with-preview-window
-- and here: https://github.com/junegunn/fzf.vim/issues/714#issuecomment-428802659
vim.api.nvim_exec([[
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

  nnoremap <leader>f :Rg<enter>
  " <C-r><C-w> returns the word under the cursor
  nnoremap <leader>fw :Rg  <C-r><C-w><enter>
]], false)


-- " todo: future improvement: add a visual selection search. Hightlight test in
-- " visual mode than search for it using Rg.
-- " see https://stackoverflow.com/questions/41238238/how-to-map-vim-visual-mode-to-replace-my-selected-text-parts
-- " to get visual selection
-- " if no selection, revert to current behavior of <C-r><C-w>

-- taken here: https://github.com/dracula/vim/blob/master/colors/dracula.vim
-- modified the border
if vim.api.nvim_cmd({
  cmd = 'colorscheme'
}, {
  output = true
}) == "dracula" then

  vim.api.nvim_exec([[

  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Search'],
    \ 'fg+':     ['fg', 'Normal'],
    \ 'bg+':     ['bg', 'Normal'],
    \ 'hl+':     ['fg', 'DraculaOrange'],
    \ 'info':    ['fg', 'DraculaPurple'],
    \ 'border':  ['fg', 'DraculaPurple'],
    \ 'prompt':  ['fg', 'DraculaGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
   ]], false)
end

-----------------------------------------------------
-- UtilsSnip configs
-----------------------------------------------------
-- -- Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
-- -- let g:UltiSnipsExpandTrigger=--<tab>--
-- let g:UltiSnipsExpandTrigger=--<leader><tab>--
-- -- let g:UltiSnipsJumpForwardTrigger=--<c-b>--
-- -- let g:UltiSnipsJumpBackwardTrigger=--<c-z>--
-- -- If you want :UltiSnipsEdit to split your window.
-- -- let g:UltiSnipsEditSplit=--vertical--
-- function! g:UltiSnips_Complete()
--   call UltiSnips#ExpandSnippet()
--   if g:ulti_expand_res == 0
--     if pumvisible()
--       return --\<C-n>--
--     else
--       call UltiSnips#JumpForwards()
--       if g:ulti_jump_forwards_res == 0
--         return --\<TAB>--
--       endif
--     endif
--   endif
--   return ----
-- endfunction
-- au BufEnter * exec --inoremap <silent> -- . g:UltiSnipsExpandTrigger . -- <C-R>=g:UltiSnips_Complete()<cr>--
-- let g:UltiSnipsJumpForwardTrigger=--<tab>--
-- -- let g:UltiSnipsListSnippets=--<c-e>--
-- -- this mapping Enter key to <C-y> to chose the current highlight item
-- -- and close the selection list, same as other IDEs.
-- -- CONFLICT with some plugins like tpope/Endwise
-- inoremap <expr> <CR> pumvisible() ? --\<C-y>-- : --\<C-g>u\<CR>--

-- UltiSnips is the default bundle used by UltiSnips. It is installed via
-- 'vim-snippets' plugin
vim.api.nvim_set_var('UltiSnipsSnippetDirectories', { "UltiSnips", "vim-jfsnippets/jfsnippets" })


------------------------------------------------------
---lightline configuration
------------------------------------------------------

-- -- mode is already displayed in the status line
-- vim.opt.showmode = false

-- vim.api.nvim_set_var('lightline', {
--   colorscheme = 'dracula',
--   active = {
--     left = { { 'mode', 'paste' },
--       { 'githunks', 'gitbranch', 'readonly', 'filename', 'modified' } }
--   },
--   component = {
--     filename = '%f:%n'
--   },
--   component_function = {
--     githunks = 'LightlineGitGutter',
--     gitbranch = 'FugitiveHead'
--   },
-- })

-- -- " solutions to include git-gutter in lightline: https://github.com/airblade/vim-gitgutter/issues/674
-- -- " taken from here: https://gitlab.com/polyzen/dotfiles/blob/dce37955a745ee23efd247306781f8bc4a4d62bc/base/.vim/vimrc#L158
-- vim.api.nvim_exec([[
--   function! LightlineGitGutter()
--   if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
--     " echo "gitgutter"
--     return ''
--   endif
--   "   echo 'returned empty'
--   let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
--   return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
-- endfunction]], false)

-- if vim.fn.has('title') then
--   vim.opt.title = true
--   vim.opt.titlestring = "%F"
-- end
