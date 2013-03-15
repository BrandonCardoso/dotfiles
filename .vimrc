set nocompatible

" ## VUNDLE
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'wikitopian/hardmode'
Bundle 'godlygeek/tabular'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/snipmate-snippets'
Bundle 'garbas/vim-snipmate'
Bundle 'flazz/vim-colorschemes'
Bundle 'rosstimson/scala-vim-support'
" ##

" Toggle hardmode
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" Underline the current line with dashes
nnoremap <F5> yypVr-
inoremap <F5> <Esc>yypVr-o

set history=700
set foldmethod=marker

let mapleader=","

set scrolloff=7

set wildmenu

set ruler

set cmdheight=1

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set wildmode=longest,list

set hlsearch
set incsearch
set ignorecase
set smartcase
set lazyredraw

set showmatch
set matchtime=2

set hidden

set cursorline

set splitbelow
set splitright

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

set clipboard=unnamed

if has("unix") && v:version >= 703
	set clipboard+=unnamedplus
endif

syntax on
set background=light
"let g:solarized_termcolors=256
colorscheme solarized

set encoding=utf8

try
	lang en_US
catch
endtry

set fileformats=unix,dos,mac

set backupdir=$HOME/.vim/backup

set noexpandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set autoindent
set smartindent
set nowrap
set linebreak
set number

set laststatus=2

set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

function! CurDir()
	let curdir = substitute(getcwd(), "/home/pazuru/","~/","g")
	return curdir
endfunction

function! HasPaste()
	if &paste
		return 'PASTE MODE	'
	else
		return ''
	endif
	set ignorecase
	set smartcase
endfunction

map <leader>ss :setlocal spell!<cr>
set spelllang=en_ca
map <F2> :set list! list?<cr>

"Unbind arrow keys
for prefix in ['i','n','v']
	for key in ['<Up>', '<Down>', '<Left>', '<Right>']
		exe prefix . "noremap " . key . " <Nop>"
	endfor
endfor

"Easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

filetype plugin indent on
