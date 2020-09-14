let g:colors_name='term'

set numberwidth=1

" netrw file browser
hi Question     ctermfg=6
hi netrwExe     ctermfg=3
hi netrwDir     ctermfg=5
hi netrwClassify ctermfg=8

" bars
hi LineNr       ctermfg=8
hi StatusLine   ctermfg=15

" selected line/column
hi StatusLineNC ctermfg=15
hi CursorLineNr ctermfg=7
hi CursorLine   cterm=NONE

" autocomplete
hi Pmenu        ctermbg=8      ctermfg=15     cterm=NONE
hi PmenuSel     ctermbg=8      ctermfg=4      cterm=NONE
hi PmenuSbar    ctermbg=8      ctermfg=8      cterm=NONE
hi PmenuThumb   ctermbg=8      ctermfg=8      cterm=NONE
hi WildMenu     ctermbg=NONE   ctermfg=4      cterm=NONE

" search
hi Search       ctermfg=16   ctermbg=NONE  cterm=underline
hi MatchParen   ctermfg=16   ctermbg=NONE  cterm=underline

" other
hi DiffAdd         ctermfg=3
hi DiffChange      ctermfg=2
hi DiffDelete      ctermfg=1
hi GitGutterAdd         ctermfg=16
hi GitGutterChange      ctermfg=16
hi GitGutterDelete      ctermfg=17
hi Visual       ctermbg=8      ctermfg=15
hi Normal       ctermbg=NONE   ctermfg=15     cterm=NONE
hi EndOfBuffer  ctermbg=NONE   ctermfg=0      cterm=NONE
hi SignColumn   ctermbg=NONE
hi WarningMsg   ctermbg=NONE   ctermfg=11     cterm=NONE
hi SpellBad     ctermfg=1      ctermbg=NONE   cterm=underline
hi SpellCap     ctermfg=2      ctermbg=NONE   cterm=underline
hi SpellRare    ctermfg=2      ctermbg=NONE   cterm=underline
hi SpellLocal   ctermfg=10     ctermbg=NONE   cterm=underline
hi ErrorMsg     ctermfg=1      ctermbg=NONE
hi error        ctermfg=1      ctermbg=NONE
hi todo         ctermfg=2      ctermbg=NONE

" ale
hi ALEWarningSign ctermfg=2
hi ALEWarning     ctermfg=2  cterm=underline
hi AleErrorSign   ctermfg=1
hi AleError       ctermfg=1  cterm=underline

" general lang syntax
hi Comment      ctermfg=8
hi Constant     ctermfg=15
hi String       ctermfg=16
hi Character    ctermfg=1
hi Number       ctermfg=NONE
hi Boolean      ctermfg=12
hi Float        ctermfg=4
hi Identifier   ctermfg=7
hi Function     ctermfg=3
hi Conditional  ctermfg=2
hi Repeat       ctermfg=15
hi Label        ctermfg=4
hi Operator     ctermfg=16
hi Keyword      ctermfg=1
hi Exception    ctermfg=1
hi Include      ctermfg=2
hi Define       ctermfg=2
hi Macro        ctermfg=1
hi PreCondit    ctermfg=1
hi Type         ctermfg=NONE
hi StorageClass ctermfg=15
hi PreProc      ctermfg=17
hi Structure    ctermfg=5
hi Special      ctermfg=15
hi SpecialChar  ctermfg=5
hi Underliend   ctermfg=1     cterm=underline
hi Ignore       ctermfg=1
hi Error        ctermfg=1     cterm=bold
hi Todo         ctermfg=3     cterm=bold
hi Statement    ctermfg=NONE  cterm=bold
hi Delimiter    ctermfg=16
hi Title        ctermfg=4

"
"   lang-specific syntax adjustments
"

" css
hi cssUrl                 ctermfg=1      cterm=italic
hi cssBraces              ctermfg=15
hi cssTagName             ctermfg=16
hi cssImportant           ctermfg=17
hi cssClassName           ctermfg=3
hi cssAttrRegion          ctermfg=16
hi cssIdentifier          ctermfg=4
hi cssDefinition          ctermfg=16
hi cssClassNameDot        ctermfg=3
hi cssFunctionName        ctermfg=16
hi cssPseudoClassId       ctermfg=16
hi cssUnitDecorators      ctermfg=16
hi cssBackgroundProp      ctermfg=15
hi cssUnitDecorators      ctermfg=none
hi cssAttributeSelector   ctermfg=3
hi cssAttributeSelector   ctermfg=3


" sh
hi shConditional  ctermfg=15
hi shDerefSimple  ctermfg=17
hi shVariable     ctermfg=15
hi shStatement    ctermfg=15
"hi shQuote        ctermfg=7
hi! link shQuote String
hi shFunction     ctermfg=16
hi shHereDoc      ctermfg=15


" md
hi htmlItalic             ctermfg=NONE    cterm=italic
hi htmlBold               ctermfg=15      cterm=bold
hi htmlTag                ctermfg=15
hi htmlEndTag             ctermfg=15
hi markdownLinkText       ctermfg=15
hi markdownURL            ctermfg=16
hi markdownCode           ctermfg=15
hi markdownBlockquote     ctermfg=15
hi markdownCodeDelimiter  ctermfg=17
hi markdownHeadingDelimiter ctermfg=15
hi markdownH1             ctermfg=15


" vimscript
hi vimNotation    ctermfg=7


hi xdefaultsLabel ctermfg=16
