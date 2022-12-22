" enew|pu=execute('let')
" enew|pu=execute('scriptnames')
" enew|pu=execute('messages')
set nocompatible

let s:luaconfigfile=stdpath('config').'/init.vim.lua'
echo "sourcing: ".s:luaconfigfile
execute "source ".s:luaconfigfile


filetype plugin indent on


" debug syntax highlighting. source: https://vim.fandom.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
" map <leader>q :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" function! Myfunc()
"   for id in synstack(line("."), col("."))
"     echo synIDattr(id, "name")
"   endfor
" endfunction

" map <leader>q2 :call Myfunc()<CR>



" packadd! dracula
syntax enable
colorscheme dracula

" special check for windows terminal
" https://github.com/microsoft/terminal/issues/1040
" https://gist.github.com/XVilka/8346728
if $COLORTERM == "truecolor" || ($TERM == "xterm-256color" && !empty($WSL_DISTRO_NAME))
  set termguicolors
endif

" ---------------------------------------------------


" do not resize windows when closing a window
" source: https://stackoverflow.com/questions/486027/close-a-split-window-in-vim-without-resizing-other-windows
set noequalalways

" Display line number
set number
set relativenumber

" Diff always vertical
set diffopt=vertical

" make backspace work like most other apps
set backspace=indent,eol,start

" sets trailing spaces and tabs to easily visible characters
set list listchars=tab:>\ ,trail:.,
" set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" how-to see the non-visible while spaces
" :set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" :set list
" but hei how-to unset the visible tabs ?!
" :set nolist

" Show all the white space character
set list

set scrolloff=4
set sidescrolloff=5

" Change the current directory to the open file
" set autochdir
"


" set cursorline on entering, set nocursorline on leaving
" source: https://vim.fandom.com/wiki/Highlight_current_line

let g:cursorline_enabled = 1
" function! ToggleCursorLine()
"   let l:previous = get(g:, 'cursorline_enabled')
"   let g:cursorline_enabled = !l:previous
"   if get(g:, 'cursorline_enabled') == 1
"     setlocal cursorline
"   else
"     set nocursorline
"   endif
" endfunction

" augroup CursorLine
"   au!
"   au VimEnter,WinEnter,BufWinEnter * if get(g:,'cursorline_enabled') == 1 | setlocal cursorline | endif
"   au WinLeave * setlocal nocursorline
" augroup END

" nnoremap <leader>c :call ToggleCursorLine()<CR>

" ---------------------------------------------------
" Search
" ---------------------------------------------------
set hlsearch
" Press F3 to toggle highlighting on/off.
:noremap <F3> :set hls!<CR>
" Ignore case when searching
set ignorecase
" use case-sensitive search if your search contains an uppercase character
set smartcase
" Show the search result as you type
set incsearch

if has('nvim')
  set inccommand=nosplit
endif

" ---------------------------------------------------
" Tabulation and identation
" ---------------------------------------------------
" preserve current indent on new lines
set autoindent
" Do not wrap lines
set nowrap
" indent/outdent to nearest tabstops
set shiftround
" indentation levels every two columns
set tabstop=2
" "number of space characters inserted for indentation
set shiftwidth=2
" this is to make sure vim replaces tabs by spaces
set expandtab

" python is special
au BufNewFile,BufRead *.py set
      \ tabstop=4
      \ softtabstop=4
      \ shiftwidth=4
      \ expandtab
      \ autoindent
      \ fileformat=unix

"----------------------------------------------------
" Beeping
"----------------------------------------------------
" Do not ring the bell for error messages
set noerrorbells
" Use visual bell and remove flash
autocmd VimEnter * set vb t_vb=

" ---------------------------------------------------
" Remove the backup option (~ and .swp files)
" ---------------------------------------------------
set nobackup
set nowritebackup
set noswapfile
set noundofile

" ---------------------------------------------------
" Trim extra white spaces at end of lines
" ---------------------------------------------------
" autocmd BufWritePre *.py normal m`:%s/\s\+$//e


" ---------------------------------------------------
" Custom shortcuts
" ---------------------------------------------------
nmap <F6> :let @+ = expand("%:p")<cr>


" taken from here: https://stackoverflow.com/questions/1236563/how-do-i-run-a-terminal-inside-of-vim/29293191#29293191
" tnoremap <ESC><ESC> <C-\><C-n>
" taken from here: https://github.com/junegunn/fzf.vim/issues/544#issuecomment-498202592
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

if has('nvim')
  autocmd TermOpen * startinsert
  " autocmd TermOpen * tnoremap <ESC><ESC> <C-\><C-n>
else
  autocmd BufNew * if &buftype=="terminal" | startinsert | endif
endif
autocmd BufEnter * if &buftype=="terminal" | startinsert | endif

" nmap <F5> :NERDTreeFind<CR>

" ---------------------------------------------------

