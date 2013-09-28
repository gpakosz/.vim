" -- fugitive settings ---------------------------------------------------------

cabbrev <expr> git (getcmdtype() == ':' && getcmdpos() <= 4) ? 'Git' : 'git'

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gl :Glog<CR>

if has("statusline")
  let &statusline=substitute(&statusline, '\(%{StatusLineCWD()}\)', '\1%#SpecialChar#%{fugitive#statusline()}%*', '')
endif
