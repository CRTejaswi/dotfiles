" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Remap a few keys for Windows behavior
source $VIMRUNTIME/mswin.vim

" Mouse behavior (the Windows way)
behave mswin

" Auto-Source .vimrc from project if `vim .` is issued
set shell=C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe
let mapleader = " "
set exrc
set guicursor=
set encoding=utf-8
set nohlsearch
set noerrorbells
set visualbell t_vb= 
set number
set relativenumber
set wrap linebreak
set incsearch
set smartindent
set scrolloff=10
set signcolumn=yes
"set tab to spaces
set shiftwidth=4 softtabstop=4 expandtab 
set path+=**
"set wildmenu
" Disable backup/swapfiles
set noswapfile
set nobackup
set undodir='~/vimfiles/undodir'
set undofile
set pastetoggle=<F3>
"set dir='~/tmp'
set nrformats-=octal "disable octal number notation
" Display time on status-bar
" https://vim.fandom.com/wiki/Display_date-and-time_on_status_line
set ruler
set rulerformat=%30(%{strftime('\[%a\ %d\-%m\-%Y\ %I:%M%p\]')}\ %p%%%)

" Vim: Plugins
call plug#begin('~/vimfiles/plugged')
Plug 'vim-utils/vim-man'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'mattn/emmet-vim'
" Highlight text with color
Plug 'gko/vim-coloresque'
" Comment in all formats (gc)
Plug 'tpope/vim-commentary' 
Plug 'itchyny/screensaver.vim'
Plug 'mattn/emmet-vim' 
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Plugin Settings 
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:user_emmet_mode='n'
let g:user_emmet_leader_key=','
""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Key-Bindings
""""""""""""""""""""""""""""""""""""""""""""""""""
" Change Default Behaviour
noremap <Leader>o o<ESC>
noremap <Leader>O O<ESC>
nnoremap <Leader>v normal!<C-v>
" Scroll Up/Down A Page
nnoremap <C-j> <PageDown>
nnoremap <C-k> <PageUp>
" Custom Commands
" Write date
nnoremap <Leader>d :r !Get-Date -Format 'dd-MM-yyyy (hh:mm tt)'<Esc>i
" Open file in browser (firefox)
nnoremap <Leader>f :!firefox %<Esc><Esc>
" Write [c]lipboard: copyTo/copyFrom clipboard
"nnoremap <Leader>y !Set-Clipboard .
nnoremap <Leader>y "*yy 
vnoremap <Leader>y "*yy 
nnoremap <Leader>p "*p
vnoremap <Leader>p "*p
" Automatically closing braces
inoremap '<TAB> ''<ESC>i
inoremap '''<CR> '''<CR>'''<C-o>O
inoremap ```<CR> ```<CR>```<C-o>O
inoremap { {}<ESC>i
inoremap [ []<ESC>i
inoremap ( ()<ESC>i
inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-o>O
inoremap (<CR> (<CR>)<C-o>O
inoremap br; <br><CR>
" Save & Close
nnoremap <F4> <ESC>:up<CR>:q<CR>
nnoremap <F5> <ESC>:wa<CR>:qa<CR>
" Move entire line up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" Customization for word-wrapping
" https://vimtricks.com/p/word-wrapping/
let s:wrapenabled = 0
function! ToggleWrap()
  set wrap linebreak nolist
  if s:wrapenabled
    unmap j
    unmap k
    unmap 0
    unmap ^
    unmap $
    let s:wrapenabled = 0
  else
    nnoremap j gj
    nnoremap k gk
    nnoremap 0 g0
    nnoremap ^ g^
    nnoremap $ g$
    vnoremap j gj
    vnoremap k gk
    vnoremap 0 g0
    vnoremap ^ g^
    vnoremap $ g$
    let s:wrapenabled = 1
  endif
endfunction
map <leader>w :call ToggleWrap()<CR>

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