" ---------------------------------------------------
" JS specific shortcuts
" ---------------------------------------------------
" in order to prevent some plugins (like delimiter) to interfer with the typed
" characters, the content is provided to a register, and this register is
" printed
" the delimiter plugin was adding double quote, single quotes, ....
" using the registers make those mapping agnostic of the plugins.
" the 'oi<BS><esc>' is just to et leverage the automatic indentation provided by vim 'o'
" while still returning in normal mode with the <esc>
autocmd FileType javascript,vue,typescript nmap <buffer> <F2> yiwoi<BS><esc>:let @m = 'console.log("jf-debug-> ''' . @" . ''': ", ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript,vue,typescript vmap <buffer> <F2> yoi<BS><esc>:let @m = 'console.log("jf-debug-> ''' . @" . ''': ", ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript,vue,typescript nmap <buffer> <F3> oi<BS><esc>:let @m = 'console.log("jf-debug-> arguments: ", arguments);'<enter><esc>"mp<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
autocmd FileType javascript,vue,typescript nmap <buffer> <F4> yiwoi<BS><esc>:let @m = 'console.log("jf-debug-> ''' . @" . ''': ", require("util").inspect(' . @" . ', { depth: 100, colors: false }));'<enter><esc>"mp
autocmd FileType javascript,vue,typescript vmap <buffer> <F4> yoi<BS><esc>:let @m = 'console.log("jf-debug-> ''' . @" . ''': ", require("util").inspect(' . @" . ', { depth: 100, colors: false }));'<enter><esc>"mp

" ---------------------------------------------------
" GO specific shortcuts
" ---------------------------------------------------
" in order to prevent some plugins (like delimiter) to interfer with the typed
" characters, the content is provided to a register, and this register is
" printed
" the delimiter plugin was adding double quote, single quotes, ....
" using the registers make those mapping agnostic of the plugins.
" the 'oi<BS><esc>' is just to et leverage the automatic indentation provided by vim 'o'
" while still returning in normal mode with the <esc>
autocmd FileType go nmap <buffer> <F2> yiwoi<BS><esc>:let @m = 'fmt.Printf("jf-debug-> ''' . @" .''': %#v\n", ' . @" . ');'<enter><esc>"mp
autocmd FileType go vmap <buffer> <F2> yoi<BS><esc>:let @m = 'fmt.Printf("jf-debug-> ''' . @" .''': %#v\n", ' . @" . ');'<enter><esc>"mp

" ---------------------------------------------------
" Adding batch file comment type. Used with plugin commentary
" ---------------------------------------------------
autocmd FileType dosbatch set commentstring=::\ %s

" ---------------------------------------------------
" Chaning the font for MAC only because the base font is too small.
" ---------------------------------------------------
if has('mac')
  set guifont=Menlo\ Regular:h13
" elseif has('unix')
"   set guifont=Droid\ Sans\ Mono\ 11
endif



" generic solution to let syntastic, neoformat, ...
" find locally installed node_modules and not requiring a global installation.
" find here: https://github.com/npm/npm/issues/957
let $PATH = './node_modules/.bin:'.$PATH

" when using gf in javascript file, the extension is not set most of the time.
" :help path
" :help suffixesadd
" found here: https://stackoverflow.com/questions/1932604/vim-problem-with-gf-command
" https://til.hashrocket.com/posts/fef382f93e-use-suffixadd-to-save-yourself-some-life
autocmd BufRead,BufNewFile *.js set suffixesadd+=.js,.json



" ---------------------------------------------------
" FZF configs
" ---------------------------------------------------

set rtp+=~/.fzf
nnoremap <C-p> :call fzf#run(
  \   fzf#wrap(
  \     fzf#vim#with_preview()
  \   ))<enter>

" taken here: https://github.com/junegunn/fzf.vim/issues/1081
" linked there: https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <leader>fr :RG<enter>

" taken here: https://github.com/junegunn/fzf.vim#example-rg-command-with-preview-window
" and here: https://github.com/junegunn/fzf.vim/issues/714#issuecomment-428802659
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

nnoremap <leader>f :Rg<enter>
" <C-r><C-w> returns the word under the cursor
nnoremap <leader>fw :Rg  <C-r><C-w><enter>


" todo: future improvement: add a visual selection search. Hightlight test in
" visual mode than search for it using Rg.
" see https://stackoverflow.com/questions/41238238/how-to-map-vim-visual-mode-to-replace-my-selected-text-parts
" to get visual selection
" if no selection, revert to current behavior of <C-r><C-w>

" taken here: https://github.com/dracula/vim/blob/master/colors/dracula.vim
" modified the border
if g:colors_name == 'dracula'
  " echo "should I set colors of fzf"

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
endif

" ---------------------------------------------------


" ---------------------------------------------------
" UtilsSnip configs
" ---------------------------------------------------
" " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" " let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsExpandTrigger="<leader><tab>"
" " let g:UltiSnipsJumpForwardTrigger="<c-b>"
" " let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" " If you want :UltiSnipsEdit to split your window.
" " let g:UltiSnipsEditSplit="vertical"
" function! g:UltiSnips_Complete()
"   call UltiSnips#ExpandSnippet()
"   if g:ulti_expand_res == 0
"     if pumvisible()
"       return "\<C-n>"
"     else
"       call UltiSnips#JumpForwards()
"       if g:ulti_jump_forwards_res == 0
"         return "\<TAB>"
"       endif
"     endif
"   endif
"   return ""
" endfunction
" au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" " let g:UltiSnipsListSnippets="<c-e>"
" " this mapping Enter key to <C-y> to chose the current highlight item
" " and close the selection list, same as other IDEs.
" " CONFLICT with some plugins like tpope/Endwise
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" UltiSnips is the default bundle used by UltiSnips. It is installed via
" 'vim-snippets' plugin
let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim-jfsnippets/jfsnippets"]


