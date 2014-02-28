" -- bootstrap -----------------------------------------------------------------

set encoding=utf-8  " set vim encoding to UTF-8
set nocompatible    " the future is now, use vim defaults instead of vi ones
set nomodeline      " disable mode lines (security measure)
set history=1000    " boost commands and search patterns history
set undolevels=1000 " boost undo levels

if exists("+shellslash")
  set shellslash    " expand filenames with forward slash
endif

set timeoutlen=500      " time in milliseconds for a key sequence to complete
let mapleader=","       " change leader key to ,
let maplocalleader=","  " change local leader key to ,

" <leader>ev edits .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" <leader>sv sources .vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>:runtime! plugin/settings/*<CR>:redraw<CR>:echo $MYVIMRC 'reloaded'<CR>


" -- backup and swap files -----------------------------------------------------

set backup      " enable backup files
set writebackup " enable backup files
set swapfile    " enable swap files (useful when loading huge files)

let s:vimdir=$HOME . "/.vim"
let &backupdir=s:vimdir . "/backup"  " backups location
let &directory=s:vimdir . "/tmp"     " swap location

if exists("*mkdir")
  if !isdirectory(s:vimdir)
    call mkdir(s:vimdir, "p")
  endif
  if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
  endif
  if !isdirectory(&directory)
    call mkdir(&directory, "p")
  endif
endif

set backupskip+=*.tmp " skip backup for *.tmp

if has("persistent_undo")
  let &undodir=&backupdir
  set undofile  " enable persistent undo
endif

let &viminfo=&viminfo . ",n" . s:vimdir . "/.viminfo" " viminfo location


" -- file type detection -------------------------------------------------------

filetype on         " /!\ doesn't play well with compatible mode
filetype plugin on  " trigger file type specific plugins
filetype indent on  " indent based on file type syntax


" -- command mode --------------------------------------------------------------

set wildmenu                    " enable tab completion menu
set wildmode=longest:full,full  " complete till longest common string, then full
set wildignore+=.git            " ignore the .git directory
set wildignore+=*.DS_Store      " ignore Mac finder/spotlight crap
if exists ("&wildignorecase")
  set wildignorecase
endif

" sudo then write
cabbrev w!! w !sudo tee % >/dev/null

" CTRL+A moves to start of line in command mode
cnoremap <C-a> <home>
" CTRL+E moves to end of line in command mode
cnoremap <C-e> <end>

" CTRL+C closes the command window
if has("autocmd")
  augroup command
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> <silent> <C-c> <ESC>:q<CR>
  augroup END
endif

" -- display -------------------------------------------------------------------

set title       " change the terminal title
set lazyredraw  " do not redraw when executing macros
set report=0    " always report changes
set cursorline  " highlight current line

if has("autocmd")
  augroup vim
    autocmd!
    autocmd filetype vim set textwidth=80
  augroup END
  augroup windows
    autocmd!
    autocmd VimResized * :wincmd = " resize splits when the window is resized
  augroup END
endif

if has("gui_running")
  set cursorcolumn  " highlight current column
endif

if exists("+relativenumber")
  if v:version >= 400
    set number
  endif
  set relativenumber  " show relative line numbers
  set numberwidth=3   " narrow number column
  " cycles between relative / absolute / no numbering
  if v:version >= 400
    function! RelativeNumberToggle()
      if (&number == 1 && &relativenumber == 1)
        set nonumber
        set relativenumber relativenumber?
      elseif (&number == 0 && &relativenumber == 1)
        set norelativenumber
        set number number?
      elseif (&number == 1 && &relativenumber == 0)
        set norelativenumber
        set nonumber number?
      else
        set number
        set relativenumber relativenumber?
      endif
    endfunc
  else
    function! RelativeNumberToggle()
      if (&relativenumber == 1)
        set number number?
      elseif (&number == 1)
        set nonumber number?
      else
        set relativenumber relativenumber?
      endif
    endfunc
  endif
  nnoremap <silent> <leader>n :call RelativeNumberToggle()<CR>
else                  " fallback
  set number          " show line numbers
  " inverts numbering
  nnoremap <silent> <leader>n :set number! number?<CR>
endif

set nolist                            " hide unprintable characters
if has("multi_byte")                  " if multi_byte is available,
  set listchars=eol:¬,tab:▸\ ,trail:⌴ " use pretty Unicode unprintable symbols
else                                  " otherwise,
  set listchars=eol:$,tab:>\ ,trail:. " use ASCII characters
endif

" temporarily disable unprintable characters when entering insert mode
if has("autocmd")
  augroup list
    autocmd!
    autocmd InsertEnter * let g:restorelist=&list | :set nolist
    autocmd InsertLeave * let &list=g:restorelist
  augroup END
endif

" inverts display of unprintable characters
nnoremap <silent> <leader>l :set list! list?<CR>

set noerrorbells      " shut up
set visualbell t_vb=  " use visual bell instead of error bell
set mousehide         " hide mouse pointer when typing

if exists("+showtabline")
  set showtabline=1 " only if there are at least two tabs (default)
endif

if has("statusline")

  function! StatusLineUTF8()
    try
      let p = getpos('.')
      redir => utf8seq
      sil normal! g8
      redir End
      call setpos('.', p)
      return substitute(matchstr(utf8seq, '\x\+ .*\x'), '\<\x\x', '0x\U&', 'g')
    catch
      return '?'
    endtry
  endfunction

  function! StatusLineFileEncoding()
    return has("multi_byte") && strlen(&fenc) ? &fenc : ''
  endfunction

  function! StatusLineUTF8Bomb()
    return has("multi_byte") && &fenc == 'utf-8' && &bomb?'+bomb' : ''
  endfunction

  function! StatusLineCWD()
    let l:pwd = exists('$PWD') ? $PWD : getcwd()
    return substitute(fnamemodify(l:pwd, ':~'), '\(\~\?/[^/]*/\).*\(/.\{20\}\)', '\1...\2', '')
  endfunction

  set laststatus=2  " always show a status line
  " set exact status line format
  set statusline=
  set statusline+=%#Number#
  set statusline+=❐\ %02n                        " buffer number
  set statusline+=\ \|\                          " separator
  set statusline+=%*
  set statusline+=%#Identifier#
  set statusline+=%f                             " file path relative to CWD
  set statusline+=%*
  set statusline+=%#Special#
  set statusline+=%m                             " modified flag
  set statusline+=%#Statement#
  set statusline+=%r                             " readonly flag
  set statusline+=%h                             " help buffer flag
  set statusline+=%w                             " preview window flag
  set statusline+=%#Type#
  set statusline+=[%{&ff}]                       " file format
  set statusline+=[
  set statusline+=%{StatusLineFileEncoding()}    " file encoding
  set statusline+=%#Error#
  set statusline+=%{StatusLineUTF8Bomb()}        " UTF-8 bomb alert
  set statusline+=%#Type#
  set statusline+=]
  set statusline+=%y                             " type of file
  set statusline+=\ \|\                          " separator
  set statusline+=%*
  set statusline+=%#Directory#
  set statusline+=%{StatusLineCWD()}             " current working directory
  set statusline+=\                              " separator
  set statusline+=%*
  set statusline+=%=                             " left / right items separator
  set statusline+=%#Comment#
  set statusline+=%{v:register}                  " current register in effect
  set statusline+=\                              " separator
  set statusline+=%#Statement#
  set statusline+=[U+\%04B]                      " Unicode code point
  set statusline+=[%{StatusLineUTF8()}]          " UTF8 sequence
  set statusline+=\ \|\                          " separator
  set statusline+=%#Comment#
  set statusline+=line\ %5l/%L\                  " line number / number of lines
  set statusline+=●\ %02p%%,\                    " percentage through file
  set statusline+=col\ %3v                       " column number
