let current_compiler = 'pollen'

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=raco\ pollen\ render
