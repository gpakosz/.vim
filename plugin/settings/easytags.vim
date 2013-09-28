" -- easytags settings ---------------------------------------------------------

let g:easytags_suppress_ctags_warning = 1

nnoremap <leader>ht let b:easytags_auto_highlight=!b:easytags_auto_highlight<CR>

let s:vimdir=$HOME . "/.vim"
if exists("*mkdir")
  if !isdirectory(s:vimdir)
    call mkdir(s:vimdir, "p")
  endif
  let g:easytags_by_filetype = s:vimdir . "/tags"
  if !isdirectory(g:easytags_by_filetype)
    call mkdir(g:easytags_by_filetype, "p")
  endif
else
  let g:easytags_file = s:vimdir . "/tags"
endif

let g:easytags_include_members = 1
highlight link cMember Special