endif

set showcmd     " show partial command line (default)
set cmdheight=1 " height of the command line

set shortmess=astT  " abbreviate messages
set shortmess+=I    " disable the welcome screen

if (&t_Co > 2 || has("gui_running")) && has("syntax")
   syntax on  " turn syntax highlighting on, when terminal has colors or in GUI
endif

if has("gui_running") " GUI mode
  set guioptions-=T   " remove useless toolbar
  set guioptions+=c   " prefer console dialogs to popups
endif

" ease reading in GUI mode by inserting space between lines
set linespace=2

if has("folding")
  set foldenable        " enable folding
  set foldmethod=syntax " fold based on syntax highlighting
  set foldlevelstart=99 " start editing with all folds open

  " toggle folds
  nnoremap <Space> za
  vnoremap <Space> za

  set foldtext=FoldText()
  function! FoldText()
    let l:lpadding = &fdc
    redir => l:signs
      execute 'silent sign place buffer='.bufnr('%')
    redir End
    let l:lpadding += l:signs =~ 'id=' ? 2 : 0

    if exists("+relativenumber")
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      elseif (&relativenumber)
        let l:lpadding += max([&numberwidth, strlen(v:foldstart) + strlen(v:foldstart - line('w0')), strlen(v:foldstart) + strlen(line('w$') - v:foldstart)]) + 1
      endif
    else
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      endif
    endif

    " expand tabs
    let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
    let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

    let l:info = ' (' . (v:foldend - v:foldstart) . ')'
    let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
    let l:width = winwidth(0) - l:lpadding - l:infolen

    let l:separator = ' … '
    let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
    let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
    let l:text = l:start . ' … ' . l:end

    return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
  endfunction
