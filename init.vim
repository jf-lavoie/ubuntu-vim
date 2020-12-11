" enew|pu=execute('let')
" enew|pu=execute('scriptnames')
" enew|pu=execute('messages')
set nocompatible

filetype plugin indent on

" set color scheme
" ---------------------------------------------------
"  vim-monokai-tasty configs
" ---------------------------------------------------
" let g:monokai_term_italic = 1
" let g:monokai_gui_italic = 1
" colorscheme monokai

packadd! dracula
syntax enable
colorscheme dracula


if $COLORTERM == "truecolor" 
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
function! ToggleCursorLine()
  let l:previous = get(g:, 'cursorline_enabled')
  let g:cursorline_enabled = !l:previous
  if get(g:, 'cursorline_enabled') == 1
    setlocal cursorline
  else
    set nocursorline
  endif
endfunction

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * if get(g:,'cursorline_enabled') == 1 | setlocal cursorline | endif
  au WinLeave * setlocal nocursorline
augroup END

nnoremap <leader>c :call ToggleCursorLine()<CR>

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
" Custon shortcuts
" ---------------------------------------------------
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
autocmd FileType javascript,vue nmap <buffer> <F2> yiwoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript,vue vmap <buffer> <F2> yoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', ' . @" . ');'<enter><esc>"mp
autocmd FileType javascript,vue nmap <buffer> <F3> oi<BS><esc>:let @m = 'console.log(''jf-debug-> arguments: '', arguments);'<enter><esc>"mp<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
autocmd FileType javascript.vue nmap <buffer> <F4> yiwoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', require(''util'').inspect(' . @" . ', {depth:100, colors:false}));'<enter><esc>"mp
autocmd FileType javascript,vue vmap <buffer> <F4> yoi<BS><esc>:let @m = 'console.log(''jf-debug-> "' . @" . '": '', require(''util'').inspect(' . @" . ', {depth:100, colors:false}));'<enter><esc>"mp

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
" ale configs
" ---------------------------------------------------
" let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'go': ['golangci_lint']
\}

let g:ale_go_golangci_lint_options = '--enable-all'

" https://github.com/dense-analysis/ale/issues/591
" let g:ale_fixers = {
" \   'go': ['goimports']
" \}
" let g:ale_fix_on_save = 1

" If you wish to show Vim windows for the loclist or quickfix items when a file contains warnings or errors, 
" let g:ale_open_list=1 breaks when using terminal window...

" using coc instead https://github.com/dense-analysis/ale#5iii-how-can-i-use-ale-and-cocnvim-together
let g:ale_disable_lsp = 1
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
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" this new mapping was gotten here: https://github.com/neoclide/coc-snippets
inoremap <silent><expr> <TAB>
      \ pumvisible()
      \ ? coc#_select_confirm() 
      \ : coc#expandableOrJumpable()
      \   ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" 
      \   : <SID>check_back_space() 
      \     ? "\<TAB>" 
      \     : coc#refresh()

let g:UltiSnipsExpandTrigger='<Nop>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" source : https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
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
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

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
let g:UltiSnipsSnippetDirectories=["UltiSnips", "jfsnippets", "gosnippets/UltiSnips"]


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
" let g:multi_cursor_exit_from_insert_mode=0
" When in visual mode, 'esc' does not exit multi cursor mode but rather fall
" back to normal. A 2nd 'esc' quits multi cursors.
" let g:multi_cursor_exit_from_visual_mode=0

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
"
" goimports > gofmt : https://goinbigdata.com/goimports-vs-gofmt/
let g:neoformat_enabled_go = ['goimports', 'gofmt', 'gofumpt', 'gofumports']

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
      \   'gitbranch': 'fugitive#head'
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
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

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
