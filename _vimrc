"=============================================================================
"  vimrc: vimrcはシステム管理者が必要最小限の設定をしておくものであり、
"         個人用の設定は_vimrc(.vimrc)で行う。
"         従ってvimrcは基本的に変更しない。
"         本設定ファイルでは主に文字コードの自動認識のみ行っている。
"=============================================================================
set nocompatible
"----------------------------------------
"内部エンコーディングと文字コード自動認識
"----------------------------------------
let s:MSWindows = has('win95') + has('win16') + has('win32') + has('win64')

if isdirectory($HOME . '/.vim')
  let s:CFGHOME=$HOME.'/.vim'
elseif isdirectory($HOME . '/vimfiles')
  let s:CFGHOME=$HOME.'/vimfiles'
elseif isdirectory($VIM . '/vimfiles')
  let s:CFGHOME=$VIM.'/vimfiles'
endif

"vimfiles (.vim) に特定のファイルが存在する場合は以下のように設定される。
"デフォルトはUTF-8
"--------------------------------------------------------------
"| ファイル名    |                                            |
"|---------------|---------------------------------------------
"| cp932         | 内部エンコーディングをcp932に設定。        |
"| utf-8         | 内部エンコーディングがutf-8の時、          |
"|               | 文字コードの自動認識をutf-8優先に設定。    |
"| utf-8-console | Windowsの非GUI(コンソール版)をUTF-8に設定。|
"--------------------------------------------------------------
if !has('gui_running') && s:MSWindows
  set termencoding=cp932
  "Windowsの非GUI版は内部エンコーディングをUTF-8にすると漢字入力出来ないので、
  "内部エンコーディングをcp932にする
  if filereadable(s:CFGHOME . '/utf-8-console')
    set encoding=utf-8
  else
    "強制的にcp932に変更
    set encoding=cp932
  endif
elseif filereadable(s:CFGHOME . '/cp932')
  set encoding=cp932
"elseif filereadable(s:CFGHOME . '/utf-8')
"  set encoding=utf-8
else
  "デフォルト
  set encoding=utf-8
endif

"fileencodingsをデフォルトに戻す。
if &encoding == 'utf-8'
  set fileencodings=ucs-bom,utf-8,default,latin1
elseif &encoding == 'cp932'
  set fileencodings=ucs-bom
endif

" 文字コード自動認識のためにfileencodingsを設定する
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

"utf-8優先にする
if &encoding == 'utf-8'
  if filereadable(s:CFGHOME . '/utf-8')
    let &fileencodings = substitute(&fileencodings, 'utf-8', '_utf-8', 'g')
    let &fileencodings = substitute(&fileencodings, 'cp932', 'utf-8', 'g')
    let &fileencodings = substitute(&fileencodings, '_utf-8', 'cp932', 'g')
  endif
endif

unlet s:CFGHOME
let vimrc_set_encoding = 1

" 改行コードの自動認識
"set fileformats=dos,unix,mac

if exists("loaded_ReCheckFENC")
  finish
endif
let loaded_ReCheckFENC = 1

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
      if s:MSWindows
        let &fileencoding='cp932'
      endif
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

"----------------------------------------
"メッセージの日本語化
"----------------------------------------
if has('unix')&&has('gui_running')
  let $LANG='ja'
endif

"----------------------------------------
"オプション設定
"----------------------------------------
set hidden
set number
set title
set cmdheight=2
set laststatus=2
set showcmd
set ruler
set clipboard+=unnamed
set display=lastline
set ambiwidth=double
set shellslash
set ignorecase
set smartcase
set incsearch
set wildmenu
set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif