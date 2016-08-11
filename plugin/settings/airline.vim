" -- airline settings ----------------------------------------------------------

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

function! s:ffenc()
  return printf('%s%s%s', StatusLineFileEncoding(), StatusLineUTF8Bomb(), strlen(&ff) > 0 ? '['.&ff.']' : '')
endfunction

function! s:utf8()
  return '[' . StatusLineUTF8() . ']'
endfunction

call airline#parts#define_function('ffenc', '<SNR>' . s:SID() . '_ffenc')
call airline#parts#define_function('utf8', '<SNR>' . s:SID() . '_utf8')

function! s:init()
let g:airline_section_z = airline#section#create(['[U+%04B]', 'utf8', g:airline_symbols.space, 'windowswap', '%3p%%'.g:airline_symbols.space, 'linenr', ':%3c '])
:AirlineRefresh
endfunction

autocmd VimEnter * call <SID>init()
