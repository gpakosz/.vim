" -- easytags settings ---------------------------------------------------------

let g:easytags_async = 1
let g:easytags_suppress_ctags_warning = 1

let g:easytags_auto_highlight = 0
nnoremap <silent> <leader>ht :call <SID>toggle_easytags_auto_highlight()<CR>
function! s:toggle_easytags_auto_highlight()
  let b:easytags_auto_highlight = !get(b:, 'easytags_auto_highlight', g:easytags_auto_highlight)

  if b:easytags_auto_highlight
    call xolox#easytags#highlight()
    echo 'easytags auto highlight on'
  else
    syntax enable
    redraw
    echo 'easytags auto highlight off'
  endif
endfunction

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
