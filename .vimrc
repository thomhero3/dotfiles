" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END
"Key bind
let mapleader = "\<Space>"
"make jj do esc" 
inoremap <silent> jj <Esc>l
set tags=tags;
"<Space>* によるキーバインド設定
"**************************************************
let mapleader = "\<Space>"
"--------------------------------------------------
" <Space>i でコードをインデント整形
map <Space>i gg=<S-g><C-o><C-o>zz

"--------------------------------------------------
" <Space>v で1行選択(\n含まず)
"noremap <Space>v 0v$h

"--------------------------------------------------
" <Space>d で1行削除(\n含まずに dd)
"noremap <Space>d 0v$hx

"--------------------------------------------------
" <Space>y で改行なしで1行コピー（\n を含まずに yy）
noremap <Space>y 0v$hy

"--------------------------------------------------
" <Space>s で置換
noremap <Space>s :%s/

"VimFiler起動
"noremap <Space>f :VimFiler<CR>

" neobundle settings {{{
if has('vim_starting')
  set nocompatible
  " neobundle をインストールしていない場合は自動インストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
      echo "install neobundle..."
      " vim からコマンド呼び出しているだけ neobundle.vim のクローン
      :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath の追加は必須
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" neobundle#begin - neobundle#end の間に導入するプラグインを記載します。
NeoBundleFetch 'Shougo/neobundle.vim'
" ↓こんな感じが基本の書き方
NeoBundle 'nanotech/jellybeans.vim'

NeoBundle 'Shougo/unite.vim'
" unite {{{
let g:unite_enable_start_insert=1
nmap <silent> <Space>ub :<C-u>Unite buffer<CR>
nmap <silent> <Space>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nmap <silent> <Space>ur :<C-u>Unite -buffer-name=register register<CR>
nmap <silent> <Space>um :<C-u>Unite file_mru<CR>
nmap <silent> <Space>uu :<C-u>Unite buffer file_mru<CR>
nmap <silent> <Space>ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
au FileType unite nmap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite imap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite nmap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite imap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite nmap <silent> <buffer> <ESC><ESC> q
au FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q
"}}}

"画面の横にウィンドウを作ってそこに現在開いているファイル内にある タグ一覧を表示してくれるプラグイン。 (つまり変数/関数/クラス一覧的な物を表示してくれる。) 選択して移動することも出来る。
":TagbarToggleでタグリストを新しいウィンドウで表示/非表示。
":TagbarOpen/:TagbarCloseと言った表示/非表示専用コマンドもあるが、 トグルだけで十分なのでNeoBundleLazyを使って :TagbarToggleが使われた時にロードする様に(Open/Closeコマンドもいれておいても特に問題はありませんが)。
"デフォルトのwidth=40は大きいので小さく。
"Tagbarのウィンドウでxを押すと幅を拡大出来る。
"ショートカットキーとして<Leader>tを:TagbarToggleに割り当て。
"同じ様な物に、 taglist 4 というものも有りますが、 アップデートがよりアクティブなのと、 taglistで起きる色々な不具合がtagabarでは起きない、などがあるみたいなので tagbarのが良さ気。
NeoBundleLazy "majutsushi/tagbar", {
      \ "autoload": { "commands": ["TagbarToggle"] }}