endif

" highlight SCM merge conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" -- buffers -------------------------------------------------------------------

set nobomb            " don't clutter files with Unicode BOMs
set hidden            " enable switching between buffers without saving
set switchbuf=usetab  " switch to existing tab then window when switching buffer
set autoread          " auto read files changed only from the outside of ViM
if has("persistent_undo") && (&undofile)
  set autowriteall    " auto write changes if persistent undo is enabled
endif
set fsync             " sync after write
set confirm           " ask whether to save changed files

if has("autocmd")
  augroup trailing_spaces
    autocmd!
    "autocmd BufWritePre * :%s/\s\+$//e " remove trailing spaces before saving
  augroup END
  augroup restore_cursor
    " restore cursor position to last position upon file reopen
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
  augroup END
endif

" cd to the directory of the current buffer
nnoremap <silent> <leader>cd :cd %:p:h<CR>

" switch between last two files
nnoremap <leader><Tab> <c-^>

" <leader>w writes the whole buffer to the current file
nnoremap <silent> <leader>w :w!<CR>
inoremap <silent> <leader>w <ESC>:w!<CR>

" <leader>W writes all buffers
nnoremap <silent> <leader>W :wa!<CR>
inoremap <silent> <leader>W <ESC>:wa!<CR>


" -- navigation ----------------------------------------------------------------

" move to first non-whitespace character of line (when not using mac keyboard)
noremap H ^
" move to end of line (when not using mac keyboard)
noremap L g_

" scroll slightly faster
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
map <C-Up> <C-y>
map <C-Down> <C-e>

set startofline " move to first non-blank of the line when using PageUp/PageDown

" scroll by visual lines, useful when wrapping is enabled
nnoremap j gj
nnoremap <Down> gj
nnoremap k gk
nnoremap <Up> gk

set scrolljump=1    " minimal number of lines to scroll vertically
set scrolloff=4     " number of lines to keep above and below the cursor
                    "   typing zz sets current line at the center of window
set sidescroll=1    " minimal number of columns to scroll horizontally
set sidescrolloff=4 " minimal number of columns to keep around the cursor

if has("vertsplit")
  " split current window vertically
  nnoremap <leader>_ <C-w>v<C-w>l
  set splitright  " when splitting vertically, split to the right
endif
if has("windows")
  " split current window horizontally
  nnoremap <leader>- <C-w>s
  set splitbelow  " when splitting horizontally, split below
endif

