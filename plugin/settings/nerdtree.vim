" -- NERDTree settings ---------------------------------------------------------

if has("autocmd")
  autocmd StdinReadPre * let s:std_in=1
  " open a NERDTree when vim starts up with no files specified
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  " open a NERDTree when vim starts up with on opening a directory
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

  " close vim if the only window left open is a NERDTree
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") ) | q | endif

  autocmd BufEnter * if g:NERDTree.IsOpen() | execute 'silent normal R' | endif
endif

function! s:NERDTreeToggleAndRefresh()
  if g:NERDTree.IsOpen()
    NERDTreeClose
  else
    NERDTreeFocus
    exe 'silent normal R'
  endif
endfunction

function! s:NERDTreeFindAndRefresh()
  if !g:NERDTree.IsOpen()
    NERDTreeFind
    exe 'silent normal R'
  endif
endfunction

" toggle NERDTree with <C-N>
nnoremap <silent> <C-N> :call <SID>NERDTreeToggleAndRefresh()<CR>
" find current buffer in NERDTree with <C-F>
nnoremap <silent> <C-F> :call <SID>NERDTreeFindAndRefresh()<CR>

let NERDTreeBookmarksFile=$HOME."/.vim/.NERDTreeBookmarks"
let NERDTreeQuitOnOpen=1
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

set noequalalways " prevents windows size equalization after NERDTree closed
