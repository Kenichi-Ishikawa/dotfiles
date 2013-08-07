"--------------------------------------------------------------------------
" vundle
set nocompatible
"
" Vundle
"
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle で管理するプラグインを書いていく
Bundle 'gmarik/vundle'
Bundle 'bling/vim-airline'

filetype plugin indent on


"--------------------------------------------------------------------------
" neobundle
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

filetype plugin indent on     " Required!

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

"GitHubリポジトリにあるプラグインを利用場合
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'bling/vim-airline'

"GitHub以外のGitリポジトリにあるプラグインを利用する場合
NeoBundle 'git://git.wincent.com/command-t.git'

"Git以外のリポジトリにあるプラグインをを利用する場合
NeoBundle 'http://svn.macports.org/repository/macports/contrib/mpvim/'
NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'

"--------------------
" 基本的な設定
"--------------------
"新しい行のインデントを現在行と同じにする
set autoindent

"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/vimbackup

"クリップボードをWindowsと連携する
set clipboard=unnamed

"vi互換をオフする
set nocompatible

"スワップファイル用のディレクトリを指定する
set directory=$HOME/vimbackup

"タブの代わりに空白文字を指定する
set expandtab

"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden

"インクリメンタルサーチを行う
set incsearch

"行番号を表示する
set number

"閉括弧が入力された時、対応する括弧を強調する
set showmatch

"新しい行を作った時に高度な自動インデントを行う
set smarttab

" grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh

"小文字の検索で大文字も見つかるようにする(検索時に大文字小文字を無視する)
set ignorecase

" 検索結果のハイライトをEsc連打でクリアする
nnoremap <ESC><ESC> :nohlsearch<CR>


""""""""""""""""""""""""""""""
"半角スペースを表示
""""""""""""""""""""""""""""""
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END
