set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Bundle 'gmarick/vundle'
Bundle 'scrooloose/syntastic.git'
Bundle 'flazz/vim-colorschemes.git'
Bundle 'tpope/vim-fugitive.git'
Bundle 'tpope/vim-git.git'
Bundle 'ervandew/supertab.git'
Bundle 'wincent/Command-T.git'
Bundle 'mitechie/pyflakes-pathogen.git'
Bundle 'mileszs/ack.vim.git'
Bundle 'sjl/gundo.vim.git'
Bundle 'fs111/pydoc.vim.git'
Bundle 'vim-scripts/pep8.git'
Bundle 'alfredodeza/pytest.vim.git'
Bundle 'reinh/vim-makegreen'
Bundle 'rodjek/vim-puppet.git'
Bundle 'surround.vim'
Bundle 'ScrollColors'
Bundle 'jaxbot/semantic-highlight.vim'
Bundle 'jewes/Conque-Shell'
Bundle 'jwalton512/vim-blade'
syntax on
filetype plugin indent on

" Some new configurations
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Add the virtualenv's site-packages to vim path
if version >= 703
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]
let g:semanticTermColors = [1,2,3,4,5,6,7,9,10,12,13,14,15,16]

" Always show the status line
set laststatus=2

" Set following to show "<CAPS>" in the status line when "Caps Lock" is on.
let b:keymap_name = "CAPS"
" Show b:keymap_name in status line.
:set statusline^=%k

" Format the status line
" original
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
" put paste info
set statusline=%#error#%{SL('HasPaste')}%*
" set color to 'search'
set statusline+=%#todo#
" if a help file or not
set statusline+=%h
" if modified or not
set statusline+=%m
" set color to 'error'
set statusline+=%#error#
" read-only or not
set statusline+=%r
" reset color
set statusline+=%*
" FILETYPE
"set statusline+=%y\ 
" column number 
set statusline+=\ %c,
" line/total lines
set statusline+=%l/%L
" percent of file
set statusline+=\ %P
" Move to the right align
set statusline+=%=
" put up to 50 characters of filename and path
set statusline+=\ %30.30{fnamemodify(bufname('%'),':p:h')}/
set statusline+=%#statusbold#
set statusline+=%t
" space at end to make it easier to read
set statusline+=\     

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
" ERROR SOMEWHERE IN HERE
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=1000 ttimeoutlen=50
" ERROR SOMEWHERE IN HERE

" Show numbers
set number

set directory=~/.vimswap//
set backupdir=~/.vimbackup//


set background=dark
"colorscheme solarized
colorscheme oceanblack256
"colorscheme 256-jungle
"colorscheme zenburn
if version < 703
colorscheme CodeFactoryv3
endif
highlight ColorColumn ctermbg=Blue guibg=Blue
highlight statusbold term=bold,reverse ctermfg=5 ctermbg=118 gui=bold,reverse
if version >= 703
    set colorcolumn=80
endif
set nohidden
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE'
    en
    return ''
endfunction

if has("eval")
    function! SL(function)
        if exists('*'.a:function)
            return call(a:function,[])
        else
            return ''
        endif
    endfunction

    function! GetFullFilePath(arg)
        return fnamemodify(arg, ":p:h")
    endfunction
endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => End helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ThreeUnderscores ctermbg=red guibg=red
highlight ThreeUnderscores ctermbg=red guibg=red
match ThreeUnderscores /___/
let g:Powerline_symbols = 'fancy'
let g:syntastic_python_checker_args='--builtins=_'
