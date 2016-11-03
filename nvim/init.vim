let mapleader = ","
let g:mapleader = ","

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/functions.vim


""""""""""""""""""""""""""""""
"          Styling
""""""""""""""""""""""""""""""
syntax enable
set background=dark
colorscheme gruvbox

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:airline_theme='gruvbox'
let g:bufferline_echo = 0

if has("termguicolors")
    set termguicolors
endif



""""""""""""""""""""""""""""""
"            Sets
""""""""""""""""""""""""""""""
set clipboard+=unnamed
set history=500
set number
set autoread  " Set to auto read when a file is changed from the outside
set so=7 " Set 7 lines to the cursor - when moving vertically using j/k
set ruler
set cmdheight=1 " Height of the command bar
set hlsearch
set incsearch
set lazyredraw " Don't redraw while executing macros
set magic " For regular expressions turn magic on
set showmatch " Show matching brackets when text indicator is over them
set mat=2 " How many tenths of a second to blink when matching brackets
set hid " A buffer becomes hidden when it is abandoned
set backspace=eol,start,indent " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases
set wildmenu " Turn on the WiLd menu
set ffs=unix,dos,mac " Use Unix as the standard file type
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set lbr " Enable linebreak
set tw=500 " Linebreak on 500 characters
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set number
set foldcolumn=1 " Add a bit extra margin to the left

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/target,*/test-output

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Display all buffers when only 1 tab is open
let g:airline#extensions#tabline#enabled = 1


""""""""""""""""""""""""""""""
"          Mappings
""""""""""""""""""""""""""""""
map <space> /
map <c-space> ?
map <leader>z :Goyo<cr>
map <silent> <leader><cr> :noh<cr>
map <leader>q :e ~/buffer<cr>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CRe

" Fzf selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Replace selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

cnoreabbrev wq w<bar>bd

" Enable filetype plugins
filetype plugin on
filetype indent on

" Insert quick parens/brackets/etc
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

" Wrap selection in parens/brackets/etc
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Spell Checking
map <leader>ss :setlocal spell!<cr>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

nnoremap <C-n> :bnext!<CR>
nnoremap <C-p> :bprevious!<CR>

nmap <leader>w :w!<cr>
nmap <leader>wq :w!<bar>:bdelete!<cr>
nmap <leader>q :bdelete!<cr>

map <leader>g :Ag
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

map <leader>cd :cd %:p:h<cr>:pwd<cr>

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

autocmd BufWritePre * StripWhitespace

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif


" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>
