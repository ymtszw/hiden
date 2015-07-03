" 半角スペースハイライト
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace / /
" インサートモードでjjでEsc
inoremap <silent> jj <ESC>
" ページ送り
set scrolloff=5
" Line Number
set number
" 検索ハイライト
set hlsearch
" ハイライト
syntax enable
" 現在行に線
set cursorline

" タブを表示する幅
set tabstop=2
" タブを挿入するときの幅
set shiftwidth=2
" タブをスペースにしない・する
set expandtab
" set softtabstop=0

" NeoBundle configuration
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
	if &compatible
    	set nocompatible               " Be iMproved
	endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

  " Let NeoBundle manage NeoBundle
  " Required:
  NeoBundleFetch 'Shougo/neobundle.vim'

  " My Bundles here:
  " Refer to |:NeoBundle-examples|.
  " Note: You don't set neobundle setting in .gvimrc!

  " Required:
  filetype plugin indent on

  " If there are uninstalled bundles found on startup,
  " this will conveniently prompt you to install them.
  NeoBundleCheck

  NeoBundle 'surround.vim'
  NeoBundle 'bronson/vim-trailing-whitespace'

call neobundle#end()
