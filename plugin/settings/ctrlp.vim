" -- ctrlp.vim settings---------------------------------------------------------

let g:ctrlp_max_files = 0 " unlimited files
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
