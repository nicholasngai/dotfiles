syntax on

set number
set ruler

filetype plugin indent on
set tabstop=4 shiftwidth=4 expandtab

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

autocmd FileType css,html,javascript,json,markdown,typescript,yaml setlocal tabstop=2 shiftwidth=2

call plug#begin('~/.vim/plugged')

Plug 'leafgarland/typescript-vim'
Plug 'ycm-core/YouCompleteMe'

call plug#end()
