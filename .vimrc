
"""
""" Additional configurations on top of basic.vim
"""

" Highlight ideographic spaces
highlight ZenkakuSpace cterm=underline ctermbg=lightred
autocmd BufNewFile,BufRead * match ZenkakuSpace /　/

" Esc with consecutive 'j's in insert mode
inoremap <silent> jj <ESC>

" Page scrolling offset
set scrolloff=5

" Line Number
set number
highlight LineNr ctermfg=darkgrey

" Underline on current cursor line
set cursorline

" Override tab settings from basic.vim
set tabstop=2
set shiftwidth=2
