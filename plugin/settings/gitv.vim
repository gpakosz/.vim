" -- gitv settings -------------------------------------------------------------

let g:Gitv_WipeAllOnClose = 1

nnoremap <silent> <leader>gv :Gitv --all<cr>
nnoremap <silent> <leader>gV :Gitv! --all<cr>
vnoremap <silent> <leader>gV :Gitv! --all<cr>
