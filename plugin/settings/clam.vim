" -- clam settings -------------------------------------------------------------

cabbrev <expr> clam (getcmdtype() == ':' && getcmdpos() <= 5) ? 'Clam' : 'clam'

nnoremap ! :Clam<Space>
vnoremap ! :ClamVisual<space>