if ! empty(neobundle#get("tagbar"))
   " Width (default 40)
  let g:tagbar_width = 20
  " Map for toggle
  nn <silent> <Space>t :TagbarToggle<CR>
endif
"tagsファイルを利用してカーソル下の関数などを定義されているところを 画面下に表示してくれる
":ScrExplToggleで表示/非表示をトグル。
":ScrExpl/:ScrExplCloseで表示/非表示もできるがトグルだけで十分なので NeoBundleLazyでも:SrcExplToggleだけを指定。
"RefreshTime:カーソルを移動した際の更新時間を1秒に(デフォルト値は100ms)。
"isUpdateTags:自動的にタグをアップデートしない。
"updateTagsCmd:タグのアップデートコマンド。
"デフォルトでは
"
"let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."
"となっています。

"このコマンドはtagsファイルがあるディレクトリで実行されるので、 デフォルトだとtagsファイルのあるディレクトリ以下全てのファイルをチェックし直します。
"これだと大きいプロジェクトとかだと大変なので、%(今開いてるファイル)だけを見てアップデートする様に。
"全てをアップデートしたい時もあるので、関数を作って一時的に コマンドを入れ替えて実行出来る様にも。
"出力先のtagsファイルはその時使っているtagsファイルになります。
"winHeight:デフォルトだと8行の表示で少し小さすぎるので14行表示に。
"トグル用のショートカットは<Leader>E<CR>に。
"<Leader>Euで現ファイルのタグをアップデート。
"<Leader>Eaで全てのファイルのタグをアップデート。
"<Leader>En/pはその関数が複数の場所で定義されてる時などに 次の候補や前の候補への移動。
NeoBundleLazy "wesleyche/SrcExpl", {
      \ "autoload" : { "commands": ["SrcExplToggle"]}}
if ! empty(neobundle#get("SrcExpl"))
  " Set refresh time in ms
  let g:SrcExpl_RefreshTime = 1000
  " Is update tags when SrcExpl is opened
  let g:SrcExpl_isUpdateTags = 0
  " Tag update command
  let g:SrcExpl_updateTagsCmd = 'ctags --sort=foldcase %'
  " Update all tags
  function! g:SrcExpl_UpdateAllTags()
    let g:SrcExpl_updateTagsCmd = 'ctags --sort=foldcase -R .'
    call g:SrcExpl_UpdateTags()
    let g:SrcExpl_updateTagsCmd = 'ctags --sort=foldcase %'
  endfunction
  " Source Explorer Window Height
  let g:SrcExpl_winHeight = 14
  " Mappings
  nn [srce] <Nop>
  nm <Space>e [srce]
  nn <silent> [srce]<CR> :SrcExplToggle<CR>
  nn <silent> [srce]u :call g:SrcExpl_UpdateTags()<CR>
  nn <silent> [srce]a :call g:SrcExpl_UpdateAllTags()<CR>
  nn <silent> [srce]n :call g:SrcExpl_NextDef()<CR>
  nn <silent> [srce]p :call g:SrcExpl_PrevDef()<CR>
endif

"ファイルエクスプローラーを表示できる様になる。
":NERDTreeToggleで表示/非表示。
"こちらも:NERDTree/:NERDTreeCloseという表示/非表示コマンドもあり。
"ショートカットは<Leader>Nに。

NeoBundleLazy "scrooloose/nerdtree", {
      \ "autoload" : { "commands": ["NERDTreeToggle"] }}
if ! empty(neobundle#get("nerdtree"))
  nn <Space>N :NERDTreeToggle<CR>
endif
"Vimfiler
"<Space>fで縦分割で開閉できるように設定してみた
NeoBundleLazy 'Shougo/vimfiler', {
  \ 'depends' : ["Shougo/unite.vim"],
  \ 'autoload' : {
  \   'commands' : [ "VimFilerTab", "VimFiler", "VimFilerExplorer", "VimFilerBufferDir" ],
  \   'mappings' : ['<Plug>(vimfiler_switch)'],
  \   'explorer' : 1,
  \ }}

if ! empty(neobundle#get("nerdtree")) &&
    \! empty(neobundle#get("SrcExpl")) &&
    \! empty(neobundle#get("tagbar"))
  nn <silent> <Space>a :SrcExplToggle<CR>:NERDTreeToggle<CR>:TagbarToggle<CR>
endif
" vimfiler {{{
let g:vimfiler_as_default_explorer  = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_enable_auto_cd = 1
let g:vimfiler_ignore_pattern = "\%(\^..*\|\.pyc$\)"
let g:vimfiler_data_directory       = expand('~/.vim/etc/vimfiler')
"nnoremap <silent><C-u><C-j> :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit -toggle<CR>
nnoremap <space>f :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit -toggle<CR>
"}}}
"自動ctags作成
NeoBundle 'szw/vim-tags'
"vim-surroundはその名の通り囲んでいるものに対して操作をするプラグインです。下記のような機能があります。なおカーソルはWorldのoの位置にあると仮定します。
"コマンド	実行前	実行後
"ds"	"Hello World"	Hello world
"ds(	(Hello World)	Hello World
"ds)	(Hello World)	Hello World
"dst	<p>Hello World</p>	Hello World
"cs"'	"Hello World"	'Hello World'
"cs([	(Hello World)	[ Hello World ]
"cs(]	(Hello World)	[Hello World]
"cs)[	(Hello World)	[ Hello World ]
"cs)]	(Hello World)	[Hello World]
"cst<b>	<p>Hello World</p>	<b>Hello World</b>
"ys$"	Hello World Now	Hello W"orld Now"
"ysw'	Hello World Now	Hello W'orld' Now
"ysiw)	Hello World Now	Hello (World) Now
"yss"	Hello World Now	"Hello World Now"
NeoBundle 'tpope/vim-surround'
"テキスト整形用プラグインです。基本的には:Align 区切り文字という形で指定します。 ただし空白文字（スペース・タブ）の場合は<Leader>tspおよび<Leader>tabを使用します。
"非常に詳しく説明が書かれたページがあるので詳細はそちらを参照してください。
"高性能なテキスト整形ツールAlignの使い方
"http://nanasi.jp/vim/align.html
NeoBundle 'vim-scripts/Align'
" ファイル履歴記録 <C-u><C-u>で以前開いたファイルが表示される
NeoBundle 'Shougo/neomru.vim', {
  \ 'depends' : 'Shougo/unite.vim'
  \ }
" Gitを便利に使う
"NeoBundle 'tpope/vim-fugitive'
" figitive
" {{{
" grep検索の実行後にQuickFix Listを表示する
"autocmd QuickFixCmdPost *grep* cwindow

" ステータス行に現在のgitブランチを表示する
"set statusline+=%{fugitive#statusline()}
"}}}
" コメントON/OFFを手軽に実行
"tcomment_vimも非常に便利なプラグインです。
"Shift+Vで対象の範囲を選択し、Ctrl+-(コントロールキー+ハイフン)を2回押すだけで、その範囲をまとめてコメントアウトしたり、コメントを外したりできます。
"NeoBundle 'tomtom/tcomment_vim'

" 非同期処理
"{{{
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'windows' : 'make -f make_mingw32.mak',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \    },
  \ }
"}}}

" 補完機能
" {{{
" if has('lua') && v:version > 703 && has('patch825') 2013-07-03 14:30 > から >= に修正
" if has('lua') && v:version >= 703 && has('patch825') 2013-07-08 10:00 必要バージョンが885にアップデートされていました
if has('lua') && v:version >= 703 && has('patch885')
    NeoBundleLazy "Shougo/neocomplete.vim", {
        \ "autoload": {
        \   "insert": 1,
        \ }}
    " 2013-07-03 14:30 NeoComplCacheに合わせた
    let g:neocomplete#enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplet#enable_smart_case = 1
        " NeoCompleteを有効化
        " NeoCompleteEnable
    endfunction
else
    NeoBundleLazy "Shougo/neocomplcache.vim", {
        \ "autoload": {
        \   "insert": 1,
        \ }}
    " 2013-07-03 14:30 原因不明だがNeoComplCacheEnableコマンドが見つからないので変更
    let g:neocomplcache_enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplcache.vim")
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplcache_enable_smart_case = 1
        " NeoComplCacheを有効化
        " NeoComplCacheEnable 
    endfunction
endif

" }}}

":SyntasticCheckで文法チェック。
"チェックを行った後に:Errorsとするとquick fixでエラー一覧表示が出来る。
"g:syntastic_check_on_open = 0/g:syntastic_check_on_wq = 0:ファイルを開いた時にはチェックしない。終了時にもチェックしない。 (:wとかで保存するだけならチェックされる。)
"c/c++はデフォルトではgccでチェックする。
"g:syntastic_c_check_header/g:syntastic_cpp_check_header =1でc/c++でheaderファイルもチェックする。
"c/c++ではconfigファイルがデフォルトで読み込まれる。 (.syntastic_c_config/.syntastic_cpp_config)
"これらは現ディレクトリに無いと 上のディレクトリを探しに行って最初にあった所でそれを読み込む。
"なのでプロジェクトの一番上においておくだけでOK。
"中身には
"-I/path/to/include
"みたいなチェッカーに渡すための headerファイルの場所などを示すオプションなどを 1行に一オプションずつ書いておく。 * Configuration Files · scrooloose/syntastic Wiki

"configファイルの中で$HOMEみたいな環境変数が使えない。
"ただし、configファイルの中に相対パスを書けば configファイルがある位置からのパス、になるので、 インクルードディレクトリの指定など書きたいときは プロジェクトのトップにconfigファイルがあるならならそこから -I./.../include/と書いておけば良い。
NeoBundle "scrooloose/syntastic"
if ! empty(neobundle#get("syntastic"))
  " Disable automatic check at file open/close
  let g:syntastic_check_on_open=0
  let g:syntastic_check_on_wq=0
  " C
  let g:syntastic_c_check_header = 1
  " C++
  let g:syntastic_cpp_check_header = 1
  " Java
  let g:syntastic_java_javac_config_file_enabled = 1
  let g:syntastic_java_javac_config_file = "$HOME/.syntastic_javac_config"
endif
"スニペット補完をおこなえるようになる
"if<C-k>などは多くの言語で動作するだろう

"#:conditionで入力状態となり、<C-k>で数字順に数字:ターゲットへジャンプ(下記はvimでの実行例)
"if #:condition
"  <`0:TARGET`>
"endif

NeoBundleLazy 'Shougo/neosnippet', {
  \ 'depends' : 'Shougo/neosnippet-snippets',
  \ 'autoload' : {
  \   'insert' : 1,
  \   'filetypes' : 'snippet',
  \ }}
NeoBundle 'Shougo/neosnippet-snippets'

let g:neosnippet#data_directory     = expand('~/.vim/etc/.cache/neosnippet')
let g:neosnippet#snippets_directory = [expand('~/.vim/.bundle/neosnippet-snippets/neosnippets'),expand('~/dotfiles/snippets')]
" neosnippet {{{
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
" }}}

"NeoBundle 'vim-scripts/grep.vim'
"nnoremap <expr> <space>g ':Rgrep<CR>'
NeoBundle 'rking/ag.vim'
" カーソル位置の単語をgrep検索
nnoremap <Space>g :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
"カーソルの下にある単語をgxで調べてくれる
NeoBundle 'tyru/open-browser.vim'

"Ctrl+pで色々
NeoBundle "ctrlpvim/ctrlp.vim"
" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
" }}}

"カーソルの下にあるプログラムの単語を<Space>dでDashで調べてくれる
NeoBundle 'rizzatti/dash.vim'

" dash.vim {{{
nmap <Space>d <Plug>DashSearch
" }}}

"Vimからシェル呼び出し
NeoBundleLazy 'Shougo/vimshell', {
  \ 'depends' : 'Shougo/vimproc',
  \ 'autoload' : {
  \   'commands' : [{ 'name' : 'VimShell', 'complete' : 'customlist,vimshell#complete'},
  \                 'VimShellExecute', 'VimShellInteractive',
  \                 'VimShellTerminal', 'VimShellPop'],
  \   'mappings' : ['<Plug>(vimshell_switch)']
  \ }}

" vimshell {{{
nmap <silent> vs :<C-u>VimShell<CR>
nmap <silent> vp :<C-u>VimShellPop<CR>
" }}}

"ブラウザ
NeoBundle 'yuratomo/w3m.vim'
nnoremap <Space>w :W3mVSplit google
"括弧自動閉じ
NeoBundle 'Townk/vim-autoclose'

"文章整形プラグイン
"以下のような文章も即すっきり
"ビジュアルモードで選択して、Enter -> 整列したい文字
"ちなみに整形したい文字列が複数個ある下記のような場合は Enter -> * ->
"整列したい文字(下記例では:)
"
""整形前
"let g:jellybeans_overrides = {
"  \ 'Todo': { 'guifg': '151515', 'guibg': 'd0d033', 'ctermfg': 'Black', 'ctermbg': 'Yellow' },
"  \ 'SignColumn': { 'guifg': 'f0f0f0', 'guibg': '333333', 'ctermfg': 'Black', 'ctermbg': 'Gray' },
"  \ 'SpecialKey': { 'guifg': 'a0a000','guibg': '2c2c2c', 'ctermfg': 'Black', 'ctermbg': 'Gray' },
"  \ }

"整形後
"let g:jellybeans_overrides = {
"  \ 'Todo':       { 'guifg': '151515', 'guibg': 'd0d033', 'ctermfg': 'Black',
"  'ctermbg': 'Yellow' },
"  \ 'SignColumn': { 'guifg': 'f0f0f0', 'guibg': '333333', 'ctermfg':
"    'Black', 'ctermbg': 'Gray' },
"  \ 'SpecialKey': { 'guifg': 'a0a000','guibg':  '2c2c2c', 'ctermfg':
"      'Black', 'ctermbg': 'Gray' },
"  \ } 
NeoBundleLazy 'junegunn/vim-easy-align', {
  \ 'autoload': {
  \   'commands' : ['EasyAlign'],
  \   'mappings' : ['<Plug>(EasyAlign)'],
  \ }}


"もう完璧です。jedi-vim最強です。 使ってみればわかりますが、これ以上の機能は望めないでしょう。完璧に高速に動作します。

"さらに、なんと、このjedi-vimは補完だけではないのです。こいつが持っている機能を羅列すると
".による最高級の補完機能（もしくはCtrl-Space）
"<Leader>gで呼び出し元に飛ぶ
"<Leader>dで定義まで飛ぶ
"<Leader>rで名前変更リファクタリング
"<Leader>nで関係する変数（リファクタリング対象）を羅列
"Kでカーソル下のPydocを開く
"これだけ聞くと「なんだ他のプラグインでも聞いたことある機能だな」と思うと思いますが、完成度が違います。 いままでいくつかのプラグインを試してきましたが、たいていは予想外の動作をするため使い物になりませんでした。 しかしこのjedi-vimさんは賢い。十分使用可能なレベルでシンプルに機能してくれます。

"下記が僕の設定です。<Leader>rはquickrunと被るため大文字に変更して有ります。 また補完が最初から選択されていると使いにくいため、補完自動選択機能をオフにしてあります。 さらに関数定義がプレビューされる素晴らしい機能があるのですがウィンドウサイズがガタガタ変わるのでこれもオフにしてあります。
" 2013-07-03 14:30 書き方を思いっきり間違えていたので修正
"NeoBundleLazy "davidhalter/jedi-vim", {
"      \ "autoload": {
"      \   "filetypes": ["python", "python3", "djangohtml"],
"      \   "build": {
"      \     "mac": "pip install jedi",
"      \     "unix": "pip install jedi",
"      \   }
"      \ }}
NeoBundleLazy "davidhalter/jedi-vim", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"],
      \ },
      \ "build": {
      \   "mac": "pip install jedi",
      \   "unix": "pip install jedi",
      \ }}
let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
  " jediにvimの設定を任せると'completeopt+=preview'するので
  " 自動設定機能をOFFにし手動で設定を行う
  let g:jedi#auto_vim_configuration = 0
  " 補完の最初の項目が選択された状態だと使いにくいためオフにする
  let g:jedi#popup_select_first = 0
  " quickrunと被るため大文字に変更
  let g:jedi#rename_command = '<Leader>R'
  " gundoと被るため大文字に変更 (2013-06-24 10:00 追記）
  let g:jedi#goto_command = '<Leader>G'
endfunction
" テキストオブジェクトで置換
NeoBundle 'kana/vim-operator-replace.git'
NeoBundle 'kana/vim-operator-user.git'
"{{{ operator-replace
map R  <Plug>(operator-replace)
"}}}
" vim-easy-align {{{
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
" " }}}

