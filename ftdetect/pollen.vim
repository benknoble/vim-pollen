function! PollenDetectFiletype(filename) abort
  " TODO: support "_" escaping convention
  " … https://docs.racket-lang.org/pollen/File_formats.html#%28part._.Escaping_output-file_extensions_within_source-file_names%29
  let without_pollen_ext = fnamemodify(a:filename, ':r')
  if empty(fnamemodify(without_pollen_ext, ':e'))
    " not a pollen file
    return
  endif

  " reset did_filetype() so that setf will work (see doautocmd below)
  if did_filetype()
    " HACK: new file resets did_filetype()
    new | bdelete
  endif

  " HACK: ignore conf (#lang line triggers it sometimes)
  " :view +/setf\ FALLBACK\ conf $VIMRUNTIME/filetype.vim
  let ignore_suffix = (empty(g:ft_ignore_pat) ? '' : '\|') . '\V' . escape(without_pollen_ext, '\')
  let g:ft_ignore_pat = g:ft_ignore_pat . ignore_suffix
  " original filetype detection
  " taken from https://vi.stackexchange.com/q/12436/10604
  execute 'doautocmd filetypedetect BufRead' fnameescape(without_pollen_ext)
  let g:ft_ignore_pat = strpart(g:ft_ignore_pat, 0, strlen(ignore_suffix))

  " add pollen at end, taking care to only add it once
  let &l:filetype = substitute(&filetype, '\C\.\<pollen\>', '', 'g') . '.pollen'
endfunction

" TODO: support "#lang" overriding
" … https://docs.racket-lang.org/pollen/File_formats.html#%28part._.Source_formats%29

autocmd BufNewFile,BufRead *.*.pp call PollenDetectFiletype(expand("<afile>"))
autocmd BufNewFile,BufRead *.*.pmd set filetype=markdown.pollen
autocmd BufNewFile,BufRead *.*.pm set filetype=pollen
autocmd BufNewFile,BufRead *.ptree set filetype=pagetree
" technically, the null extension is for templates and for static files, but
" let's add pollen anyway
autocmd BufNewFile,BufRead *.*.p call PollenDetectFiletype(expand("<afile>"))
