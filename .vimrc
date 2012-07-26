" -- bootstrap -----------------------------------------------------------------

set encoding=utf-8  " set vim encoding to UTF-8
set nocompatible    " the future is now, use vim defaults instead of vi ones
set nomodeline      " disable mode lines (security measure)
set history=1000    " boost commands and search patterns history
set undolevels=1000 " boost undo levels

if exists("+shellslash")
  set shellslash    " expand filenames with forward slash
endif

set timeoutlen=500  " time in milliseconds for a key sequence to complete
let mapleader=","   " change leader key to ,

" <leader>ev edits .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" <leader>sv sources .vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>:redraw<CR>:echo $MYVIMRC 'reloaded'<CR>


" -- backup and swap files -----------------------------------------------------

set nobackup      " disable backup files
set nowritebackup " disable backup files
set swapfile      " enable swap files (useful when loading huge files)

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

if has("persistent_undo")
  let &undodir=&backupdir
  set undofile
endif


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


" -- display -------------------------------------------------------------------

set title       " change the terminal title
set lazyredraw  " do not redraw when executing macros
set report=0    " always report changes
set cursorline  " highlight current line

if has("autocmd")
  autocmd filetype vim set textwidth=80
endif

if has("gui_running")
  set cursorcolumn  " highlight current column
endif

if exists("+relativenumber")
  set relativenumber  " show relative line numbers
  set numberwidth=3   " narrow number column
  " cycles between relative / absolute / no numbering
  function! RelativeNumberToggle()
    if (&relativenumber == 1)
      set number number?
    elseif (&number == 1)
      set nonumber number?
    else
      set relativenumber relativenumber?
    endif
  endfunc
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
  autocmd InsertEnter * let g:restorelist=&list | :set nolist
  autocmd InsertLeave * let &list=g:restorelist
endif

" inverts display of unprintable characters
nmap <silent> <leader>l :set list! list?<CR>

set visualbell    " shut up
set noerrorbells  " shut up
set mousehide     " hide mouse pointer when typing

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
    return getcwd()
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

if exists("+colorcolumn")
  set colorcolumn=81          " display a marker after column 80
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


" -- buffers -------------------------------------------------------------------

set nobomb            " don't clutter files with Unicode encoding with BOMs
set hidden            " enable switching between buffers without saving
set switchbuf=usetab  " switch to existing tab then window when switching buffer
set autoread          " auto read files changed only from the outside of ViM
"set autowrite         " write changes before hiding a buffer
set fsync             " sync after write
set confirm           " ask whether to save changed files

if has("autocmd")
  "autocmd BufWritePre * :%s/\s\+$//e " remove trailing spaces before saving
endif

" cd to the directory of the current buffer
nnoremap <silent> <leader>cd :cd %:p:h<CR>


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
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" switch between windows by hitting <Tab> twice
nmap <silent> <Tab><Tab> <C-w>w

" window resizing
map <S-Left> <C-w><
map <S-Down> <C-w>-
map <S-Up> <C-w>+
map <S-Right> <C-w>>

" <leader>q quits the current window
nnoremap <leader>q :q<CR>
inoremap <leader>q <ESC>:q<CR>

" create a new tab
nnoremap <silent> <leader>t :tabnew<CR>

" next/previous buffer navigation
nnoremap <silent> <C-b> :bnext<CR>
nnoremap <silent> <S-b> :bprev<CR>

set whichwrap=b,s,<,> " allow cursor left/right key to wrap to the
                      " previous/next line
                      " omit [,] as we use virtual edit in insert mode

" make space in normal mode go down a page rather than left a character
noremap <Space> <C-f>

" disable arrow keys
" nnoremap <Left> :echo "arrow keys disabled, use h"<CR>
" nnoremap <Right> :echo "arrow keys disabled, use l"<CR>
" nnoremap <Up> :echo "arrow keys disabled, use k"<CR>
" nnoremap <Down> :echo "arrow keys disabled, use j"<CR>

