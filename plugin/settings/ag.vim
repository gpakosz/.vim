" -- ag settings ---------------------------------------------------------------

cabbrev <expr> ag (getcmdtype() == ':' && getcmdpos() <= 3)? 'Ag' : 'ag'
