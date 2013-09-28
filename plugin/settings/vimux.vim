" -- vimux settings ------------------------------------------------------------

let VimuxResetSequence = "q C-u C-l"

" prompt for a command to run
nnoremap <silent> <leader>rp :VimuxPromptCommand<CR>
 
" run last command executed by VimuxRunCommand
nnoremap <silent> <leader>rl :VimuxRunLastCommand<CR>

" inspect runner pane
nnoremap <silent> <leader>ri :VimuxInspectRunner<CR>

" close all other tmux panes in current window
nnoremap <silent> <leader>rx :VimuxClosePanes<CR>

" close vim tmux runner opened by VimuxRunCommand
nnoremap <silent> <leader>rq :VimuxCloseRunner<CR>

" interrupt any command running in the runner pane
nnoremap <silent> <leader>rs :VimuxInterruptRunner<CR>
