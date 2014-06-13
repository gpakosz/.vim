" -- airline settings ----------------------------------------------------------

function! s:ffenc()
  return printf('%s%s%s', StatusLineFileEncoding(), StatusLineUTF8Bomb(), strlen(&ff) > 0 ? '['.&ff.']' : '')
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

call airline#parts#define_function('ffenc', '<SNR>' . s:SID() . '_ffenc')
