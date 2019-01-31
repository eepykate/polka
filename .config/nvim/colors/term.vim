" viking -- vim color scheme

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif

let g:colors_name='term'

set numberwidth=1

hi Normal       ctermbg=NONE   ctermfg=7
hi Cursor       ctermbg=NONE   ctermfg=7
hi Directory    ctermbg=NONE   ctermfg=4
hi ErrorMsg     ctermbg=NONE   ctermfg=1
hi VertSplit    ctermbg=NONE   ctermfg=0    cterm=NONE
hi LineNr       ctermbg=NONE   ctermfg=7
hi SignColumn   ctermbg=NONE   ctermfg=NONE cterm=NONE
hi NonText      ctermbg=NONE   ctermfg=0
hi Pmenu        ctermbg=8      ctermfg=7
hi PmenuSel     ctermbg=8      ctermfg=4
hi PmenuSbar    ctermbg=8      ctermfg=8
hi PmenuThumb   ctermbg=8      ctermfg=8
hi Search       ctermbg=3      ctermfg=8
hi SpellBad     ctermbg=NONE   ctermfg=1    cterm=underline
hi SpellCap     ctermbg=NONE   ctermfg=2    cterm=underline
hi SpellLocal   ctermbg=NONE   ctermfg=10   cterm=underline
hi SpellRare    ctermbg=NONE   ctermbg=3    cterm=underline
hi StatusLine   ctermbg=0      ctermfg=15   cterm=NONE
hi StatusLineNC ctermbg=0      ctermfg=7    cterm=NONE
hi TabLine      ctermbg=0      ctermfg=NONE
hi TabLineSel   ctermbg=0      ctermfg=15
hi TabLineFill  ctermbg=0      ctermfg=NONE
hi Title        ctermbg=NONE   ctermfg=15
hi Visual       ctermbg=0      ctermfg=NONE cterm=reverse
hi WildMenu     ctermbg=NONE   ctermfg=4    cterm=NONE
hi WarningMsg   ctermbg=NONE   ctermfg=11   cterm=NONE
hi DIffAdd      ctermbg=NONE   ctermfg=2
hi DiffDelete   ctermbg=NONE   ctermfg=1
hi DiffChange   ctermbg=NONE   ctermfg=1
hi EndOfBuffer  ctermbg=NONE   ctermfg=0
hi CursorLine   ctermbg=NONE   ctermfg=NONE cterm=NONE
hi CursorLineNr ctermbg=NONE   ctermfg=7    cterm=bold
hi MatchParen   ctermbg=3      ctermfg=0
hi ModeMsg      ctermbg=NONE   ctermfg=5
hi NormalNC     ctermbg=NONE   ctermfg=15   cterm=NONE

" language syntax
hi Comment      ctermbg=NONE   ctermfg=6    ctermbg=NONE cterm=italic
hi Constant     ctermbg=NONE   ctermfg=4    cterm=NONE
hi String       ctermbg=NONE   ctermfg=2    cterm=NONE
hi Character    ctermbg=NONE   ctermfg=9    cterm=NONE
hi Number       ctermbg=NONE   ctermfg=4    cterm=NONE
hi Boolean      ctermbg=NONE   ctermfg=11   cterm=NONE
hi Float        ctermbg=NONE   ctermfg=4    cterm=NONE
hi Identifier   ctermbg=NONE   ctermfg=4    cterm=NONE
hi Function     ctermbg=NONE   ctermfg=3    cterm=NONE
hi Conditional  ctermbg=NONE   ctermfg=2    cterm=NONE
hi Repeat       ctermbg=NONE   ctermfg=1    cterm=NONE
hi Label        ctermbg=NONE   ctermfg=4    cterm=NONE
hi Operator     ctermbg=NONE   ctermfg=1    cterm=NONE
hi Keyword      ctermbg=NONE   ctermfg=9    cterm=NONE
hi Exception    ctermbg=NONE   ctermfg=1    cterm=NONE
hi Include      ctermbg=NONE   ctermfg=2    cterm=NONE
hi Define       ctermbg=NONE   ctermfg=2    cterm=NONE
hi Macro        ctermbg=NONE   ctermfg=1    cterm=NONE
hi PreCondit    ctermbg=NONE   ctermfg=1    cterm=NONE
hi Type         ctermbg=NONE   ctermfg=9    cterm=NONE
hi StorageClass ctermbg=NONE   ctermfg=1    cterm=NONE
hi PreProc      ctermbg=NONE   ctermfg=12   cterm=NONE
hi Structure    ctermbg=NONE   ctermfg=5    cterm=NONE
hi Special      ctermbg=NONE   ctermfg=13   cterm=NONE
hi SpecialChar  ctermbg=NONE   ctermfg=3    cterm=NONE
hi Delimiter    ctermbg=NONE   ctermfg=1    cterm=NONE
hi Underliend   ctermbg=NONE   ctermfg=1    cterm=underline
hi Ignore       ctermbg=NONE   ctermfg=1    cterm=NONE
hi Error        ctermbg=NONE   ctermfg=1    cterm=bold
hi Todo         ctermbg=NONE   ctermfg=3    cterm=bold
