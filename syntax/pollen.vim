let is_overlay = len(split(&l:syntax, '\.')) > 1

if !is_overlay && exists('b:current_syntax')
  finish
else
  syntax clear
endif

syntax case match
syntax iskeyword @,!,#-',*-:,<-Z,a-z,~,_,^

syntax match pollenLang "#lang\s\+pollen\%(/\%(pre\|markup\|markdown\)\)\?"

syntax match pollenLozenge "◊"
      \ contained
      \ containedin=ALLBUT,.*Comment
      \ display

syntax include @pollenRacket syntax/racket.vim
unlet b:current_syntax

" TODO: support various quotes, escapes, etc.
" https://docs.racket-lang.org/scribble/reader.html#%28part._.The_.Command_.Part%29
" confirm that pollen supports each one, even though they aren't strictly
" documented.
syntax match pollenCommand "◊"
      \ nextgroup=racketStruc
syntax match pollenCommand "◊\k\+"hs=s+1
      \ nextgroup=pollenRacketArgs,pollenTextArgs
syntax region pollenRacketArgs start="\["rs=s+1 end="\]"re=e-1
      \ contained
      \ contains=racketStruc
      \ nextgroup=pollenTextArgs
      \ fold
syntax region pollenTextArgs start="{" end="}"
      \ contained
      \ contains=@pollenTop
      \ fold
syntax cluster pollenTop add=pollenCommand

syntax match pollenVariable "◊|\k\+|"hs=s+2,he=e-1
      \ display
syntax cluster pollenTop contains=pollenVariable

syntax match pollenLozengeLiteral /◊"◊"/hs=s+2,he=e-1
      \ display
syntax cluster pollenTop add=pollenLozengeLiteral

syntax match pollenComment "◊;.*$"
      \ contains=@pollenNotes,@Spell
      \ keepend
syntax region pollenComment matchgroup=pollenComment start="◊;{" end="}"
      \ contains=pollenCommentBrace,@pollenNotes,@Spell
      \ extend
      \ fold
syntax region pollenCommentBrace start="{" end="}"
      \ contained
      \ contains=pollenCommentBrace
      \ transparent
syntax cluster pollenTop add=pollenComment

syntax keyword pollenTodo FIXME TODO XXX contained
syntax match pollenNote "\CNOTE:" contained
syntax cluster pollenNotes contains=pollenTodo,pollenNote

highlight def link pollenLang PreProc
highlight def link pollenLozenge Operator
highlight def link pollenVariable Function
highlight def link pollenCommand Function
highlight def link pollenComment Comment
highlight def link pollenNotes Todo

let b:current_syntax = 'pollen'
