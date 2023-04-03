set nocompatible              " 去除VI一致性,必须
filetype off                  " 必须

" 设置包括vundle和初始化相关的runtime path
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" 另一种选择, 指定一个vundle安装插件的路径
"call vundle#begin('~/some/path/here')

" 让vundle管理插件版本,必须
Plugin 'VundleVim/Vundle.vim'

" 以下范例用来支持不同格式的插件安装.
" 请将安装插件的命令放在vundle#begin和vundle#end之间.
" Github上的插件
" 格式为 Plugin '用户名/插件仓库名'
"Plugin 'tpope/vim-fugitive'
" 来自 http://vim-scripts.org/vim/scripts.html 的插件
" Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
Plugin 'L9'
" 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
Plugin 'git://git.wincent.com/command-t.git'
" 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
"Plugin 'godlygeek/tabular'
"Plugin 'preservim/vim-markdown'

let g:use_ycm = 1
if get(g:, 'use_ycm', 1)
"Plugin 'file:///home/gmarik/path/to/plugin'
Plugin 'file:///home/cliff/cworkspace/github/YouCompleteMe'
endif
" 插件在仓库的子目录中.
" 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
Plugin 'ascenator/L9', {'name': 'newL9'}
"Plugin 'ycmd-core/YouCompleteMe'
Plugin 'Chiel92/vim-autoformat'
" theme
Plugin 'altercation/vim-colors-solarized'
"nerdtree
Plugin 'scrooloose/nerdtree'
"tagbar
Plugin 'majutsushi/tagbar'
"taglist
"Plugin 'vim-scripts/taglist.vim'
"vim fold
Plugin 'pseewald/vim-anyfold'
"space-vim-dark
Plugin 'liuchengxu/space-vim-dark'
" tabline
Plugin 'bling/vim-airline'

" 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
"filetype plugin on
"
" 简要帮助文档
" :PluginList       - 列出所有已配置的插件
" :PluginInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PluginClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件
"
" 查阅 :h vundle 获取更多细节和wiki以及FAQ
" 将你自己对非插件片段放在这行之后
"highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
"highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black



