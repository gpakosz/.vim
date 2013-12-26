" -- ctrlp.vim settings---------------------------------------------------------

let g:ctrlp_max_files = 0 " unlimited files
if executable('ag')
  let g:ctrlp_user_command = ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', 'ag --nocolor -g "" %s']
elseif executable('ack')
  let g:ctrlp_user_command = ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', 'ack --nocolor -g "" %s']
else
  let g:ctrlp_user_command = ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
end