" window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move cursor wihout leaving insert mode
try
  redir => s:backspace
  silent! execute 'set ' 't_kb?'
  redir END
  if s:backspace !~ '\^H'
    inoremap <C-h> <C-o>h
    inoremap <C-j> <C-o>j
    inoremap <C-k> <C-o>k
    inoremap <C-l> <C-o>l
  endif
finally
  redir END
endtry

" switch between windows by hitting <Tab> twice
nnoremap <silent> <Tab><Tab> <C-w>w

" window resizing
map <S-Left> <C-w><
map <S-Down> <C-w>-
map <S-Up> <C-w>+
map <S-Right> <C-w>>

" <leader>q quits the current window
nnoremap <silent> <leader>q :q<CR>
inoremap <silent> <leader>q <ESC>:q<CR>

" create a new tab
nnoremap <silent> <leader>t :tabnew<CR>

set whichwrap=b,s,<,> " allow cursor left/right key to wrap to the
                      " previous/next line
                      " omit [,] as we use virtual edit in insert mode

" disable arrow keys
" nnoremap <Left> :echo "arrow keys disabled, use h"<CR>
" nnoremap <Right> :echo "arrow keys disabled, use l"<CR>
" nnoremap <Up> :echo "arrow keys disabled, use k"<CR>
" nnoremap <Down> :echo "arrow keys disabled, use j"<CR>

" move to the position where the last change was made
noremap gI `.

" by default, 'a jumps to line marked with ma
" while `a jumps to line AND column marked with ma
" swap ' and `
nnoremap ' `
nnoremap ` '

" make arrow keys, home/end/pgup/pgdown, and function keys work when inside tmux
if exists('$TMUX') && (system("tmux show-options -wg xterm-keys | cut -d' ' -f2") =~ '^on')
  " tmux will send xterm-style keys when its xterm-keys option is on
  " add 'setw -g xterm-keys on' to your ~/.tmux.conf
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
  execute "set <xHome>=\e[1;*H"
  execute "set <xEnd>=\e[1;*F"
  execute "set <Insert>=\e[2;*~"
  execute "set <Delete>=\e[3;*~"
  execute "set <PageUp>=\e[5;*~"
  execute "set <PageDown>=\e[6;*~"
  execute "set <xF1>=\e[1;*P"
  execute "set <xF2>=\e[1;*Q"
  execute "set <xF3>=\e[1;*R"
  execute "set <xF4>=\e[1;*S"
  execute "set <F5>=\e[15;*~"
  execute "set <F6>=\e[17;*~"
  execute "set <F7>=\e[18;*~"
  execute "set <F8>=\e[19;*~"
  execute "set <F9>=\e[20;*~"
  execute "set <F10>=\e[21;*~"
  execute "set <F11>=\e[23;*~"
  execute "set <F12>=\e[24;*~"
endif


" -- editing -------------------------------------------------------------------

set showmode      " always show the current editing mode
set nowrap        " don't wrap lines
set linebreak     " yet if enabled break at word boundaries

if has("multi_byte")  " if multi_byte is available,
  set showbreak=↪     " use pretty Unicode marker
else                  " otherwise,
  set showbreak=>     " use ASCII character
endif

set nojoinspaces  " insert only one space after '.', '?', '!' when joining lines
set showmatch     " briefly jumps the cursor to the matching brace on insert
set matchtime=4   " blink matching braces for 0.4s

set matchpairs+=<:>         " make < and > match
runtime macros/matchit.vim  " enable extended % matching

set virtualedit=insert    " allow the cursor to go everywhere (insert)
set virtualedit+=onemore  " allow the cursor to go just past the end of line
set virtualedit+=block    " allow the cursor to go everywhere (visual block)

set backspace=indent,eol,start " allow backspacing over everything (insert)

set expandtab     " insert spaces instead of tab, CTRL-V+Tab inserts a real tab
set tabstop=2     " 1 tab == 2 spaces
set softtabstop=2 " number of columns used when hitting TAB in insert mode
set smarttab      " insert tabs on the start of a line according to shiftwidth

if has("autocmd")
  augroup makefile
    autocmd!
    " don't expand tab to space in Makefiles
    autocmd filetype make setlocal noexpandtab
  augroup END
endif

set autoindent    " enable autoindenting
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=2  " indent with 2 spaces
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'

" make Y consistent with C and D by yanking up to end of line
noremap Y y$

" CTRL-S saves file
"nnoremap <C-s> :w<CR>

" inverts paste mode
nnoremap <silent> <leader>pp :set paste! paste?<CR>
" same in insert mode
set pastetoggle=<leader>pp

function! Preserve(command)
  let l:search=@/
  let l:line = line(".")
  let l:col = col(".")
  execute a:command
  let @/=l:search
  call cursor(l:line, l:col)
endfunction

" <leader>rt retabs the file, preserve cursor position
nnoremap <silent> <leader>rt :call Preserve(":retab")<CR>

" <leader>s removes trailing spaces
noremap <silent> <leader>s :call Preserve("%s/\\s\\+$//e")<CR>

" <leader>$ fixes mixed EOLs (^M)
noremap <silent> <leader>$ :call Preserve("%s/<C-V><CR>//e")<CR>

" use <leader>d to delete a line without adding it to the yanked stack
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" use <leader>c to replace text without yanking replaced text
nnoremap <silent> <leader>c "_c
vnoremap <silent> <leader>c "_c

" yank/paste to/from the OS clipboard
map <silent> <leader>y "+y
map <silent> <leader>Y "+Y
map <silent> <leader>p "+p
map <silent> <leader>P "+P

" paste without yanking replaced text in visual mode
vnoremap <silent> p "_dP
vnoremap <silent> P "_dp

" always share the OS clipboard
"set clipboard+=unnamed

" autofix typos
iabbrev teh the

" reselect last selection after indent / un-indent in visual and select modes
vnoremap < <gv
vnoremap > >gv
vmap <Tab> >
vmap <S-Tab> <

set cpoptions+=$  " display $ at the end of the replacement zone instead of
                  " deleting text with 'cw' and alike

set formatoptions-=t  " don't auto-wrap text using textwidth
set formatoptions+=c  " auto-wrap comments using textwidth
set formatoptions+=r  " auto-insert current comment leader,  C-u to undo

" exit from insert mode without cursor movement
inoremap jk <ESC>`^