NeoBundle 'rcmdnk/vim-markdown'
"" vim-markdown {{{
let g:vim_markdown_folding_disabled = 1
" }}}

"git 関係
NeoBundle 'tpope/vim-fugitive'

"ifの終了宣言を自動挿入
NeoBundleLazy 'tpope/vim-endwise', {
  \ 'autoload' : { 'insert' : 1,}} 

"普段はあまり恩恵を受けていませんが、実はVimの元に戻す・やり直す機能は他のエディタとは比べ物にならないくらい高機能です。 
"どう高機能か？に関してはgundo.vimが超便利なのとvimのアンドゥツリーについてに図解でわかりやすく乗っているのでそちらを参照してください。 
"というかリンク先にGundo.vimがいかに素晴らしいかも書いてあるので見てください。説明は他の人に任せて、下記に僕の設定を載せます。
NeoBundleLazy "sjl/gundo.vim", {
      \ "autoload": {
      \   "commands": ['GundoToggle'],
      \}}
nnoremap <Space>G :GundoToggle<CR>
"ヤンク履歴を保持してくれるやつ
"ペースト後に<C-p>か<C-n>を押してヤンク履歴をペーストできる
"いわゆるコピペ拡張
NeoBundle 'LeafCage/yankround.vim'

" yankround.vim {{{
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history = 100
nnoremap <Leader><C-p> :<C-u>Unite yankround<CR>
"}}}

"ブラウザを使ってMarkdownのプレビューを表示
NeoBundle 'kannokanno/previm'

" Vimで正しくvirtualenvを処理できるようにする
NeoBundleLazy "jmcantrell/vim-virtualenv", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}
"tagbar
"画面の横にウィンドウを作ってそこに現在開いているファイル内にある タグ一覧を表示してくれるプラグイン。 
"(つまり変数/関数/クラス一覧的な物を表示してくれる。) 選択して移動することも出来る。
NeoBundleLazy "majutsushi/tagbar", {
      \ "autoload": { "commands": ["TagbarToggle"] }}
if ! empty(neobundle#get("tagbar"))
   " Width (default 40)
  let g:tagbar_width = 20
  " Map for toggle
  nn <silent> <Space>t :TagbarToggle<CR>
endif
" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
" 基本設定　
""{{{
filetype plugin indent on
" どうせだから jellybeans カラースキーマを使ってみましょう
set t_Co=256
syntax on
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト (2013-07-03 14:30 修正）

if has("path_extra")
	set tags+=.git/tags
endif
" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    " set clipboard& clipboard+=unnamedplus " 2013-07-03 14:30 unnamed 追加
    set clipboard& clipboard+=unnamedplus,unnamed 
else
    " set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
    set clipboard& clipboard+=unnamed
endif

" Swapファイル？Backupファイル？前時代的すぎ
" なので全て無効化する
set nowritebackup
set nobackup
set noswapfile

set list                " 不可視文字の可視化
set number              " 行番号の表示
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
"set colorcolumn=80      " その代わり80文字目にラインを入れる

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell

" デフォルト不可視文字は美しくないのでUnicodeで綺麗に
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif
""}}}

"タブ関係
"{{{
"Anywhere SID.
function! s:SID_PREFIX()
	return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
nnoremap <silent> <Space>o :<C-u>Unite -vertical -no-quit outline<CR>
" Set tabline.
function! s:my_tabline()  "{{{
	let s = ''
	for i in range(1, tabpagenr('$'))
		let bufnrs = tabpagebuflist(i)
		let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
		let no = i  " display 0-origin tabpagenr.
		let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
		let title = fnamemodify(bufname(bufnr), ':t')
		let title = '[' . title . ']'
		let s .= '%'.i.'T'
		let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
		let s .= no . ':' . title
		let s .= mod
		let s .= '%#TabLineFill# '
	endfor
	let s .= '%#TabLineFill#%T%=%#TabLine#'
	return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
	execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

"}}}
" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/-vimrc-sample
""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" 各種オプションの設定
""""""""""""""""""""""""""""""
" スワップファイルは使わない(ときどき面倒な警告が出るだけで役に立ったことがない)
set noswapfile
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" コマンドラインに使われる画面上の行数
set cmdheight=2
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ステータス行に表示させる情報の指定(どこからかコピペしたので細かい意味はわかっていない)
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" ステータス行に現在のgitブランチを表示する
"set statusline+=%{fugitive#statusline()}
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" 入力中のコマンドを表示する
set showcmd
" バッファで開いているファイルのディレクトリでエクスクローラを開始する(でもエクスプローラって使ってない)
set browsedir=buffer
" 小文字のみで検索したときに大文字小文字を無視する
set smartcase
" 検索結果をハイライト表示する
set hlsearch
" 暗い背景色に合わせた配色にする
set background=dark
" タブ入力を複数の空白入力に置き換える
set expandtab
" 検索ワードの最初の文字を入力した時点で検索を開始する
set incsearch
" 保存されていないファイルがあるときでも別のファイルを開けるようにする
set hidden
" 不可視文字を表示する
set list
" タブと行の続きを可視化する
set listchars=tab:>\ ,extends:<
" 行番号を表示する
set number
" 対応する括弧やブレースを表示する
set showmatch
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
set tabstop=4
" Vimが挿入するインデントの幅
set shiftwidth=4
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" カーソル行の行番号をハイライト
set cursorline
hi clear CursorLine
" 構文毎に文字色を変化させる
set shiftwidth=4          
syntax on
" カラースキーマの指定
"colorscheme desert
colorscheme solarized
" 行番号の色
highlight LineNr ctermfg=darkyellow
""""""""""""""""""""""""""""""
" 入力モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" tagsジャンプの時に複数ある時は一覧表示                                        
nnoremap <C-]> g<C-]> 
" 矢印キーでなら行内を動けるように
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o
nnoremap っd dd
nnoremap っy yy
inoremap <silent> っj <ESC>
helptags $HOME/.vim/doc
autocmd FileType help nnoremap <buffer> q <C-w>c
