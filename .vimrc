syntax on

set encoding=utf8

set number ruler
set colorcolumn=80

set backspace=indent,eol,start

filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

autocmd FileType css,html,javascript,json,markdown,scss,typescript,typescriptreact,yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType go setlocal noexpandtab
autocmd FileType markdown setlocal textwidth=80 spell spelllang=en_us

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

call plug#begin('~/.vim/plugged')

" Utilities
Plug 'majutsushi/tagbar'
Plug 'prettier/vim-prettier'
Plug 'ycm-core/YouCompleteMe', { 'do': '~/.vim/plugged/YouCompleteMe/install.py --all --clangd-completer' }

" TypeScript/TSX
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Puppet
Plug 'rodjek/vim-puppet'

call plug#end()

let g:prettier#autoformat = 0

" max line length that prettier will wrap on
let g:prettier#config#print_width = 120
" number of spaces per indentation level
let g:prettier#config#tab_width = 2
" use tabs over spaces
let g:prettier#config#use_tabs = 'false'
" print semicolons
let g:prettier#config#semi = 'true'
" single quotes over double quotes
let g:prettier#config#single_quote = 'true'
" print spaces between brackets
let g:prettier#config#bracket_spacing = 'true'
" put > on the last line instead of new line
let g:prettier#config#jsx_bracket_same_line = 'false'
" avoid|always
let g:prettier#config#arrow_parens = 'always'
" none|es5|all
let g:prettier#config#trailing_comma = 'all'
" flow|babylon|typescript|css|less|scss|json|graphql|markdown
let g:prettier#config#parser = 'babylon'
" cli-override|file-override|prefer-file
let g:prettier#config#config_precedence = 'prefer-file'
" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'
" css|strict|ignore
let g:prettier#config#html_whitespace_sensitivity = 'css'

autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html PrettierAsync
