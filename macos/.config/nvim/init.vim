"[OPTIONS]"
syntax on

set mouse=a
set guicursor=
set noshowmatch
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set virtualedit=onemore
set splitright
set splitbelow
set nowritebackup
set lazyredraw
set clipboard+=unnamedplus
set breakindent
let &showbreak=repeat(' ', 3)
set linebreak
set cursorline
set updatetime=100
set shortmess+=c
set shortmess-=F
set wildignore+=*.o,*~,*.pyc,*pycache* " Ignore compiled files
set wildignore+=__pycache__
set completeopt=menuone,noinsert,noselect
set number
set signcolumn=number

set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

set formatoptions-=a    " Auto formatting is BAD.
set formatoptions-=t    " Don't auto format my code. I got linters for that.
set formatoptions+=c    " In general, I like it when comments respect textwidth
set formatoptions+=q    " Allow formatting comments w/ gq
set formatoptions-=o    " O and o, don't continue comments
set formatoptions+=r    " But do continue when pressing enter.
set formatoptions+=n    " Indent past the formatlistpat, not underneath it.
set formatoptions+=j    " Auto-remove comments if possible.
set formatoptions-=2    " I'm not in gradeschool anymore
set nojoinspaces        " Two spaces and grade school, we're done

if has('gui')
  " Turn off scrollbars. (Default on macOS is "egmrL").
  set guioptions-=L
  set guioptions-=R
  set guioptions-=b
  set guioptions-=l
  set guioptions-=r
endif


"[PLUGINS]"
call plug#begin()
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tmux-plugins/vim-tmux-focus-events'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'mbbill/undotree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'

call plug#end()

"[COLORSCHEME]"
let base16colorspace=256
colorscheme base16-tomorrow-night
highlight Comment cterm=italic gui=italic

"[TMUXX INTEGRATION]"
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
endif

highlight Normal ctermfg=7 ctermbg=0 guifg=#c5c8c6 guibg=none

hi ActiveWindow guibg=none
hi InactiveWindow guibg=#272727

augroup WindowManagement
  autocmd WinLeave * call Handle_Win_Color()
  autocmd FocusLost * :setlocal statusline=%!lightline#statusline(1)
  autocmd FocusGained * :setlocal statusline=%!lightline#statusline(0)
augroup END

function! Handle_Win_Color()
  setlocal winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
endfunction

"[PLUGIN CONFIG]"


if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1


fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun


"[KEYMAPS]"

let mapleader = " "

tnoremap <C-x> <C-\><C-n>
inoremap <C-c> <esc>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

vnoremap X "_d

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <Leader>\ :so ~/.config/nvim/init.vim<CR>
nnoremap <Leader>[ :vertical resize +5<CR>
nnoremap <Leader>] :vertical resize -5<CR>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>ga :Git fetch --all<CR>
nnoremap <leader>grum :Git rebase upstream/master<CR>
nnoremap <leader>grom :Git rebase origin/master<CR>


nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>ph :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>bs /<C-R>=escape(expand("<cWORD>"), "/")<CR><CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <silent>gr <cmd>lua require'telescope.builtin'.lsp_references{ shorten_path = true }<CR>


nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.diagnostic.show_line_diagnostics()<CR>


vnoremap <leader>p "_dP
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <silent> <leader>ff    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>fjf :%!js-beautify %<CR>

"VIMSPECTOR"

nnoremap <leader>m :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>drs <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dh <Plug>VimspectorToggleBreakpoint
nmap <leader>dch <Plug>VimspectorToggleConditionalBreakpoint



"[AUGROUPS]"


fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun


augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

augroup file_fix
    autocmd!
        autocmd BufWritePre * :call TrimWhitespace()
        autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
augroup END

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

let g:completion_enable_fuzzy_match = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_paren = 1
let g:completion_enable_auto_signature = 1

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ completion#trigger_completion()

"[Lightline]"
let g:lightline = {
  \   'colorscheme': 'Tomorrow_Night',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'readonly', 'filename', 'modified' ]
  \     ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'lspstate', 'gitbranch' ] ]
  \   },
	\   'component': {
	\     'lineinfo': ' %3l:%-2v',
	\   },
  \   'component_function': {
  \     'filename': 'LightlineFilename',
  \     'gitbranch': 'fugitive#head',
  \     'fileformat': 'LightlineFileformat',
  \     'filetype': 'LightlineFiletype',
  \     'fileencoding': 'LightlineFileencoding',
  \     'lspstate': 'LspStatus',
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

function! LightlineFilename()
  return winwidth(0) <= 60 ? '' :
        \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 60 ? &fileencoding : '         '
endfunction

function! LightlineFileformat()
  return winwidth(0) > 60 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 60 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

"[Statusline]"
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction


autocmd BufEnter * lua require'completion'.on_attach()
lua << EOF
require'colorizer'.setup()

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')

lsp_status.register_progress()

local on_attach = function(client)
  lsp_status.on_attach(client)
end

require('telescope').setup{
    defaults = {
        file_ignore_patterns = {'**/node_modules/**'},
        }
}

nvim_lsp.bashls.setup{
    on_attach = on_attach,
}
nvim_lsp.jsonls.setup{
    on_attach = on_attach,
}
nvim_lsp.cssls.setup{
    on_attach = on_attach,
}

nvim_lsp.tsserver.setup{
    on_attach = on_attach,
}
nvim_lsp.rust_analyzer.setup{
    on_attach = on_attach,
}
nvim_lsp.racket_langserver.setup{
    on_attach = on_attach,
}
nvim_lsp.html.setup{
    on_attach = on_attach,
}
nvim_lsp.cmake.setup{
    on_attach = on_attach,
}
nvim_lsp.metals.setup{
}
nvim_lsp.pyls.setup{
    on_attach=on_attach,
    settings = {
        pyls = {
            plugins = {
                pycodestyle = { maxLineLength = 120 },
            }
        }
    }
}

EOF
