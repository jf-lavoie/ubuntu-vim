set nocompatible
" source $VIMRUNTIME/mswin.vi
" behave mswin

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
" indentation levels every two columns
set tabstop=2
" "number of space characters inserted for indentation
set shiftwidth=2
" this is to make sure vim replaces tabs by spaces
set expandtab

" python is special
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

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
" Custon shortcuts
" ---------------------------------------------------
" taken from here: https://stackoverflow.com/questions/1236563/how-do-i-run-a-terminal-inside-of-vim
tnoremap <ESC><ESC> <C-\><C-n>
if has('nvim')
  autocmd TermOpen * startinsert
else
  autocmd BufNew * if &buftype=="terminal" | startinsert | endif
endif
autocmd BufEnter * if &buftype=="terminal" | startinsert | endif
" ---------------------------------------------------

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
autocmd FileType javascript,vue nmap <buffer> <F2> yiwoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript,vue vmap <buffer> <F2> yoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript,vue nmap <buffer> <F3> oi<BS><esc>:let @m = 'console.log(''jf-debug-> arguments: '', arguments);'<enter><esc>"mp<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
autocmd FileType javascript.vue nmap <buffer> <F4> yiwoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', require(''util'').inspect(' . @" . ', {depth:100, colors:false}));'<enter><esc>"mp
autocmd FileType javascript,vue vmap <buffer> <F4> yoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', require(''util'').inspect(' . @" . ', {depth:100, colors:false}));'<enter><esc>"mp

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
" ale configs
" ---------------------------------------------------
" let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\}
" ---------------------------------------------------

" ---------------------------------------------------
" coc configs
" ---------------------------------------------------
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
" changed by JF, <leader>f is used for searching
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" ---------------------------------------------------


" ---------------------------------------------------
" FZF configs
" ---------------------------------------------------

set rtp+=~/.fzf
nnoremap <C-p> :call fzf#run(
  \   fzf#wrap(
  \     fzf#vim#with_preview()
  \   ))<enter>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
nnoremap <leader>f :Rg<enter>
" <C-r><C-w> returns the word under the cursor
nnoremap <leader>fw :Rg  <C-r><C-w><enter>
" ---------------------------------------------------


" ---------------------------------------------------
" UtilsSnip configs
" ---------------------------------------------------
" " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" " let g:UltiSnipsExpandTrigger="<tab>"
" " let g:UltiSnipsExpandTrigger="<leader>s"
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
" " let g:UltiSnipsJumpForwardTrigger="<tab>"
" " let g:UltiSnipsListSnippets="<c-e>"
" " this mapping Enter key to <C-y> to chose the current highlight item
" " and close the selection list, same as other IDEs.
" " CONFLICT with some plugins like tpope/Endwise
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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
let g:neoformat_enabled_go = ['gofmt', 'goimports', 'gofumpt', 'gofumports']
noremap <C-F3> :Neoformat<CR>
:autocmd BufWritePre *.js,*.css,*.json,*.vue,*.ts,*.yml,*.yaml,*.css,*.less,*.scss,*.go :Neoformat


" ---------------------------------------------------
" NERDTree configuration
" ---------------------------------------------------
if !&diff " do not open nerdtree on diff mode
  " automatically open NERDTree when vim opens, even when no files are specified.
  " source: https://github.com/scrooloose/nerdtree
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd l  | endif
  " automatically open NERDTree when a file is specified at command line
  autocmd vimenter * NERDTree | wincmd l
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
      \   'filename': '%F:%n'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
set noshowmode " mode is already displayed in the status line

if has('title')
  set title titlestring="%F"
endif

" how-to see the non-visible while spaces
" :set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" :set list
" but hei how-to unset the visible tabs ?!
" :set nolist


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
" vim-go
" ---------------------------------------------------
" taken here: https://medium.com/@furkanbegen/go-development-with-vim-79cfa0a928b0
let g:go_def_mapping_enabled = 0
