scriptencoding utf-8

" Plugins {{{
runtime vim-plug/plug.vim
call plug#begin('~/.config/nvim/plugged')
" colorscheme
Plug 'dracula/vim'

" indent line guides
Plug 'lukas-reineke/indent-blankline.nvim'

" autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" commenting (gcc to toggle line, gc to toggle target of motion)
Plug 'tpope/vim-commentary'

" surrounding chars, (cs"' change surround " to ', ds delete,)
Plug 'tpope/vim-surround'

" git commands inside vim (:G or :Git)
Plug 'tpope/vim-fugitive'

" adjust tab size/style based on filetype and local files
Plug 'tpope/vim-sleuth'

" unix shell commands
Plug 'tpope/vim-eunuch'

" shows git line status in vim gutter
Plug 'airblade/vim-gitgutter'

" syntax highlighting for a lot of languages
Plug 'sheerun/vim-polyglot'

" fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" aligning text :Tabularize
Plug 'godlygeek/tabular'

" undo tree
Plug 'mbbill/undotree'

" file system explorer
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" status line
Plug 'rbong/vim-crystalline'

" Show/trim trailing whitespace
Plug 'ntpeters/vim-better-whitespace'

" prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" better buffer display
Plug 'akinsho/bufferline.nvim'

call plug#end()
" }}} Plugins

" Binds {{{
let mapleader=","

nnoremap <leader>sv :source $MYVIMRC<CR>

" Map jj and jk to <ESC> to leave insert mode quickly
inoremap jj <ESC>
inoremap jk <ESC>

" CTRL-U for undo in insert mode
inoremap <C-U> <C-G>u<C-U>

" Use | and _ to split windows (while preserving original behaviour of
" [count]bar and [count]_).
" Stolen from http://howivim.com/2016/andy-stewart/
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

map <leader>ss :setlocal spell!<cr>
set spelllang=en_ca
map <F2> :set list! list?<cr>

"Unbind arrow keys
for prefix in ['i','n','v']
	for key in ['<Up>', '<Down>', '<Left>', '<Right>']
		exe prefix . "noremap " . key . " <Nop>"
	endfor
endfor

" unhilight search results
nnoremap <leader>n :noh<CR>

"Easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}} Binds

" Plugin Config {{{
" nvim-telescope/telescope.nvim {{{
lua << EOF
local actions = require('telescope.actions')

project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  },
}
EOF

nnoremap <leader>ff <cmd>lua project_files()<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
" }}}

" neoclide/coc.nvim {{{
" alt+space to trigger completion
inoremap <silent><expr> <M-space> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" }}}

" airblade/vim-gitgutter {{{
let g:gitgutter_override_sign_column_highlight = 1
set foldtext=gitgutter#fold#foldtext() " show (*) on folds with changes
nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)

function! GitStatus()
  let [added,modified,removed] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', added, modified, removed)
endfunction
" }}}

" mbbill/undotree {{{
nnoremap <F5> :UndotreeToggle<CR>

if has("persistent_undo")
   let target_path = expand('~/.config/nvim/undo')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif
" }}}

" kyazdani42/nvim-tree.lua {{{
lua << EOF
require'nvim-tree'.setup{
  disable_netrw = true,
  auto_close = false,
}
EOF

let g:nvim_tree_ignore = ['.git', 'node_modules']
let g:nvim_tree_gitignore = 1
let g:nvim_tree_highlight_opened_files = 1

nnoremap <C-f> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>f :NvimTreeFindFile<CR>

highlight NvimTreeFolderIcon guibg=blue
" }}}

" akinsho/bufferline.nvim {{{
lua << EOF
require('bufferline').setup{
  options = {
    always_show_bufferline = true,
    diagnostics = "coc",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    numbers = function(opts) return string.format('%s ', opts.id) end,
    offsets = {{ filetype = "NvimTree", text = "Files", text_align = "left" }},
    separator_style = 'thick',
    show_buffer_close_icons = false,
    show_close_icon = false,
  }
}
EOF

nnoremap <silent> gb :BufferLinePick<CR>
" }}}

" rbong/vim-crystalline {{{
function! StatusLine(current, width)
   let l:s = ''

   if a:current
      let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
   else
      let l:s .= '%#CrystallineInactive#'
   endif
   let l:s .= ' %f%h%W%m%r '
   if a:current
      let l:s .= crystalline#right_sep('', 'Fill')
      if fugitive#head() != ''
         let l:s .= '  %{fugitive#head()} (%{GitStatus()})'
      endif
   endif

   let l:s .= '%='
   if a:current
      let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
      let l:s .= crystalline#left_mode_sep('')
   endif
   if a:width > 80
      let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
   else
      let l:s .= ' '
   endif

   return l:s
