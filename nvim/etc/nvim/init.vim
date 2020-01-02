set number
set mouse=a

map k gk
map j gj
map <Up> gk
map <Down> gj

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi

nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi

vmap <C-c> "+ya
imap <C-c> "+ya
vmap <C-x> "+c
vmap <C-v> <ESC>"+pa
imap <C-v> <ESC>"+pa

nmap <C-N><C-N> :let [&nu, &rnu] = [!&rnu, &nu+&rnu==1] <CR>

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
"
" .rasi files use css syntax highlighting
au BufReadPost *.rasi set syntax=css

call plug#begin()
	"Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
	Plug 'chrisbra/Colorizer'
	Plug 'junegunn/goyo.vim'
	Plug 'scrooloose/nerdtree'
	Plug 'kovetskiy/sxhkd-vim'
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

 " Output the current syntax group 
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

source $HOME/etc/nvim/statusline.vim

set noshowmode
set noruler
set laststatus=0
set noshowcmd


let s:hidden_all = 1
function! ToggleHiddenAll()
	if s:hidden_all  == 0
		let s:hidden_all = 1
		set noshowmode
		set noruler
		set laststatus=1
		set noshowcmd
	else
		let s:hidden_all = 0
		set showmode
		set ruler
		set laststatus=2
		set showcmd
	endif
endfunction

nnoremap <S-h> :call ToggleHiddenAll()<CR>
nmap <C-s> :NERDTreeToggle<CR>
