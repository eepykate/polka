"
"    ,=,e
"  init.vim
"

set clipboard^=unnamed,unnamedplus

" indentation
set tabstop=2          " Number of visual spaces per Tab
set softtabstop=2      " Number of spaces in tab when editing
set shiftwidth=2       " Number of spaces to use for autoindent
set nocopyindent
set nosmartindent
"set expandtab

" search
set incsearch          " Search as characters are typed
set hlsearch           " Highlight matches
set ignorecase         " Ignore case when searching
set smartcase          " Ignore case when only lower case is typed

" misc
set cursorline         " Highlight the line that the cursor is on
set mouse=a            " Mouse support
set linebreak          " Don't wrap the middle of a word
set fcs=eob:\ 
color simple

"cnoreabbrev rm !del %<CR>:next<CR>

" whitespace at the end of the line
hi!  ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call  clearmatches()

" toggle spellchecker
inoremap <silent> <C-d> <esc>:setlocal spell! spelllang=en<CR>a
nnoremap <silent> <C-d> :setlocal spell! spelllang=en<CR>
set spellcapcheck=

"
"   Plugins
"
call plug#begin()
	Plug 'dense-analysis/ale'
	Plug 'machakann/vim-sandwich'
	Plug 'airblade/vim-gitgutter'
	Plug 'elkowar/kmonad.vim'
call plug#end()
set updatetime=100


" statusline
source $HOME/etc/nvim/statusline.vim
hi bl ctermfg=8
hi gr ctermfg=7
set laststatus=0
set rulerformat=%30(%=%#bl#%l,%c\ \ %#gr#%t%)

" fallback colour scheme for ttys due to using color16 in main one
if $TERM == 'linux'
	colorscheme desert
	set background=dark
	hi cursorLine cterm=none
	hi matchparen cterm=none ctermfg=15 ctermbg=0
endif

let g:ale_sign_error = '▍'
let g:ale_sign_warning = '▍'

let g:gitgutter_sign_added              = '▍'
let g:gitgutter_sign_modified           = '▍'
let g:gitgutter_sign_modified_removed   = '▍'
let g:gitgutter_sign_removed            = '▍'
let g:gitgutter_sign_removed_first_line = '▍'
let g:gitgutter_sign_removed_above_and_below = '▍'


"
"   Keybinds
"

set pastetoggle=<F2>

"nnoremap <silent> <C-w> :Rex<CR>
" There's got to be a more efficient way of doing this, but whatever

noremap Q :prev <CR>

noremap E :next <CR>

" move up/down better on long lines
noremap k gk
noremap j gj
noremap <Up> gk
noremap <Down> gj

"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>
"
"inoremap <Up> <Nop>
"inoremap <Down> <Nop>
"inoremap <Left> <Nop>
"inoremap <Right> <Nop>
"
"vnoremap <Up> <Nop>
"vnoremap <Down> <Nop>
"vnoremap <Left> <Nop>
"vnoremap <Right> <Nop>

" move line
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
"inoremap <A-j> <Esc>:m .+1<CR>==gi
"inoremap <A-k> <Esc>:m .-2<CR>==gi

nnoremap <C-Down> :m .+1<CR>==
nnoremap <C-Up> :m .-2<CR>==
inoremap <C-Down> <Esc>:m .+1<CR>==gi
inoremap <C-Up> <Esc>:m .-2<CR>==gi

inoremap <C-e> <Esc>$a
inoremap <C-a> <Esc>^i
nnoremap <C-e> <Esc>$a

" copy, cut & paste
vnoremap <C-c> "+y
vnoremap <S-y> "+c
vnoremap <C-v> "+p
"nnoremap <p> "+p
inoremap <C-v> <ESC>"+pa

let mapleader = ","
let g:mapleader = ","
nnoremap x "_x
vnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap <leader>d "+d
nnoremap <leader>D "+D
vnoremap <leader>d "+d

nnoremap <leader>d "+d
nnoremap <leader>D "+D
vnoremap <leader>d "+d

inoremap <C-s> <ESC>:w<CR>a
nnoremap <C-s> :w<CR>

" toggle sidebars
nnoremap <silent> <C-n> :let [&nu, &rnu] = [!&rnu, &nu+&rnu==1] <CR>
nnoremap <silent> <C-m> :GitGutterToggle <CR>
nnoremap <silent> <C-b> :ALEToggle <CR>

" Output the current syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap K :vert Man<CR>
