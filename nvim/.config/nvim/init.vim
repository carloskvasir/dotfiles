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
call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
Plug 'elixir-editors/vim-elixir',{'for': 'elixir'}
"Plug 'kdheepak/lazygit.nvim'
Plug 'tpope/vim-surround'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'voldikss/vim-floaterm'
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-gitgutter'   "Add gutter whit git status
Plug 'luochen1990/rainbow'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'unblevable/quick-scope'
Plug 'fatih/vim-go'
Plug 'tpope/vim-rails'
Plug 'eslint/eslint'
Plug 'sgur/vim-editorconfig'
call plug#end()

" ----------------------------------------------------------
"       TRUECOLOR ENABLE
" ----------------------------------------------------------
if has ("termguicolors")
    set termguicolors
endif

" ----------------------------------------------------------
"       CONFIGS
" ----------------------------------------------------------
set nu              "Mostra número de linhas
set relativenumber  "Mostra números relativos
set background=dark
colorscheme dracula
syntax on
set autoindent
set textwidth=80

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
"       STATUS BAR Vim-Airline
" ----------------------------------------------------------
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='dracula'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" ----------------------------------------------------------
"       COC config
" ----------------------------------------------------------
let g:coc_global_extensions = [
  \ 'coc-diagnostic',
  \ 'coc-elixir',
  \ 'coc-emmet',
  \ 'coc-eslint',
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-prettier',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-tsserver'
  \ ]
let g:python_host_prog = "$HOME/.asdf/shims/python2"
let g:python3_host_prog = "$HOME/.asdf/shims/python3"

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
"       Config coc completion
" ---------------------------------------------------------
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" use <Enter> for trigger completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Jump to definition config
nmap <silent> gd <Plug>(coc-definition)

" ---------------------------------------------------------
"       Config NerdTree
" ---------------------------------------------------------
" NerdTree open default
autocmd StdinReadPre * let s:std_in=1

" When open file close nerdtree
let NERDTreeQuitOnOpen = 1

" Prettier NerdTree
"let NERDTreeMinimalUI = 1
"let NERDTreeDirArrows = 1

"--- Disable perl ---
:let g:loaded_perl_provider = 0
source $HOME/.config/nvim/keys.vim " keys biding
let NERDTreeIgnore=['\.git$', '\.idea$', '\.vscode$', '\.history$']

