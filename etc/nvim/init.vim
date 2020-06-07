"
"  ,=,e
"


"
"   Keybinds
"

" move up/down better on long lines
map k gk
map j gj
map <Up> gk
map <Down> gj

" move line
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi

nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi

" copy, cut & paste
vmap <C-c> "+ya
vmap <C-x> "+c
vmap <C-v> <ESC>"+pa
imap <C-v> <ESC>"+pa

imap <C-s> <ESC>:w<CR>a
nmap <C-s> :w<CR>

" toggle numbers sidebar
nmap <C-N><C-N> :let [&nu, &rnu] = [!&rnu, &nu+&rnu==1] <CR>




"
"   Settings
"

" indentation
set tabstop=2          " Number of visual spaces per Tab
set softtabstop=2      " Number of spaces in tab when editing
set shiftwidth=2       " Number of spaces to use for autoindent
set copyindent         " Copy the indentation from the previous line

" search
set incsearch          " Search as characters are typed
set hlsearch           " Highlight matches
set ignorecase         " Ignore case when searching
set smartcase          " Ignore case when only lower case is typed

" misc
"set number             " Line numbers
set cursorline         " Highlight the line that the cursor is on
set mouse=a            " Mouse support
color term




"
"   Plugins
"
call plug#begin()
	" Plug 'vim-syntastic/syntastic'
	Plug 'dense-analysis/ale'
	" Plug 'maxboisvert/vim-simple-complete'
call plug#end()




"
"   Misc
"

" whitespace at the end of the line
hi   ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call  clearmatches()

 " Output the current syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" statusline
source $HOME/etc/nvim/statusline.vim

" Hide UI Elements
let s:hidden_all = 0
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

"call ToggleHiddenAll()

nnoremap <S-h> :call ToggleHiddenAll()<CR>:<BS>


"function! Tabs()
"  let asd = system("echo $(( RANDOM % 2 ))")
"	if asd
"		" tabs
"		normal! a	
"	else
"		" spaces
"		normal! a        
"	endif
"endfunction
"inoremap <Tab> <Esc>:call Tabs()<CR>a
