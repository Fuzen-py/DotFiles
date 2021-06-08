" General Settings {{{1
let g:loaded_python_provider=1
let g:mapleader = ","
let g:maplocalleader = ','
set termguicolors
set mouse=a
set modeline
set modelines=3
set noshowmode
set viewoptions=cursor,folds,slash,unix
syntax on
filetype plugin on
filetype plugin indent on
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let $NVIM_TUI_ENABLE_CURSOR_SHAME=2
set hidden
set number
set backspace=indent,eol,start
set history=1000
set list
set smartcase
set report =0

" Some language servers has issues with backups
setlocal nobackup
setlocal nowritebackup

" More space to display messages
set cmdheight=4

" execute 'set undodir='.expand(s:vim_path . '/undofiles')
set undofile
" execute 'set dir='.expand(s:vim_path . '/swapfiles//')
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
set autoindent
set clipboard=unnamedplus
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
autocmd filetype svn, *commit* setlocal spell " Spell checking
" Set cursor shape {{{2
if empty($TMUX)
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
	let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
	let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif " }}}
" Cursor follows window focus (x.x) {{{2
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline " }}}
" Relative Numbering {{{2
autocmd InsertLeave,BufRead * :let &relativenumber = 1
autocmd InsertEnter * :let &relativenumber = 0
if has('filterpipe')
	set noshelltemp
endif " }}}
" InvisChars {{{
if has('multi_byte') && &encoding ==# 'utf-8'
	set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:±,trail:-,eol:¬
else
	set listchars=tab:>>\ ,eol:;,trail:-,extends:>,precedes:<,nbsp:+
endif " }}}
" Folding {{{2
set foldenable
set foldlevel=2

set foldmethod=syntax
"}}}
" }}}
" vim: tabstop=4:shiftwidth=4:softtabstop=4:noexpandtab:foldmethod=marker:
