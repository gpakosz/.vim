" -- ack settings --------------------------------------------------------------

cabbrev <expr> ack (getcmdtype() == ':' && getcmdpos() <= 4)? 'Ack' : 'ack'
