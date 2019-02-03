set number relativenumber
" Enable syntax highlighting
syntax on
":set mouse-=a

set mouse=a
"vnoremap <C-c> "*y
"vnoremap <C-v> "*p
"set go+=a
"set clipboard=unnamed
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> <ESC>"+p
imap <C-v> <ESC>"+pa

set ttymouse=sgr
