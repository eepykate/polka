" Make sure to source this file somewhere at the bottom of your config.
" ====================================================================
" ====================================================================

" Do not show mode under the statusline since the statusline itself changes
" color depending on mode
set noshowmode

set laststatus=2
" ~~~~ Statusline configuration ~~~~
" ':help statusline' is your friend!
hi Sl1 ctermfg=18   cterm=none ctermbg=16
hi Sl2 ctermfg=7    cterm=none ctermbg=none
hi Sl3 ctermfg=8    cterm=NONE ctermbg=NONE
hi Slrese ctermfg=none cterm=none ctermbg=none
function! RedrawMode(mode)
	" Normal mode
	if a:mode == 'n'
		return 'nor'
	" Insert mode
	elseif a:mode == 'i'
		return 'ins'
	elseif a:mode == 'R'
		return 'rep'
	" Visual mode
	elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
		return 'sel'
	" Command mode
	elseif a:mode == 'c'
		return 'cmd'
	" Terminal mode
	elseif a:mode == 't'
		return 'trm'
	endif
	return ''
endfunction
function! SetModifiedSymbol(modified)
	if a:modified == 1
		return '[*]'
	else
		return ''
	endif
endfunction
function! SetFiletype(filetype)
	if a:filetype == ''
		return 'txt'
	else
		return a:filetype
	endif
endfunction

set statusline=%#Sl1#\ %{RedrawMode(mode())}\ 
" Filename
set statusline+=%#Sl2#\ %.20f\ 
" Modified status
set statusline+=%#Sl3#%{SetModifiedSymbol(&modified)}
set statusline+=%#SlRese#
" right side
set statusline+=%=
" ruler
set statusline+=\%#Sl2#\ %l,%c
" filetype
set statusline+=\ %#Sl1#\ %{SetFiletype(&filetype)}\ 