" ---------------------------------------------------
" NERDTree configuration
" ---------------------------------------------------
" if !&diff " do not open nerdtree on diff mode
"   " automatically open NERDTree when vim opens, even when no files are specified.
"   " source: https://github.com/scrooloose/nerdtree
"   autocmd StdinReadPre * let s:std_in=1
"   autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd l  | endif
"   " automatically open NERDTree when a file is specified at command line
"   autocmd vimenter * NERDTree | wincmd l
" endif


" ---------------------------------------------------
" lightline configuration
" ---------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'githunks', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'filename': '%f:%n'
      \ },
      \ 'component_function': {
      \   'githunks': 'LightlineGitGutter',
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
set noshowmode " mode is already displayed in the status line

" solutions to include git-gutter in lightline: https://github.com/airblade/vim-gitgutter/issues/674
" taken from here: https://gitlab.com/polyzen/dotfiles/blob/dce37955a745ee23efd247306781f8bc4a4d62bc/base/.vim/vimrc#L158
function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
    " echo "gitgutter"
    return ''
  endif
  "   echo 'returned empty'
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

if has('title')
  set title titlestring="%F"
endif



" ---------------------------------------------------
" vim-closetag
" ---------------------------------------------------
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx,js'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'
" ---------------------------------------------------


" ---------------------------------------------------
" vim-go
" ---------------------------------------------------

" hi! link Identifier DraculaCyan
" highlight link goBuiltins Keyword

let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
" let g:go_highlight_operators = 1
"

" really specific thing to my taste.
" vim-go maps builtin to syntax 'Keyword' and map to highlight 'Identifier'
" source: https://github.com/fatih/vim-go/blob/master/syntax/go.vim#L50
" introduced in commit: https://github.com/fatih/vim-go/commit/25d47834bf1d8de9eb7fc9d6ad0aa995dfda8142#diff-6c12071ba887bcb758b2bb5627e5bd19705a4d45bacff48d5b26e056869aa883
"
" Dracula maps Identifier syntax to highlight 'DraculaFg' which is just the
" normal color. source: https://github.com/dracula/vim/blob/master/colors/dracula.vim#L282
"
" I prefer to have the builtins in colors. Here I remap the goBuiltins
if g:colors_name == 'dracula'
  hi def link     goBuiltins                 DraculaCyanItalic
endif

let g:go_metalinter_autosave = 1
let g:go_metalinter_command = "golangci-lint run --fast"
let g:go_fmt_command = 'goimports'

" coc and vim-go competes for the same shortcuts: K and gd. (maybe more?)
" https://github.com/fatih/vim-go/commit/8c589255cba97103b84c0c8de74d233521613195
" https://github.com/fatih/vim-go/blob/d2dfc048a07c81d016ee97f7eb8a297d0f1c6aeb/ftplugin/go.vim
" they both start a gopls server
" unable to make them work nicely togheter....using both with their own
" server.
" " using coc for language server instead
" let g:go_gopls_enabled = 0
" let g:go_def_mapping_enabled = 0
" ---------------------------------------------------


" ---------------------------------------------------
" vim-markdown
" ---------------------------------------------------
" default is 4
let g:vim_markdown_new_list_item_indent = 2
" ---------------------------------------------------

" ---------------------------------------------------
" vim-subversive
" ---------------------------------------------------
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

" prompt with the native vim substitute command
let g:subversivePromptWithActualCommand=1

" ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<cr>

" iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<cr>
" ---------------------------------------------------

" ---------------------------------------------------
" vim-highlightedyank
" ---------------------------------------------------
let g:highlightedyank_highlight_duration = 300
" highlight HighlightedyankRegion cterm=reverse gui=reverse
" ---------------------------------------------------


" ---------------------------------------------------
" Yggdroot/indentLine
" ---------------------------------------------------
" let g:vim_json_syntax_concealcursor=0
" otherwise, vim-json can't do its work
" source: https://github.com/elzr/vim-json/blob/master/readme.md
" and https://github.com/elzr/vim-json/issues/23#issuecomment-40293049
let g:indentLine_concealcursor=""
" let g:vim_json_syntax_concealcursor=""
" augroup JsonCursor
"   au!
"   au VimEnter,WinEnter,BufWinEnter *.json set concealcursor=""
"   " au Filetype json set concealcursor=""
"   " au WinLeave * setlocal nocursorline
" augroup END
" ---------------------------------------------------

" ---------------------------------------------------
" wfxr/minimap.vim
" ---------------------------------------------------
" disable minimap for specific file types  
let g:minimap_block_filetypes = ['fugitive', 'nerdtree', 'neo-tree'] 
" ---------------------------------------------------
