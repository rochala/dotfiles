call plug#begin()
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'maximbaz/lightline-ale'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'psf/black'
Plug 'tpope/vim-fugitive'
Plug 'skammer/vim-css-color'
Plug 'mbbill/undotree'
call plug#end()
"fzf
set rtp+=/usr/local/opt/fzf

if (has("termguicolors"))
    set termguicolors
endif
syntax enable
colorscheme dracula

set secure

if has('vim-starting')
    set encoding=utf8
endif
set noshowmode

set number relativenumber
set cursorline
set backspace=indent,eol,start

set shell=$SHELL           " Use zsh as shell
set viminfo=/100,:100,'100 " Save command history and search patterns
set autoread               " Automatically load changes
set undolevels=1000        " Large undo levels
set history=200            " Size of command history
set nobackup               " Disable backups
set clipboard=unnamed      " Use the OS clipboard by default
set ttyfast                " Optimize for fast terminal connections
set lazyredraw             " Wait to redraw
set ttimeout               " Timeout on keycodes
set ttimeoutlen=10         " Small timeout to reduce lag when pressing ESC in terminal
set noerrorbells visualbell t_vb=


" set scrolloff=5

set smartcase
set nowrapscan
set incsearch
set gdefault

set confirm
set noerrorbells
set nostartofline
set wrap
set linebreak
set splitbelow
set splitright
set synmaxcol=240
set vb t_vb=
set virtualedit=onemore
set signcolumn=yes
set winheight=999

syntax enable
filetype indent on
filetype plugin on
set autoindent

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set shiftround
set smarttab
set smartindent
set lazyredraw
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch


set ignorecase

let g:ale_linters = {
    \ 'python': ['flake8','pylint', 'bandit', 'mypy' ]
    \}

let g:ale_fixers = {
      \    'python': ['black', 'isort'],
      \}
nmap <F10> :ALEFix<CR>
let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_hover_to_preview = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_virtualtext_cursor = 1


" Lightline {{{
let g:lightline = {
  \   'colorscheme': 'dracula',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \     ]
  \   },
	\   'component': {
	\     'lineinfo': ' %3l:%-2v',
	\   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   }
  \ }
let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ }
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline

"nerdtree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = -1
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-S-t> :NERDTreeToggle<CR>
" manage splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

let s:term_buf = 0
let s:term_win = 0

function! TermToggle(height)
    if win_gotoid(s:term_win)
        hide
    else
        new terminal
        exec "resize " . a:height
        try
            exec "buffer " . s:term_buf
            exec "bd terminal"
        catch
            call termopen($SHELL, {"detach": 0})
            let s:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
            set nocursorline
        endtry
        startinsert!
        let s:term_win = win_getid()
    endif
endfunction
nnoremap <c-n> :call TermToggle(12)<CR>
hi! ALEError ctermbg=DarkMagenta
nnoremap ; :
