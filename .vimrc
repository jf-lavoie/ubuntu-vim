set nocompatible
source $VIMRUNTIME/vimrc_example.vim
" source $VIMRUNTIME/mswin.vi
" behave mswin

" pathogen plugin startin
call pathogen#infect()
syntax on
filetype plugin indent on

" set diffexpr=MyDiff()
" function MyDiff()
" let opt = '-a --binary '
" if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
" if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
" let arg1 = v:fname_in
" if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
" let arg2 = v:fname_new
" if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
" let arg3 = v:fname_out
" if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
" let eq = ''
" if $VIMRUNTIME =~ ' '
" if &sh =~ '\<cmd'
" let cmd = '""' . $VIMRUNTIME . '\diff"'
" let eq = '"'
" else
" let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
" endif
" else
" let cmd = $VIMRUNTIME . '\diff'
" endif
" silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
" endfunction

syntax enable

" set color scheme
" ---------------------------------------------------
"  vim-monokai-tasty configs
" ---------------------------------------------------
let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty

" Display line number
set number
set relativenumber

" Diff always vertical
set diffopt=vertical

" make backspace work like most other apps
set backspace=indent,eol,start

" sets trailing spaces and tabs to easily visible characters
set list listchars=tab:->,trail:.,

" Show all the white space character
set list

" Change the current directory to the open file
" set autochdir

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

" ---------------------------------------------------
" Tabulation and identation
" ---------------------------------------------------
" preserve current indent on new lines
set autoindent
" Do not wrap lines
set nowrap
" indent/outdent to nearest tabstops
set shiftround
" indentation levels every four columns
set tabstop=2
" "number of space characters inserted for indentation
set shiftwidth=2
" this is to make sure vim replaces tabs by spaces
set expandtab

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
" JS specific shortcuts
" ---------------------------------------------------
" in order to prevent some plugins (like delimiter) to interfer with the typed
" characters, the content is provided to a register, and this register is
" printed
" the delimiter plugin was adding double quote, single quotes, ....
" using the registers make those mapping agnostic of the plugins.
" the 'oi<BS><esc>' is just to et leverage the automatic indentation provided
" by vim 'o' while still returning in normal mode with the <esc>
autocmd FileType javascript nmap <buffer> <F2> yiwoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript vmap <buffer> <F2> yoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript nmap <buffer> <F3> oi<BS><esc>:let @m = 'console.log(''jf-debug-> arguments: '', arguments);'<enter><esc>"mp<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
autocmd FileType javascript nmap <buffer> <F4> yiwoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', require(''util'').inspect(' . @" . ', {depth:100, colors:true}));'<enter><esc>"mp
autocmd FileType javascript vmap <buffer> <F4> yoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', require(''util'').inspect(' . @" . ', {depth:100, colors:true}));'<enter><esc>"mp

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
let $PATH .= ':./node_modules/.bin'

" when using gf in javascript file, the extension is not set most of the time.
" :help path
" :help suffixesadd
" found here: https://stackoverflow.com/questions/1932604/vim-problem-with-gf-command
" https://til.hashrocket.com/posts/fef382f93e-use-suffixadd-to-save-yourself-some-life
autocmd BufRead,BufNewFile *.js set suffixesadd+=.js,.json


" ---------------------------------------------------
" YouCompleteMe configs
" ---------------------------------------------------
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_always_populate_loc_list = 0
let g:ycm_always_populate_location_list = 0
" ---------------------------------------------------
" Syntastic configs
" ---------------------------------------------------
let g:syntastic_javascript_checkers = ['eslint']
" node developpers usually let the exeuctable sit in the local repo.
" taken here:https://github.com/vim-syntastic/syntastic/issues/1692 
" alternative if not working: https://github.com/mtscout6/syntastic-local-eslint.vim
" THIS SOLUTION WAS REPLACED BY ADDING LOCAL NODE_MODULES TO THE PATH AS
" DESCRIBED HERE https://github.com/npm/npm/issues/957
" let g:syntastic_javascript_eslint_generic = 1
" let g:syntastic_javascript_eslint_exec = '/bin/ls'
" let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
" let g:syntastic_javascript_eslint_args='-f compact'

" let g:syntastic_quiet_messages = { "level" : "warnings" }
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"] " hides angular eerrors. source: http://stackoverflow.com/questions/18270355/how-to-ignore-angular-directive-lint-error-with-vim-and-syntastic
let g:syntastic_always_populate_loc_list = 1 "Enable this option to tell syntastic to always stick any detected errors into the |location-list|:
let g:syntastic_auto_loc_list = 1 " When set to 1 the error window will be automatically opened when errors are detected, and closed when none are detected. >
let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["html"] }
" let g:syntastic_debug = 1


