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
Plugin 'tpope/vim-fugitive'
" 来自 http://vim-scripts.org/vim/scripts.html 的插件
" Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
Plugin 'L9'
" 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
Plugin 'git://git.wincent.com/command-t.git'
" 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
"Plugin 'file:///home/gmarik/path/to/plugin'
Plugin 'file:///home/cliff/cworkspace/github/YouCompleteMe'
" 插件在仓库的子目录中.
" 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
Plugin 'ascenator/L9', {'name': 'newL9'}
"Plugin 'ycmd-core/YouCompleteMe'
Plugin 'Chiel92/vim-autoformat'

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
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }
"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
"highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
"highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black



"=======================================================style==================
set statusline=[%F]%y%r%m%*%=[%l/%L,%c,%n][%p%%] "显示文件名：总行数，总的字符数
set ls=2
set nu
set fdm=indent
"set ts=4
set cursorcolumn
set cursorline
"highlight CursorLine   cterm=NONE ctermbg=darkgreen guibg=NONE guifg=NONE
"highlight CursorLine   cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
"highlight CursorColumn cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
highlight CursorLine   cterm=NONE ctermbg=darkgrey guibg=NONE guifg=NONE
highlight CursorColumn cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
highlight clear Folded
highlight clear FoldedColumn
highlight ColorColumn ctermbg=red

set hlsearch
set title
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set foldlevel=1
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
"=======================================================style==================
"
"
"
"
"
"=======================================================ctags==================
set tags=tags;
"set tags+=/usr/tags;
"set tags+=/opt/hisi-linux/x86-arm/aarch64-himix100-linux/tags;
"set tags+=/home/cliff/cworkspace/github/linuxsrc/tags;


" autocmd FileType c set omnifunc=ccomplete#Complete

"set nocp
"filetype plugin indent on
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"autocmd FileType c set omnifunc=ccomplete#Complete
"autocmd FileType cpp set omnifunc=ccomplete#Complete
"autocmd FileType go set omnifunc=ccomplete#Complete

"set completeopt=menu,longest
"let OmniCpp_MayCompleteDot=1 "打开.操作符
"let OmniCpp_MayCompleteArrow=1 "打开 -> 操作符
"let OmniCpp_MayCompleteScope=1 "打开 :: 操作符
"let OmniCpp_NamespaceSearch=1 "打开命名空间
"let OmniCpp_GlobalScopeSearch=1
"let OmniCpp_DefaultNamespace=["std"]
"let OmniCpp_ShowPrototypeInAbbr=1 "打开显示函数原型
"let OmniCpp_SelectFirstItem = 2  "自动弹出时自动跳至第一个
"let OmniCpp_GlobalScopeSearch=1
"let OmniCpp_DisplayMode=1
"let OmniCpp_DefaultNamespaces=["std"]

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
set autochdir
"let Tlist_Auto_Open=1 "打开文件时自动打开taglist
let Tlist_Exit_OnlyWindow=1 "关闭文件时自动关闭taglist
let Tlist_File_Fold_Auto_Close=1 "taglist window中折叠非当前文件
let Tlist_Process_File_Always=1 "taglist始终解析文件



"newdtree like
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:NetrwIsOpen=0

function! ToggleNetrw()
	if g:NetrwIsOpen
		let i = bufnr("$")
		while (i >= 1)
			if (getbufvar(i, "&filetype") == "netrw")
				silent exe "bwipeout " . i
			endif
			let i-=1
		endwhile
		let g:NetrwIsOpen=0
	else
		let g:NetrwIsOpen=1
		silent Vexplore
	endif
endfunction

"let g:winManagerWidth = 50
"let g:winManagerWindowLayout = "FileExplorer"
"
":autocmd [group] events pattern [nested] command
"augroup ProjectDrawer
"       autocmd!
"       autocmd VimEnter * Vexplore
"augroup END
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
"nnoremap <F12> :!ctags -R --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf . <CR>
nnoremap <silent> <F8> :TlistToggle<CR>
"nnoremap <silent> <F7> :WMToggle <CR>
nnoremap <silent> <F7> :call ToggleNetrw() <CR>

"nnoremap <C-k> :bp <CR>
"nnoremap <C-j> :bn <CR>
"nnoremap <C-i> :bdelete <CR>

nnoremap <C-i> :pc <CR>
nnoremap <C-k> :tabp <CR>
nnoremap <C-j> :tabn <CR>
nnoremap g] :pts <C-r><C-w><CR>
"nnoremap <C-]> :pt <C-r><C-w><CR>

nnoremap <leader>cc :set colorcolumn=9
"copy v mode to system clipboard
vnoremap <S-c> "+y
"ctrl-] with ts
nnoremap <leader>cc :set colorcolumn=9
nnoremap <leader>cc :set colorcolumn=9
"autoformat
nnoremap <C-l> :Autoformat <CR>

"imap { {}<ESC>i<CR><ESC>V<O
"imap { {}<ESC>i<CR><ESC>k2==o
"imap { {}<ESC>i
"imap ( ()<ESC>i
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

