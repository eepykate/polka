let g:colors_name='term'

set numberwidth=1

" spellcheck
hi SpellBad    ctermfg=none ctermbg=none   cterm=underline
hi SpellCap    ctermfg=none ctermbg=none   cterm=underline
hi SpellRare   ctermfg=none ctermbg=none   cterm=underline
hi SpellLocal  ctermfg=none ctermbg=none   cterm=underline

" netrw file browser
hi Question     ctermfg=6
hi netrwExe     ctermfg=3
hi netrwDir     ctermfg=5
hi netrwClassify ctermfg=8

" bars
hi LineNr       ctermfg=8
hi StatusLine   ctermfg=15
hi VertSplit    ctermbg=8 ctermfg=0

" selected line/column
hi StatusLineNC ctermfg=15
hi CursorLineNr ctermfg=7
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
hi gitcommitSummary ctermfg=15
hi DiffAdd         ctermfg=3
hi DiffChange      ctermfg=2
hi DiffDelete      ctermfg=1
hi GitGutterAdd         ctermfg=16
hi GitGutterChange      ctermfg=16
hi GitGutterDelete      ctermfg=17
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
hi Comment      ctermfg=8
hi Constant     ctermfg=15
hi String       ctermfg=16
hi Character    ctermfg=1
hi Number       ctermfg=none
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
hi Type         ctermfg=none
hi StorageClass ctermfg=15
hi PreProc      ctermfg=17
hi Structure    ctermfg=5
hi Special      ctermfg=15
hi SpecialChar  ctermfg=5
hi Underliend   ctermfg=1     cterm=underline
hi Ignore       ctermfg=1
hi Error        ctermfg=1     cterm=bold
hi Todo         ctermfg=3     cterm=bold
hi Statement    ctermfg=none  cterm=bold
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
hi shAlias        ctermfg=15
hi shSetList      ctermfg=15
"hi shQuote        ctermfg=7
hi! link shQuote String
hi shFunction     ctermfg=16
hi shHereDoc      ctermfg=15


" md
hi htmlItalic             ctermfg=none    cterm=italic
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
