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

" Set colour scheme to terminal's colour scheme (~/.config/nvim/colors/term.vim)   " Paste
color term
