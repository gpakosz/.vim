" -- YankRing settings ---------------------------------------------------------


let s:vimdir=$HOME . "/.vim"
if exists("*mkdir")
  if !isdirectory(s:vimdir)
    call mkdir(s:vimdir, "p")
  endif
  let g:yankring_history_dir=s:vimdir . "/yankring"
  if !isdirectory(g:yankring_history_dir)
    call mkdir(g:yankring_history_dir, "p")
  endif
else
  let g:yankring_history_dir = s:vimdir . "/yankring"
endif

let g:yankring_replace_n_pkey=''
let g:yankring_replace_n_nkey=''

:nnoremap <silent> <C-Y> :YRShow<CR>