" ---------------------------------------------------
" UtilsSnip configs
" ---------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
function! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    if pumvisible()
      return "\<C-n>"
    else
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        return "\<TAB>"
      endif
    endif
  endif
  return ""
endfunction
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsListSnippets="<c-e>"
" this mapping Enter key to <C-y> to chose the current highlight item
" and close the selection list, same as other IDEs.
" CONFLICT with some plugins like tpope/Endwise
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" UltiSnips is the default bundle used by UltiSnips. It is installed via
" 'vim-snippets' plugin
let g:UltiSnipsSnippetDirectories=["UltiSnips", "jfsnippets"]


" ---------------------------------------------------
" EasyAlign setup
" ---------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" ---------------------------------------------------
" terryma/vim-multiple-cursors setup
" ---------------------------------------------------
" When in insert mode, 'esc' does not exit multi cursor mode but rather fall
" back to normal. A 2nd 'esc' quits multi cursors.
let g:multi_cursor_exit_from_insert_mode=0
" When in visual mode, 'esc' does not exit multi cursor mode but rather fall
" back to normal. A 2nd 'esc' quits multi cursors.
let g:multi_cursor_exit_from_visual_mode=0

" ---------------------------------------------------
" ag vim configs
" ---------------------------------------------------
" hightlight the search results
let g:ag_highlight=1
" <C-r><C-w> returns the word under the cursor
" info taken here: http://stackoverflow.com/questions/13511084/vim-set-cursor-position-in-command-line
" and here: http://stackoverflow.com/questions/27297304/how-to-append-the-output-of-a-function-in-a-normal-mapping-command/27297508
" autocmd FileType javascript,json,yaml,dockerfile nnoremap <buffer> <expr> <leader>f ':Ag --ignore node_modules --ignore assets -S "" "' . getcwd() . '"<C-Left><Left><Left>'
" <C-r><C-w> returns the word under the cursor
" autocmd FileType javascript,json,yaml,dockerfile nnoremap <buffer> <expr> <leader>fw ':Ag --ignore node_modules --ignore assets -S "<C-r><C-w>" "' . getcwd() . '"<C-Left><Left><Left>'

nnoremap  <expr> <leader>f ':Ag --ignore node_modules -S "" "' . getcwd() . '"<C-Left><Left><Left>'
" <C-r><C-w> returns the word under the cursor
nnoremap  <expr> <leader>fw ':Ag --ignore node_modules -S "<C-r><C-w>" "' . getcwd() . '"<C-Left><Left><Left>'

" ---------------------------------------------------
" neoformat configs
" ---------------------------------------------------
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_js = ['prettier']
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_less = ['prettier']
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_enabled_scss = ['prettier']
let g:neoformat_enabled_typescript = ['prettier'] " is this working?
let g:neoformat_enabled_vue = ['prettier'] " is this working?
let g:neoformat_enabled_yaml = ['prettier'] " is this working?
" let g:neoformat_try_prettier = 1
" let g:neoformat_verbose = 1
noremap <C-F3> :Neoformat<CR>
:autocmd BufWritePre *.js,*.css,*.json :Neoformat


" ---------------------------------------------------
" CTRL-P configuration
" ---------------------------------------------------
let g:ctrlp_max_depth = 40
let g:ctrlp_max_files = 0
let g:ctrlp_show_hidden = 1
" beware of the escaped OR in regex
let g:ctrlp_custom_ignore = 'node_modules\|git'
" tip: how to use silver searcher for faster result: https://github.com/kien/ctrlp.vim/issues/58#issuecomment-247017402


" ---------------------------------------------------
" NERDTree configuration
" ---------------------------------------------------
if !&diff " do not open nerdtree on diff mode
  " automatically open NERDTree when vim opens, even when no files are specified.
  " source: https://github.com/scrooloose/nerdtree
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  " automatically open NERDTree when a file is specified at command line
  autocmd vimenter * NERDTree
endif


" ---------------------------------------------------
" lightline configuration
" ---------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'monokai_tasty',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'filename': '%n:%t'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
set noshowmode " mode is already displayed in the status line

" how-to see the non-visible while spaces
" :set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" :set list
" but hei how-to unset the visible tabs ?!
" :set nolist

