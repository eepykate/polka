"
"    ,=,e
"  init.vim
"

" indentation
set tabstop=2          " Number of visual spaces per Tab
set softtabstop=2      " Number of spaces in tab when editing
set shiftwidth=2       " Number of spaces to use for autoindent
set nocopyindent
set nosmartindent

" search
set incsearch          " Search as characters are typed
set hlsearch           " Highlight matches
set ignorecase         " Ignore case when searching
set smartcase          " Ignore case when only lower case is typed

" misc
set cursorline         " Highlight the line that the cursor is on
set mouse=a            " Mouse support
color term


" whitespace at the end of the line
hi!  ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call  clearmatches()



"
"   Plugins
"
call plug#begin()
	Plug 'dense-analysis/ale'
	Plug 'machakann/vim-sandwich'
call plug#end()


" statusline
source $HOME/etc/nvim/statusline.vim
hi bl ctermfg=8
hi gr ctermfg=7
set laststatus=0
set rulerformat=%40(%=%#bl#%l,%c\ \ %#gr#%t%)

" fallback colour scheme for ttys due to using color16 in main one
if $TERM == 'linux'
	colorscheme desert
	set background=dark
	hi cursorLine cterm=none
endif



"
"   Keybinds
"

" There's got to be a more efficient way of doing this, but whatever

" move up/down better on long lines
noremap k gk
noremap j gj
noremap <Up> gk
noremap <Down> gj

" move line
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi

nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi

inoremap <C-e> <Esc>$a
inoremap <C-a> <Esc>^i
nnoremap <C-e> <Esc>$a

" copy, cut & paste
vnoremap <C-c> "+ya
vnoremap <C-x> "+c
vnoremap <C-v> <ESC>"+pa
inoremap <C-v> <ESC>"+pa

inoremap <C-s> <ESC>:w<CR>a
nnoremap <C-s> :w<CR>

" toggle numbers sidebar
nnoremap <C-N><C-N> :let [&nu, &rnu] = [!&rnu, &nu+&rnu==1] <CR>

" Output the current syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
