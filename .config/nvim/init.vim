" Line number on the side
set number relativenumber 

"cmap ft filetype detect

"map h <insert>
"map i <Up>
"map j <Left>
"map k <Down>

" Enable syntax highlighting
syntax on

" Mouse support
set mouse=a

map k gk
map j gj

map <Up> gk
map <Down> gj

" Copy
vmap <C-c> "+yi
imap <C-c> "+yi

" Cut
vmap <C-x> "+c

" Paste
vmap <C-v> <ESC>"+pi
imap <C-v> <ESC>"+pi

" Ctrl +n twice in normal mode toggles number sidebar
nmap <C-N><C-N> :let [&nu, &rnu] = [!&rnu, &nu+&rnu==1] <CR>

" Use Terminal's colour scheme (Requires that file in ~/.config/nvim/colors (If you're using nvim))
color term

set tabstop=2          " Number of visual spaces per Tab
set softtabstop=2      " Number of spaces in tab when editing
set shiftwidth=2       " Number of spaces to use for autoindent
"set expandtab          " Tabs are spaces
set copyindent         " Copy the indentation from the previous line
"set autoindent

set incsearch          " Search as characters are typed
set hlsearch           " Highlight matches
set ignorecase         " Ignore case when searching
set smartcase          " Ignore case when only lower case is typed

" Automatic Brace
"inoremap ( ()<Esc>i
"inoremap [ []<Esc>i
"inoremap { {}<Esc>i
"inoremap " ""<Esc>i
"inoremap ' ''<Esc>i

" .rasi files use css syntax highlighting
au BufReadPost *.rasi set syntax=css


call plug#begin()
	Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
	Plug 'chrisbra/Colorizer'
	Plug 'junegunn/goyo.vim'
call plug#end()

set cursorline
"set cursorcolumn

" :let g:colorizer_auto_color = 1

:let g:colorizer_auto_filetype='css,html'
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