" move to the position where the last change was made
noremap gI `.


" -- editing -------------------------------------------------------------------

set showmode      " always show the current editing mode
set nowrap        " don't wrap lines
set nojoinspaces  " insert only one space after '.', '?', '!' when joining lines
set showmatch     " briefly jumps the cursor to the matching brace on insert
set matchtime=4   " blink matching braces for 0.4s

set matchpairs+=<:>         " make < and > match
runtime macros/matchit.vim  " enable extended % matching

set virtualedit=insert    " allow the cursor to go everywhere (insert)
set virtualedit+=onemore  " allow the cursor to go just past the end of line

set backspace=indent,eol,start " allow backspacing over everything (insert)

set expandtab     " insert spaces instead of tab, CTRL-V+Tab inserts a real tab
set tabstop=2     " 1 tab == 2 spaces
set softtabstop=2 " number of columns used when hitting TAB in insert mode
set smarttab      " insert tabs on the start of a line according to shiftwidth

if has("autocmd")
  " don't expand tab to space in Makefiles
  autocmd filetype make setlocal noexpandtab
endif

set autoindent    " enable autoindenting
set copyindent    " copy the previous indentation on autoindenting
set smartindent   " smart autoindenting when starting a new line
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

" <leader>rt retabs the file
nnoremap <silent> <leader>rt :1,$retab<CR>

" <leader>s removes trailing spaces
noremap <silent> <leader>s :let b:s=@/ | %s/\s\+$//e | let @/=b:s<CR>``

" <leader>eol fixes mixed EOLs (^M)
noremap <silent> <leader>eol :let b:s=@/ | %s/<C-V><CR>//e | let @/=b:s<CR>``

" use <leader>d to delete a line without adding it to the yanked stack
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" yank/paste to/from the OS clipboard
map <leader>y "+y
map <leader>Y "+Y
map <leader>p "+p
map <leader>P "+P

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

" exit from interactive mode with jk because <ESC> is too far away
inoremap jk <ESC>

" quick insertion of newline in normal mode with <CR>
nnoremap <silent> <CR> :put=''<CR>

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" preserve cursor position when joining lines
nnoremap J mzJ`z

" split line and preserve cursor position
nnoremap S mzi<CR><Esc>`z

" select what was just pasted
nnoremap <leader>v V`]


" -- searching -----------------------------------------------------------------

set wrapscan    " wrap around when searching
set incsearch   " show match results while typing search pattern
if (&t_Co > 2 || has("gui_running"))
  set hlsearch  " highlight search terms
endif

" temporarily disable highlighting when entering insert mode
if has("autocmd")
  autocmd InsertEnter * let g:restorehlsearch=&hlsearch | :set nohlsearch
  autocmd InsertLeave * let &hlsearch=g:restorehlsearch
endif
set ignorecase  " case insensitive search
set smartcase   " case insensitive only if search pattern is all lowercase
                "   (smartcase requires ignorecase)
set gdefault    " search/replace globally (on a line) by default

" temporarily disable search highlighting
nnoremap <silent> <leader><Space> :nohlsearch<CR>

" highlight all instances of the current word where the cursor is positioned
nnoremap <silent> <leader>h :setl hls<CR>:let @/="<C-r><C-w>"<CR>

" very magic search patterns
" everything but '0'-'9', 'a'-'z', 'A'-'Z' and '_' has a special meaning
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %s/\v

" replace word under cursor
nnoremap <leader>; :%s/\<<C-r><C-w>\>//<Left>

" center screen on next/previous selection
noremap n nzz
noremap N Nzz


" -- spell checking ------------------------------------------------------------

set spelllang=en  " English only
set nospell       " disabled by default

if has("autocmd")
  autocmd filetype vim setlocal spell " enabled when editing .vimrc
endif


" --user defined ---------------------------------------------------------------

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
