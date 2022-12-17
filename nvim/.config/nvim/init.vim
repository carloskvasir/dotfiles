" ----------------------------------------------------------
"       Plug Scripts autoinstall & load
" ----------------------------------------------------------
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ----------------------------------------------------------
"       THIS IS WHERE YOUR PLUGINS WILL COME
" ----------------------------------------------------------
call plug#begin('~/.config/nvim/plugins')

Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline' "Command line
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make' }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'unblevable/quick-scope'
Plug 'tomlion/vim-solidity', { 'for': 'solidity' }

call plug#end()

" ----------------------------------------------------------
"       CONFIGS
" ----------------------------------------------------------
set nu              "Show line number
set relativenumber  "Show relative numbers
set background=dark
colorscheme gruvbox
syntax on
set autoindent
"set textwidth=80

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set visualbell
set title
set sm              "substituição magica ???
set incsearch
set nobackup        "This is recommend per coc
set nowritebackup   "This is recommend per coc
set autoindent      "Whats is this
set smartindent     "Makes indenting smart

set clipboard+=unnamedplus "Configure clipboard

" ----------------------------------------------------------
"       TRUECOLOR ENABLE
" ----------------------------------------------------------
if has ("termguicolors")
    set termguicolors
endif

" ----------------------------------------------------------
"       STATUS BAR Vim-Airline
" ----------------------------------------------------------
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" ---------------------------------------------------------
"       Configs to Use buffers in tabs
" ---------------------------------------------------------
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>
nmap <leader>L :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>x :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" ---------------------------------------------------------
"       Configure QuickScope
" ---------------------------------------------------------

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

lua require('carloskvasir')
source ~/.config/nvim/biddings.vim
