" Line number on the side
set number relativenumber 

" Enable syntax highlighting
syntax on   

" Mouse support
set mouse=a

" Copy
vmap <C-c> "+yi
imap <C-c> "+yi

" Cut
vmap <C-x> "+c

" Paste
vmap <C-v> <ESC>"+pa
imap <C-v> <ESC>"+pa

" Ctrl +n twice in normal mode toggles number sidebar 
nmap <C-N><C-N> :let [&nu, &rnu] = [!&rnu, &nu+&rnu==1] <CR>  

" Use Terminal's colour scheme (Requires that file in ~/.config/nvim/colors (If you're using nvim))
color term

set tabstop=4          " Number of visual spaces per Tab
set softtabstop=4      " Number of spaces in tab when editing
set shiftwidth=4       " Number of spaces to use for autoindent
set expandtab          " Tabs are spaces
set copyindent         " Copy the indentation from the previous line
set autoindent

set incsearch          " Search as characters are typed
set hlsearch           " Highlight matches
set ignorecase         " Ignore case when searching
set smartcase          " Ignore case when only lower case is typed

" Automatic Brace
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i

" .rasi files use css syntax highlighting
au BufReadPost *.rasi set syntax=css       

