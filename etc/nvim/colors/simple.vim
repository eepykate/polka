let g:colors_name='simple'

syntax clear

" spellcheck
hi SpellBad    ctermbg=none   cterm=underline
hi SpellCap    ctermbg=none   cterm=none
hi SpellRare   ctermbg=none   cterm=none

" netrw file browser

hi question      ctermfg=none  " symlink
hi NetrwExe      ctermfg=none
hi directory     ctermfg=none
hi NetrwClassify ctermfg=none

" bars
hi LineNr       ctermfg=8
hi CursorLineNr ctermfg=16
hi StatusLine   ctermfg=15
hi VertSplit    ctermbg=8 ctermfg=0

" selected line/column
hi StatusLineNC ctermfg=15
hi CursorLine   cterm=none

" autocomplete
hi Pmenu        ctermbg=8      ctermfg=15     cterm=none
hi PmenuSel     ctermbg=8      ctermfg=4      cterm=none
hi PmenuSbar    ctermbg=8      ctermfg=8      cterm=none
hi PmenuThumb   ctermbg=8      ctermfg=8      cterm=none
hi WildMenu     ctermbg=none   ctermfg=4      cterm=none

" search
hi Search       ctermfg=16   ctermbg=none  cterm=underline
hi MatchParen   ctermfg=16   ctermbg=none  cterm=underline

" other
hi GitGutterAdd     ctermfg=16
hi GitGutterChange  ctermfg=16
hi GitGutterDelete  ctermfg=17
hi gitcommitSummary ctermfg=15
hi DiffAdd         ctermfg=3
hi DiffChange      ctermfg=2
hi DiffDelete      ctermfg=1
hi Visual       ctermbg=8      ctermfg=15
hi Normal       ctermbg=none   ctermfg=15     cterm=none
hi EndOfBuffer  ctermbg=none   ctermfg=0      cterm=none
hi SignColumn   ctermbg=none
hi WarningMsg   ctermbg=none   ctermfg=11     cterm=none
hi ErrorMsg     ctermfg=1      ctermbg=none
hi error        ctermfg=1      ctermbg=none
hi todo         ctermfg=2      ctermbg=none

" ale
hi ALEWarningSign ctermfg=2
hi ALEWarning     ctermfg=2  cterm=underline
hi AleErrorSign   ctermfg=1
hi AleError       ctermfg=1  cterm=underline

" general lang syntax
hi Comment      ctermfg=7
hi Constant     ctermfg=15
hi String       ctermfg=16
hi Character    ctermfg=1
hi Number       ctermfg=none
hi Boolean      ctermfg=none
hi Float        ctermfg=none
hi Identifier   ctermfg=none
hi Function     ctermfg=none
hi Conditional  ctermfg=none
hi Repeat       ctermfg=15
hi Label        ctermfg=4
hi Operator     ctermfg=none
hi Keyword      ctermfg=none
hi Exception    ctermfg=none
hi Include      ctermfg=none
hi Define       ctermfg=none
hi Macro        ctermfg=none
hi PreCondit    ctermfg=none
hi Type         ctermfg=none
hi StorageClass ctermfg=15
hi PreProc      ctermfg=16
hi Structure    ctermfg=none
hi Special      ctermfg=15
hi SpecialChar  ctermfg=none
hi Underliend   ctermfg=none  cterm=underline
hi Ignore       ctermfg=none
hi Error        ctermfg=none  cterm=bold
hi Todo         ctermfg=none  cterm=bold
hi Statement    ctermfg=none  cterm=bold
hi Delimiter    ctermfg=none
hi Title        ctermfg=none

"
"   lang-specific syntax adjustments
"

" css
hi cssUrl                 ctermfg=none   cterm=italic
hi cssBraces              ctermfg=15
hi cssTagName             ctermfg=none
hi cssImportant           ctermfg=none
hi cssClassName           ctermfg=none
hi cssAttrRegion          ctermfg=none
hi cssIdentifier          ctermfg=none
hi cssDefinition          ctermfg=none
hi cssClassNameDot        ctermfg=none
hi cssFunctionName        ctermfg=none
hi cssPseudoClassId       ctermfg=none
hi cssUnitDecorators      ctermfg=none
hi cssBackgroundProp      ctermfg=none
hi cssUnitDecorators      ctermfg=none
hi cssAttributeSelector   ctermfg=none
hi cssAttributeSelector   ctermfg=none

hi! link shQuote String

" md
hi htmlItalic             ctermfg=none    cterm=italic
hi htmlBold               ctermfg=15      cterm=bold
hi htmlTag                ctermfg=15
hi htmlEndTag             ctermfg=15
hi markdownLinkText       ctermfg=15
hi markdownURL            ctermfg=16
hi markdownCode           ctermfg=15
hi markdownBlockquote     ctermfg=15
hi markdownCodeDelimiter  ctermfg=16
hi markdownHeadingDelimiter ctermfg=15
hi markdownH1             ctermfg=15


" vimscript
hi vimNotation    ctermfg=16

hi xdefaultsLabel ctermfg=16