"=======================================================style==================
"set statusline=[%F]%y%r%m%*%=[%l/%L,%c,%n][%p%%] "显示文件名：总行数，总的字符数
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}][TYPE=%Y][POS=%l/%L,%v][%p%%][%{strftime(\"%m.%d-\%H:%M\")}]
set ls=2
set nu
"set fdm=indent
set fdm=syntax
"set ts=4
set cursorcolumn
set cursorline
set wildmenu
"highlight CursorLine   cterm=NONE ctermbg=darkgreen guibg=NONE guifg=NONE
"highlight CursorLine   cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
"highlight CursorColumn cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
"highlight CursorLine   cterm=NONE ctermbg=darkgrey guibg=NONE guifg=NONE
"highlight CursorColumn cterm=NONE ctermbg=darkgrey guibg=NONE guifg=NONE
"highlight CursorColumn cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
highlight clear Folded
highlight clear FoldedColumn

set hlsearch
set title
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set foldlevel=0
set nofoldenable
set scrolloff=999
"set sidescrolloff=999
set list lcs=tab:\¦\ 
hi Folded ctermbg=0
set ignorecase
hi MatchParen ctermbg=lightgreen ctermfg=black
set relativenumber

":set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
":set nolist
syntax on
"updatetime for auto-highlight.vim
set ut=20
"line wrap
"set nowrap
set wrap

"==============>vim-colors-solarized config
let g:solarized_termtrans = 1  "terminal background color
let g:solarized_visibility= "low" " set list
"let g:solarized_contrast = "high" " set list
"let g:solarized_italic = 1
let g:solarized_hitrail = 1
let g:solarized_termcolors=16
"let g:solarized_bold      =   1
"
"g:solarized_termcolors=   16      |   256
"g:solarized_termtrans =   0       |   1
"g:solarized_degrade   =   0       |   1
"g:solarized_bold      =   1       |   0
"g:solarized_underline =   1       |   0
"g:solarized_italic    =   1       |   0
"g:solarized_contrast  =   "normal"|   "high" or "low"
"g:solarized_visibility=   "normal"|   "high" or "low"
"g:solarized_hitrail   =   0       |   1
"g:solarized_menu      =   1       |   0

if has('gui_running')
	set background=light
else
	set background=dark
endif
"colorscheme solarized



"==============>space-vim-dark config
colorscheme space-vim-dark
hi Comment guifg=#5C6370 ctermfg=59
"hi Comment cterm=italic
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
set termguicolors




"=======================================================style==================
"
"=======================================================tabstop==================
nnoremap <leader>ts4 :set ts=4 sts=4 sw=4 expandtab <CR>
nnoremap <leader>ts8 :set ts=8 sts=8 sw=8 expandtab <CR>
nnoremap <leader>tst :set ts=8 sts=8 sw=8 noexpandtab <CR>

"=======================================================tab select=================="
function! Itab()
	call feedkeys(pumvisible() ? "\<c-n>" : "\<tab>", 'n')
	return ''
endfunction

function! Irtab()
	call feedkeys(pumvisible() ? "\<c-p>" : "\<tab>", 'n')
	return ''
endfunction

"function! Itab1()
"	let tcmd="\<tab>"
"	if len(GetPreword()) != 0 || pumvisible() != 0
"		let tcmd = "\<c-n>"
"	endif
"	call feedkeys(tcmd, 'n')
"	return ''
"endfunction
"
"function! Irtab1()
"	let tcmd=""
"	if len(GetPreword()) != 0 || pumvisible() != 0
"		let tcmd = "\<c-p>"
"	endif
"	call feedkeys(tcmd, 'n')
"	return ''
""endfunction

inoremap <tab> <c-r>=Itab()<cr>
inoremap <s-tab> <c-r>=Irtab()<cr>



"=======================================================ctags==================
set tags=tags;
nnoremap <leader>ts :ts <CR>
nnoremap <leader>tn :tn <CR>
nnoremap <leader>tp :tp <CR>
"set tags+=/usr/tags;
"set tags+=/opt/hisi-linux/x86-arm/aarch64-himix100-linux/tags;
"set tags+=/home/cliff/cworkspace/github/linuxsrc/tags;


set nocp
filetype plugin indent on
set completeopt=menuone,longest
if get(g:, 'use_ycm', 1)
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType c set omnifunc=ccomplete#Complete
	autocmd FileType cpp set omnifunc=ccomplete#Complete
	autocmd FileType go set omnifunc=ccomplete#Complete
else
	set omnifunc=syntaxcomplete#Complete
	let OmniCpp_MayCompleteDot=1 "打开.操作符
	let OmniCpp_MayCompleteArrow=1 "打开 -> 操作符
	let OmniCpp_MayCompleteScope=1 "打开 :: 操作符
	let OmniCpp_NamespaceSearch=1 "打开命名空间
	let OmniCpp_GlobalScopeSearch=1
	let OmniCpp_DefaultNamespace=["std"]
	let OmniCpp_ShowPrototypeInAbbr=1 "打开显示函数原型
	let OmniCpp_SelectFirstItem = 1  "自动弹出时自动跳至第一个
	let OmniCpp_GlobalScopeSearch=1
	let OmniCpp_DisplayMode=1
	let OmniCpp_DefaultNamespaces=["std"]
endif

"highlight Pmenu    guibg=darkgrey  guifg=black
"highlight PmenuSel guibg=lightgrey guifg=black
"=======================================================ctags==================
"
"
"
"
"
"
"
"
"
"
"=======================================================encoding==================
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
"=======================================================encoding==================
"
"
"
"
"
"
"
"
"
"=======================================================plugins==================
"set autochdir
"let Tlist_Auto_Open=1 "打开文件时自动打开taglist
"let Tlist_Exit_OnlyWindow=1 "关闭文件时自动关闭taglist
"let Tlist_File_Fold_Auto_Close=1 "taglist window中折叠非当前文件
"let Tlist_Process_File_Always=1 "taglist始终解析文件

"==============>newdtree config
let NERDTreeHighlightCursorline = 0       " 高亮当前行
let NERDTreeMinimalUI=0
let NERDTreeMapJumpNextSibling=''
let NERDTreeMapJumpPrevSibling=''
let NERDTreeShowLineNumbers     = 1       " 显示行号
" 忽略列表中的文件
"let NERDTreeIgnore = [ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.egg$', '^\.git$', '^\.repo$', '^\.svn$', '^\.hg$' ]
" 启动 vim 时打开 NERDTree
"autocmd vimenter * NERDTree
" 当打开 VIM，没有指定文件时和打开一个目录时，打开 NERDTree
"autocmd StdinReadPre * let s:std_in = 1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" 关闭 NERDTree，当没有文件打开的时候
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end

" <leader>nt 打开 nerdtree 窗口，在左侧栏显示
"map <leader>nt :NERDTreeToggle<CR>



"==============>newdtree like config
"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 3
"let g:netrw_altv = 1
"let g:netrw_winsize = 20
"let g:NetrwIsOpen=0
"
"function! ToggleNetrw()
"	if g:NetrwIsOpen
"		let i = bufnr("$")
"		while (i >= 1)
"			if (getbufvar(i, "&filetype") == "netrw")
"				silent exe "bwipeout " . i
"			endif
"			let i-=1
"		endwhile
"		let g:NetrwIsOpen=0
"	else
"		let g:NetrwIsOpen=1
"		silent Vexplore
"	endif
"endfunction

"let g:winManagerWidth = 50
"let g:winManagerWindowLayout = "FileExplorer"
"
":autocmd [group] events pattern [nested] command
"augroup ProjectDrawer
"       autocmd!
"       autocmd VimEnter * Vexplore
"augroup END
"
"
"


"==============>python  config
let g:ycm_python_interpreter_path = '/home/cliff/pyenv/env38/bin/python'
let g:ycm_python_sys_path = ['/home/cliff/pyenv/env38/lib/python3.8']
let g:ycm_extra_conf_vim_data = [
			\ 'g:ycm_python_interpreter_path',
			\ 'g:ycm_python_sys_path'
			\ ]

"==============>ycm config
"let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_semantic_triggers =  {
			\ 'asm,c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }
let g:ycm_confirm_extra_conf = 0
let g:ycm_min_num_of_chars_for_completion               = 1 " 输入第 2 个字符开始补全
let g:ycm_seed_identifiers_with_syntax                  = 1 " 语法关键字补全
let g:ycm_complete_in_comments                          = 1 " 在注释中也可以补全
let g:ycm_complete_in_strings                           = 1 " 在字符串输入中也能补全
let g:ycm_collect_identifiers_from_tags_files            = 1 " 使用 ctags 生成的 tags 文件
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释和字符串中的文字也会被收入补全
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '⚠'
let g:ycm_add_preview_to_completeopt = 0
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_autoclose_preview_window_after_completion = 1

"let g:ycm_cache_omnifunc                                = 0 " 每次重新生成匹配项，禁止缓存匹配项
"let g:ycm_use_ultisnips_completer                       = 0 " 不查询 ultisnips 提供的代码模板补全，如果需要，设置成 1 即可
"let g:ycm_show_diagnostics_ui                           = 0 " 禁用语法检查
"let g:ycm_key_list_select_completion   = ['<Down>']   " 选择下一条补全，Default: ['<TAB>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<Up>']     " 选择上一条补全，Default: ['<S-TAB>', '<Up>']
"let g:ycm_key_list_stop_completion     = ['<Enter>']  " 中止此次补全，Default: ['<C-y>']
"
"==============>tagbar config

let g:tagbar_ctags_bin = 'ctags' " tagbar 依赖 ctags 插件
let g:tagbar_width     = 30      " 设置 tagbar 的宽度为 30 列，默认 40 列
let g:tagbar_autofocus = 2       " 打开 tagbar 时光标在 tagbar 页面内，默认在 vim 打开的文件内
"let g:tagbar_left      = 1       " 让 tagbar 在页面左侧显示，默认右边
"let g:tagbar_position = 'leftabove'
let g:tagbar_sort      = 0       " 标签不排序，默认排序
let g:tagbar_compact = 1
let g:tagbar_autopreview = 0
let g:tagbar_show_tag_linenumbers=2
"let g:tagbar_expand = 1

"autocmd VimEnter * nested :call tagbar#autoopen(1)
"autocmd BufEnter * nested :silent TagbarOpen
"autocmd FileType vim,make,sh,go,asm,python,js,c,cpp nested :TagbarOpen

" <leader>tb 打开 tagbar 窗口，在左侧栏显示

"
"==============>taglist config
let Tlist_Show_One_File           = 1    " 只显示当前文件的tags
let Tlist_GainFocus_On_ToggleOpen = 1    " 打开 Tlist 窗口时，光标跳到 Tlist 窗口
let Tlist_Exit_OnlyWindow         = 1    " 如果 Tlist 窗口是最后一个窗口则退出 Vim
let Tlist_Use_Left_Window         = 1    " 在左侧窗口中显示
let Tlist_File_Fold_Auto_Close    = 0    " 自动折叠
let Tlist_Auto_Update             = 1    " 自动更新
" <leader>tl 打开 Tlist 窗口，在左侧栏显示
nnoremap <leader>tl :TlistToggle <CR>

"==============>vim-anyfold config
autocmd bufenter * AnyFoldActivate
let g:anyfold_fold_comments=1
set foldlevel=0
hi folded term=None cterm=None

"==============>vim-airline config
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
"
"=======================================================plugins==================
"
"
"
"
"
"
"
"
"
"=======================================================map==================
"nnoremap <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"nnoremap <F12> :!ctags --languages=Asm,c,c++,java,go,Make,sh -R . <CR>"
"nnoremap <F12> :!ctags -R --languages=Asm,c,c++,java,go,Make,sh --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf . <CR>
nnoremap <F12> :!ctags -R --languages=Asm,c,c++,go,Make,sh --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf `pwd` <CR>
nnoremap <leader>act :!ctags -R --languages=Asm,c,c++,go,Make,sh --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf `pwd` <CR>
nnoremap <leader>ct :!ctags -R --languages=Asm,c,c++,go,Make,sh --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf <CR>
"nnoremap <F12> :!ctags -R --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf . <CR>
"nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>
nnoremap <leader>tb :TagbarToggle<CR>
"nnoremap <silent> <F7> :WMToggle <CR>
"nnoremap <silent> <F7> :call ToggleNetrw() <CR>
nnoremap <silent> <F7> :NERDTreeToggle <CR>
nnoremap <leader>nt :NERDTreeToggle <CR>

"nnoremap <C-k> :bp <CR>
"nnoremap <C-j> :bn <CR>
"nnoremap <C-i> :bdelete <CR>

nnoremap <C-i> :tabc <CR>
nnoremap <C-k> :tabp <CR>
nnoremap <C-j> :tabn <CR>
nnoremap g] :pts <C-r><C-w><CR>
"nnoremap <C-]> :pt <C-r><C-w><CR>

nnoremap <leader>cc :set colorcolumn=9
"copy v mode to system clipboard
vnoremap <S-c> "+y
vnoremap <leader>c :<C-U>!echo '<c-r>=GetVisualSelection()<cr>' \| xclip <CR>
nnoremap <leader>v :r!xclip -o <CR>
vnoremap <leader>cf :<C-U>!echo -n '<c-r>=GetVisualSelection()<cr>' > ~/.vim.cf <CR>
nnoremap <leader>cv :r!cat ~/.vim.cf <CR>
"ctrl-] with ts
nnoremap <leader>cc :set colorcolumn=9

"nnoremap <leader>gp :!echo -n grep : && read key_s && grep -rni "${key_s}" \| highlight -O ansi --syntax c \| less -N -r -I -p "${key_s}" <CR><CR>
nnoremap <leader>gp :!echo [grep]:<c-r>=GetCurword()<cr> && read key_s && [ -z $key_s ] && key_s=<c-r>=GetCurword()<cr>; grep --color=always -rni "${key_s}" 2>/dev/null \| less -R <CR><CR>
nnoremap <leader>fd :!echo [find]:<c-r>=GetCurword()<cr> && read key_s && [ -z $key_s ] && key_s=<c-r>=GetCurword()<cr>; find \| grep --color=always "${key_s}" 2>/dev/null \| less -R<CR><CR>

"autoformat
nnoremap <C-l> :Autoformat <CR>

nnoremap <leader>gd :YcmCompleter GoToDefinition <CR>
nnoremap <leader>gr :YcmCompleter GoToReferences <CR>
"ycm diagnose
nnoremap <leader>e :YcmDiags <CR>
nnoremap <leader>ce :lclose <CR>

"beautify trail
nnoremap <leader>tr / \+$<CR>
nnoremap <leader>td :%s/ \+$//g<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>aq :qa!<CR>
nnoremap <leader>w :w!<CR>
nnoremap <leader>r :redraw!<CR>
nnoremap <leader>sv :source ~/.vimrc<CR>

"tab -> 4space
nnoremap <leader>hr :%s/\t/    /g<CR>
inoremap { {}<ESC>i
inoremap [ []<ESC>i
inoremap ( ()<ESC>i
inoremap " ""<ESC>i
inoremap ' ''<ESC>i

"insert template ==============================
function! GetFileHeaderName()
	let filename=expand("%:t")
	let filename=toupper(filename)
	let ret=substitute(filename, '\.', '_', 'g')
	let ret="__".ret."__"
	return ret
endfunction
function! GetFileOriginName()
	return expand("%:t")
endfunction

function! GetTime()
	return strftime("%Y-%m-%d %H:%M:%S")
endfunction

function! GetCurword()
	return expand('<cword>')
endfunction

function! GetPreword()
	let line = getline('.')
	let substr = strpart(line, -1, col('.')+1)
	let substr = matchstr(substr, "[^ \t]*$")
	return substr
endfunction

"/*******************************************************************************************/
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
"/*******************************************************************************************/


"insert comment line
inoremap <leader>li /*******************************************************************************************/
"insert sign header
inoremap <leader>si /* ********************************************************************************<cr>
			\FILE NAME   : <c-r>=GetFileOriginName()<cr><cr>
			\PROGRAMMER  : zhaozz<cr>
			\DESCRIPTION : ???<cr>
			\DATE        : <c-r>=GetTime()<cr><cr>
			\*******************************************************************************/<cr><ESC>3k4w

inoremap <leader>for for (;;) {<cr><cr>}<ESC>2kw
inoremap <leader>if if () {<cr><cr>} else {<cr><cr>}<ESC>4kw
inoremap <leader>el else if () {<cr><cr>}<ESC>2k2w
inoremap <leader>ff #ifndef  <c-r>=GetFileHeaderName()<cr><cr>#define  <c-r>=GetFileHeaderName()<cr><cr><cr>#endif  /* <c-r>=GetFileHeaderName()<cr> */<ESC>k

"insert template ============================== end

"make cflow
"nnoremap <leader>cf :!cflow -bnT -f posix *.c  \| highlight -O ansi --syntax c \| less -r -I<CR>
nnoremap <leader>cfr :!for f in `find -type f\| grep -E '\.c$\|\.h$'`; do echo ===========$f; cflow -nT -i_st -f posix $f 2>/dev/null; done \| less -R -I<CR>
nnoremap <leader>cfa :!cflow -nT -i_st -f posix `find -type f 2>/dev/null \| grep -E '\.h\$\|\.c\$' 2>/dev/null` \| less -R -I<CR>
nnoremap <leader>cfar :!cflow -rnT -i_st -f posix `find -type f 2>/dev/null \| grep -E '\.h\$\|\.c\$' 2>/dev/null` \| less -R -I<CR>

nnoremap <leader>cfrc :!for f in `find -type f\| grep -E '\.c$\|\.h$'`; do echo ===========$f; cflow -nT -i_st -f posix $f 2>/dev/null; done \| highlight -O ansi --syntax c \| less -R -I<CR>
nnoremap <leader>cfac :!cflow -nT -i_st -f posix `find -type f 2>/dev/null \| grep -E '\.h\$\|\.c\$' 2>/dev/null` \| highlight -O ansi --syntax c \| less -R -I<CR>
nnoremap <leader>cfarc :!cflow -rnT -i_st -f posix `find -type f 2>/dev/null \| grep -E '\.h\$\|\.c\$' 2>/dev/null` \| highlight -O ansi --syntax c \| less -R -I<CR>

"pycflow2dot
nnoremap <leader>cfpng :!cflow2dot --merge -f png -i $(echo `find -type f \| grep -Ei '\.c$\|\.h$\|\.s$'`) -o $(basename `pwd`) && rm $(basename `pwd`).dot <CR>
nnoremap <leader>cfpdf :!cflow2dot --merge -f pdf -i $(echo `find -type f \| grep -Ei '\.c$\|\.h$\|\.s$'`) -o $(basename `pwd`) && rm $(basename `pwd`).dot <CR>
nnoremap <leader>cff :!echo -n 'input filename:' && read tmp_f && cflow2dot --merge -f pdf -i ${tmp_f} -o ${tmp_f} && rm ${tmp_f}.dot <CR>
nnoremap <leader>cfdpdf :!(for cur_f in `find -type f \| grep -Ei '\.c$\|\.h$\|\.s$'`; do echo ================${cur_f} && cd `dirname $cur_f` ; cur_f_name=`basename ${cur_f}` && cflow2dot --merge -f pdf -i ${cur_f_name} -o ${cur_f_name} && rm ${cur_f_name}.dot; cd -; done) <CR>
nnoremap <leader>cfdpng :!(for cur_f in `find -type f \| grep -Ei '\.c$\|\.h$\|\.s$'`; do echo ================${cur_f} && cd `dirname $cur_f` ; cur_f_name=`basename ${cur_f}` && cflow2dot --merge -f png -i ${cur_f_name} -o ${cur_f_name} && rm ${cur_f_name}.dot; cd -; done) <CR>

"close previewpopup window
"set previewpopup=height:5,width:100
set previewheight=17
nnoremap <leader>cp :pc <CR>
"=======================================================map==================



"=======================================================notes==================
"整行补全                        CTRL-X CTRL-L
"根据当前文件里关键字补全        CTRL-X CTRL-N
"根据字典补全                    CTRL-X CTRL-K
"根据同义词字典补全              CTRL-X CTRL-T
"根据头文件内关键字补全          CTRL-X CTRL-I
"根据标签补全                    CTRL-X CTRL-]
"补全文件名                      CTRL-X CTRL-F
"补全宏定义                      CTRL-X CTRL-D
"补全vim命令                     CTRL-X CTRL-V
"用户自定义补全方式              CTRL-X CTRL-U
"拼写建议                        CTRL-X CTRL-S
"=======================================================notes==================
"
"
"

