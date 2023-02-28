if exists('b:current_syntax')
  finish
endif

syntax clear
syntax case match
syntax iskeyword @,!,#-',*-:,<-Z,a-z,~,_,^

syntax match pagetreeError "[])}]"

syntax match pagetreeLang "#lang\s\+pollen\%(/ptree\)\?"

syntax match pagetreeLozenge "◊"
      \ contained
      \ containedin=ALLBUT,.*Comment
      \ display

syntax include @pagetreeRacket syntax/racket.vim
unlet b:current_syntax

syntax match pagetreeVariable "◊|\k\+|"hs=s+2,he=e-1
      \ display
syntax cluster pagetreeTop contains=pagetreeVariable

syntax match pagetreeLozengeLiteral /◊"◊"/hs=s+2,he=e-1
      \ display
syntax cluster pagetreeTop add=pagetreeLozengeLiteral

syntax match pagetreeCommand "◊\k\+"hs=s+1
      \ nextgroup=pagetreeRacketArgs,pagetreeTextArgs
syntax region pagetreeRacketArgs start="\["rs=s+1 end="\]"re=e-1
      \ contained
      \ contains=@pagetreeRacket
      \ keepend
      \ nextgroup=pagetreeTextArgs
      \ fold
syntax region pagetreeTextArgs start="{" end="}"
      \ contained
      \ contains=@pagetreeTop
      \ fold
syntax region pagetreeCommand start="◊(" end=")"
      \ transparent
      \ keepend
      \ contains=@pagetreeRacket
      \ fold
syntax cluster pagetreeTop add=pagetreeCommand

syntax match pagetreeComment "◊;.*$"
      \ contains=@pagetreeNotes,@Spell
      \ keepend
syntax region pagetreeComment matchgroup=pagetreeComment start="◊;{" end="}"
      \ contains=pagetreeCommentBrace,@pagetreeNotes,@Spell
      \ extend
      \ fold
syntax region pagetreeCommentBrace start="{" end="}"
      \ contained
      \ contains=pagetreeCommentBrace
      \ transparent
syntax cluster pagetreeTop add=pagetreeComment

syntax keyword pagetreeTodo FIXME TODO XXX contained
syntax match pagetreeNote "\CNOTE:" contained
syntax cluster pagetreeNotes contains=pagetreeTodo,pagetreeNote

highlight def link pagetreeLang PreProc
highlight def link pagetreeLozenge Operator
highlight def link pagetreeVariable Function
highlight def link pagetreeCommand Function
highlight def link pagetreeComment Comment
highlight def link pagetreeNotes Todo
highlight def link pagetreeError Error

let b:current_syntax = 'pagetree'
