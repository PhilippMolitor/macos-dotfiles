" basics
set title
set number
set relativenumber
set showmatch
set wrap
set showbreak=>>\ \  
set ignorecase
set incsearch
set noshowmode
set gdefault
set path+=**

" syntax highlighting
syntax on
highlight Comment cterm=italic
highlight Constant cterm=italic
highlight Special cterm=italic
highlight PreProc cterm=italic

" tabs
set softtabstop=2
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2

" enable mouse interaction
set selectmode+=mouse
set mouse=a

" disable swapfiles
set noswapfile
set nobackup
set nowritebackup

" yank & paste --> system clipboard
set clipboard=unnamedplus

" literally next/prev. line (even with wrapped lines)
nnoremap j gj
nnoremap k gk

" switch to next/prev. buffer with tab/shift-tab
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>

" write with root privileges
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" restore cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
\ endif