endfunction

function! TabLine()
   let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
   return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
"let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'dracula'
" }}}

" ntpeters/vim-better-whitespace {{{
let g:strip_whitelines_at_eof=1 " stripe empty lines at end of file
let g:show_spaces_that_precede_tabs=1 " show spaces before/between tabs
nnoremap ]w :NextTrailingWhitespace<CR>
nnoremap [w :PrevTrailingWhitespace<CR>
" }}}
" }}} Plugin Config

" User Interface {{{
" Colors {{{
set termguicolors
silent! colorscheme dracula
set background=dark

syntax enable

" only highlight first 500 characters
set synmaxcol=500
" }}} Colors

" Folds {{{
" auto-close folds below current foldlevel when cursor leaves
set foldclose=all

set foldenable
set foldmethod=marker

" default to all folds open
set foldlevelstart=99
" limit folds when using indent or syntax
set foldnestmax=5
set foldopen+=jump
" }}} Folds

filetype plugin indent on
" don't redraw while executing macros/etc
set lazyredraw
set redrawtime=3000

" maintain indent level when wrapping
if exists('+breakindent')
  set breakindent
endif

set number
set cursorline

" always show statusline
set laststatus=2

" let same file scroll differently in separate panes
set noscrollbind

" disable visual bell
set noerrorbells
set visualbell t_vb=

" set lines in view at edges of screen
set scrolloff=5
set sidescrolloff=5
set sidescroll=1

" display incomplete commands
set showcmd
set cmdheight=1

" always show the signcolumn to avoid jitter
set signcolumn=yes
highlight SignColumn guibg=NONE ctermbg=NONE

" open new split panes to the right and bottom
set splitbelow
set splitright

" reasonable tab completion
set wildmode=full

" resize splits when window is resized
augroup on_vim_resized
  autocmd!
  autocmd vimResized * wincmd =
augroup END

" always show buffer/tab line
"set showtabline=2
" }}} User Interface

" File Handling {{{
set fileformats=unix,dos,mac

" automatically change directory to that of current file
set autochdir

" hide buffers instead of closing them
set hidden

" search within subfolders by default
set path+=**
" but ignore noise
set path-=.git,build,lib,node_modules,public

" ignore autogenerated files
set wildignore+=*.o,*.obj,*.pyc
" ignore source control
set wildignore+=.git
" ignore libs/dirs since they contain compiled libraries
set wildignore+=build,lib,node_modules,public
" ignore images and fonts
set wildignore+=*.gif,*.jpg,*.jpeg,*.png,*.svg,*.otf,*.ttf
" ignore case
set wildignorecase
" }}} File Handling

" Editor Behaviour {{{
" Indentation {{{
" convert tabs to spaces
set expandtab

set shiftwidth=2
set softtabstop=2
set tabstop=2

" round up indents
set shiftround
" }}} Indentation

" Completion {{{
set completeopt=longest,menuone,noinsert,noselect

" Enable tab navigation between completion items
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Enter to confirm completion item
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" }}} Completion

" don't continue comments when using o/O
set formatoptions-=o
" recognize numbered lists and wrap accordingly
set formatoptions+=n

" show special indicators
set list
" highlight trailing spaces
set listchars=trail:·,tab:»·
" Show wrap indicators
set listchars+=extends:»,precedes:«
" Show non-breaking spaces
set listchars+=nbsp:%

" Make h/l move across beginning/end of line
set whichwrap+=hl

" Soft wrap, with indicator
set wrap
set showbreak=«

" WSL clipboard support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
  augroup END
endif
" }}} Editor Behaviour

" Searching {{{
" match all results in a line by default (/g at end to undo)
set gdefault

" ignore case unless using some uppercase
set ignorecase
set smartcase

" <leader>h starts a find & replace for word under cursor
nnoremap <leader>h :%s/\<<C-R><C-W>\>/<C-R><C-W>/g<Left><Left>
" }}} Searching

" Filetype Configs {{{
augroup filetype_tweaks
  autocmd!

  " Enable spell checking & linebreaking at words in some filetypes
  autocmd BufNewFile,BufReadPost *.txt,*.md,*.markdown,COMMIT_EDITMSG
    \ setlocal spell linebreak

  " Consider '-' part of a world when tab completion, etc in css/less
  autocmd FileType css,less setlocal iskeyword+=-

  " Fold via syntax for JS/TypeScript
  autocmd FileType javascript,typescript setlocal foldmethod=syntax
augroup END
" }}} Filetype Configs