" quick insertion of newline in normal mode with <CR>
if has("autocmd")
  nnoremap <silent> <CR> :put=''<CR>
  augroup newline
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
  augroup END
endif

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" preserve cursor position when joining lines
nnoremap J :call Preserve("normal! J")<CR>

" split line and preserve cursor position
nnoremap S :call Preserve("normal! i\r")<CR>

" select what was just pasted
nnoremap <leader>v V`]

" <C-Space> triggers completion in insert mode
inoremap <C-Space> <C-P>
if !has("gui_running")
  inoremap <C-@> <C-P>
endif

set completeopt=longest,menuone,preview " better completion

" move current line down
noremap <silent>- :m+<CR>
" move current line up
noremap <silent>_ :m-2<CR>
" move visual selection down
vnoremap <silent>- :m '>+1<CR>gv=gv
" move visual selection up
vnoremap <silent>_ :m '<-2<CR>gv=gv

" change cursor to vertical bar in insert mode when using iTerm2
if $TERM_PROGRAM == 'iTerm.app'
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

nnoremap Q <NOP>

" make dot work in visual mode
vnoremap . :normal .<CR>

" make v enter blockwise visual mode, and CTRL-V enter visual mode
nnoremap v <C-V>
nnoremap <C-V> v
vnoremap v <C-V>
vnoremap <C-V> v


" -- searching -----------------------------------------------------------------

set wrapscan    " wrap around when searching
set incsearch   " show match results while typing search pattern
if (&t_Co > 2 || has("gui_running"))
  set hlsearch  " highlight search terms
endif

" temporarily disable highlighting when entering insert mode
if has("autocmd")
  augroup hlsearch
    autocmd!
    autocmd InsertEnter * let g:restorehlsearch=&hlsearch | :set nohlsearch
    autocmd InsertLeave * let &hlsearch=g:restorehlsearch
  augroup END
endif
set ignorecase  " case insensitive search
set smartcase   " case insensitive only if search pattern is all lowercase
                "   (smartcase requires ignorecase)
set gdefault    " search/replace globally (on a line) by default

" temporarily disable search highlighting
nnoremap <silent> <leader><Space> :nohlsearch<CR>:match none<CR>:2match none<CR>:3match none<CR>

" highlight all instances of the current word where the cursor is positioned
nnoremap <silent> <leader>hs :setl hls<CR>:let @/="\\<<C-r><C-w>\\>"<CR>

" use <leader>h1, <leader>h2, <leader>h3 to highlight words in different colors
nnoremap <silent> <leader>h1 :highlight Highlight1 ctermfg=0 ctermbg=226 guifg=Black guibg=Yellow<CR> :execute 'match Highlight1 /\<<C-r><C-w>\>/'<cr>
nnoremap <silent> <leader>h2 :highlight Highlight2 ctermfg=0 ctermbg=51 guifg=Black guibg=Cyan<CR> :execute '2match Highlight2 /\<<C-r><C-w>\>/'<cr>
nnoremap <silent> <leader>h3 :highlight Highlight3 ctermfg=0 ctermbg=46 guifg=Black guibg=Green<CR> :execute '3match Highlight3 /\<<C-r><C-w>\>/'<cr>

" very magic search patterns
" everything but '0'-'9', 'a'-'z', 'A'-'Z' and '_' has a special meaning
"nnoremap / /\v
"vnoremap / /\v
"nnoremap ? ?\v
"vnoremap ? ?\v
"cnoremap %s/ %s/\v

" replace word under cursor
nnoremap <leader>; :%s/\<<C-r><C-w>\>//<Left>


function! BlinkMatch(t)
    let [l:bufnum, l:lnum, l:col, l:off] = getpos('.')
    let l:current = '\c\%#'.@/
    let l:highlight = matchadd('IncSearch', l:current, 1000)
    redraw
    exec 'sleep ' . float2nr(a:t * 1000) . 'm'
    call matchdelete(l:highlight)
    redraw
endfunction

" center screen on next/previous match, blink current match
noremap <silent> n nzzzv:call BlinkMatch(0.2)<CR>
noremap <silent> N Nzzzv:call BlinkMatch(0.2)<CR>


function! GetVisualSelection()
  let [l:l1, l:c1] = getpos("'<")[1:2]
  let [l:l2, l:c2] = getpos("'>")[1:2]
  let l:selection = getline(l:l1, l:l2)
  let l:selection[-1] = l:selection[-1][: l:c2 - 1]
  let l:selection[0] = l:selection[0][l:c1 - 1:]
  return join(l:selection, "\n")
endfunction

" search for visually selected areas
xnoremap * <ESC>/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR><CR>
xnoremap # <ESC>?<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR><CR>

" prepare search based on visually selected area
xnoremap / <ESC>/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR>

" prepare substitution based on visually selected area
xnoremap & <ESC>:%s/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR>/


" -- spell checking ------------------------------------------------------------

set spelllang=en  " English only
set nospell       " disabled by default

if has("autocmd")
  augroup spell
    autocmd!
    "autocmd filetype vim setlocal spell " enabled when editing .vimrc
  augroup END
endif


" -- pathogen ------------------------------------------------------------------

" add ~/.vim to runtimepath if not present yet
" (eases cloning .vim.git on Windows)
if (match(&runtimepath, "\\.vim") == -1)
  set runtimepath^=~/.vim
endif

silent! runtime bundle/pathogen/autoload/pathogen.vim
if filereadable(expand("~/.pathogen_disabled"))
  let g:pathogen_disabled = readfile(expand("~/.pathogen_disabled"))
endif
silent! call pathogen#infect()
silent! call pathogen#helptags()
