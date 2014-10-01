" -- NERDTree settings ---------------------------------------------------------

if has("autocmd")
	" open a NERDTree when vim starts up with no files specified
  autocmd stdinreadpre * let s:std_in=1
  autocmd vimenter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

  " close vim if the only window left open is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif

" toggle NERDTree with <C-N>
nnoremap <silent> <C-N> :NERDTreeToggle<CR>
" find current buffer in NERDTree with <C-F>
nnoremap <silent> <C-F> :NERDTreeFind<CR>

let NERDTreeBookmarksFile=$HOME."/.vim/.NERDTreeBookmarks"
let NERDTreeQuitOnOpen=1
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

set noequalalways " prevents windows size equalization after NERDTree closed
