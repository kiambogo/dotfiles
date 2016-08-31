call plug#begin('~/.vim/plugged')

Plug 'derekwyatt/vim-scala'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'edkolev/tmuxline.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ktonga/vim-follow-my-lead'
Plug 'ivalkeen/nerdtree-execute'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'matze/vim-move'

call plug#end()

let mapleader = ","

set number
set clipboard=unnamed
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Display all buffers when only 1 tab is open
let g:airline#extensions#tabline#enabled = 1
let g:move_key_modifier = 'M'

let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Set Vim update time to 250ms instead of 4sec
set updatetime=250
set guioptions=aem

" Custom key bindings
nnoremap <C-n> :bnext!<CR>
nnoremap <C-p> :bprevious!<CR>

nnoremap <silent> <Leader>v :NERDTreeFind<CR>
nnoremap <silent> <Leader>p :CtrlP<CR>
nnoremap <silent> <Leader>b :CtrlPBuffer<CR>
nnoremap <silent> <Leader>g :Ggrep<CR>

map <C-i> :NERDTreeToggle<CR>

" Move line/blocks 
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" :q and :wq close buffer instead of window
cnoreabbrev wq w<bar>bd
cnoreabbrev q bd

" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'

set noswapfile
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/target,*/test-output

color happy_hacking
