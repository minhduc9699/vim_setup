" Leader
let mapleader = " "

set encoding=UTF-8
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

set autoindent
set smartindent

set autoread
set autowrite

" Softtabs, 2 spaces
let g:python_recommended_style=0
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Display extra whitespace
" set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Numbers
set relativenumber
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Autocomplete with dictionary words when spell check is on
set nospell
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Copy to clipboard
set clipboard=unnamed

set lazyredraw
set termguicolors

set background=dark

set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing

let g:quantum_italics=1
colorscheme quantum

filetype plugin indent on

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

augroup vimrcEx
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Go file config
"au FileType go set noexpandtab
"au FileType go set shiftwidth=4
"au FileType go set softtabstop=4
"au FileType go set tabstop=4

au BufRead,BufNewFile .eslintrc.json setlocal filetype=json
au BufRead,BufNewFile .babelrc setlocal filetype=json
au BufRead,BufNewFile .prettierrc setlocal filetype=json

au BufRead,BufNewFile .babelrc.js setlocal filetype=javascript
au BufRead,BufNewFile .sequelizerc setlocal filetype=javascript

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1
let g:rainbow_active = 1
let g:rainbow_conf = {
	\	'separately': {
  \   '*': {},
	\		'nerdtree': 0,
  \  'javascript': {
  \    'operators': '_,\|+\|-\|\*\|\*\*\| / \|//\|===\|!==\|==\|!=\| < \|<=\| > \|>=\|:\|%\|&\||_',
  \    'parentheses_options': 'containedin=jsxElement fold ',
  \    'parentheses': [
  \      'start=/\z((\)/ end=/)/ contains=@jsAll', 'start=/\[/ end=/\]/ contains=@jsAll',
  \      'start=/{/ end=/}/ contains=@jsAll containedin=jsTemplateString',
  \      'start=_<\z([^ />]*\)>\?_ end=_</\z1>_ end=_/>_ contains=jsxOpenTag,jsxAttrib,jsxExpressionBlock,jsxSpreadOperator,jsComment,@javascriptComments,javaScriptLineComment,javaScriptComment',
  \    ],
  \    'after': [
  \      'syn clear jsParen', 'syn clear jsFuncArgs', 'syn clear jsxExpressionBlock',
  \      'syn clear jsParensError', 'syn clear jsParenIfElse', 'syn clear jsDestructuringBlock',
  \      'syn clear jsFuncBlock', 'syn clear jsArrowFuncArgs', 'syn clear jsParenSwitch',
  \      'syn clear jsBlock', 'syn clear jsObject', 'syn clear jsxTag', 'syn clear jsTemplateExpression',
  \      'syn clear jsParenRepeat', 'syn clear jsRepeatBlock'
  \    ],
  \    'contains_prefix': '',
  \  },
  \  'typescript': 0,
	\	}
	\}
let g:surround_no_mappings = 1
xmap <Leader>s   <Plug>VSurround
" Use tab with text block

let g:UltiSnipsExpandTrigger = '<f5>'
let g:UltiSnipsListSnippets = 'f4'
vmap <Tab> >gv
vmap <S-Tab> <gv

" Get off my lawn
"nnoremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

map J <C-e>
map K <C-y>

nnoremap # ^
nnoremap <C-s> :w<CR>
nnoremap <Leader>w <C-w>

" Remove highlight
map <C-h> :nohl<CR>

" NERD tree configuration
noremap <C-d> :NERDTreeToggle<CR>
"nnoremap F :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['^node_modules$[[dir]]', '^__pycache__$[[dir]]']

" TAGBAR key binding
let g:Tlist_Ctags_Cmd='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
nmap <Leader>mm :TagbarToggle<CR>


" fzf
noremap ` :Files<CR>
noremap ; :Buffers<CR>

" bind \ (backward slash) to grep shortcut
nnoremap F :Ag <C-R><C-W><CR>
nnoremap f /<C-R><C-W><CR>
nnoremap \ :Ag<SPACE>

" coc.vim config
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ge :<C-u>CocList diagnostics<cr>

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

nmap <Leader>f :Format <CR>

" Easymotion
" s{char}{char} to move to {char}{char} over windows
"nmap <Leader>F <Plug>(easymotion-overwin-f)
" Move to line over windows
"nmap <Leader>L <Plug>(easymotion-overwin-line)
" Search n-chars
map / <Plug>(easymotion-sn)

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : '') : ''
endfunction

function! LightLineFilename()
  let name = ""
  let subs = split(expand('%'), "/")
  let i = 1
  for s in subs
    let parent = name
    if  i == len(subs)
      let name = len(parent) > 0 ? parent . '/' . s : s
    elseif i == 1
      let name = s
    else
      let part = strpart(s, 0, 10)
      let name = len(parent) > 0 ? parent . '/' . part : part
    endif
    let i += 1
  endfor
  return name
endfunction

" Lightline
let g:lightline = {
      \ 'colorscheme': 'quantum',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fileicon', 'filename', 'cocstatus', 'readonly', 'modified' ] ],
      \   'right': [ [ 'lineinfo', 'percent' ],
      \              [ 'gitbranch'] ]
      \ },
      \ 'inactive': {
      \   'left': [ [], ['fileicon'], [ 'filename' ] ],
      \   'right': []
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'cocstatus': 'coc#status',
      \   'filename': 'LightLineFilename',
      \   'fileicon': 'MyFiletype'
      \ },
      \ }

" Multi select
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'

" fzf.vim
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Auto close tag
let g:closetag_filenames = '*.html,*.js,*.jsx,*.vue'
let g:closetag_emptyTags_caseSensitive = 1
let g:jsx_ext_required = 0

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
