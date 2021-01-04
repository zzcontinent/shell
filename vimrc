" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
" if has("autocmd")
"  filetype plugin indent on
" endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
"set nowrap

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"=======================================================style==================
set statusline=[%F]%y%r%m%*%=[%l/%L,%c,%n][%p%%] "显示文件名：总行数，总的字符数
set ls=2
set nu
set fdm=indent
"set ts=4
set cursorcolumn
set cursorline
"highlight CursorLine   cterm=NONE ctermbg=darkgreen guibg=NONE guifg=NONE
highlight CursorLine   cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
highlight CursorColumn cterm=NONE ctermbg=darkmagenta guibg=NONE guifg=NONE
"highlight CursorLine   cterm=NONE ctermbg=darkgrey guibg=NONE guifg=NONE
"highlight CursorColumn cterm=NONE ctermbg=darkgrey guibg=NONE guifg=NONE
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
set scrolloff=9999
"set sidescrolloff=999
set list lcs=tab:\¦\ 
set list lcs+=trail:\␣
hi Folded ctermbg=0
set ignorecase
hi MatchParen ctermbg=lightgreen ctermfg=black
"set relativenumber

"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
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

set nocp
filetype plugin indent on
"autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType cpp set omnifunc=ccomplete#Complete
autocmd FileType go set omnifunc=ccomplete#Complete

set completeopt=menu,longest
let OmniCpp_MayCompleteDot=1 "打开.操作符
let OmniCpp_MayCompleteArrow=1 "打开 -> 操作符
let OmniCpp_MayCompleteScope=1 "打开 :: 操作符
let OmniCpp_NamespaceSearch=1 "打开命名空间
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DefaultNamespace=["std"]
let OmniCpp_ShowPrototypeInAbbr=1 "打开显示函数原型
let OmniCpp_SelectFirstItem = 2  "自动弹出时自动跳至第一个
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1
let OmniCpp_DefaultNamespaces=["std"]

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
let g:netrw_browse_split = 0
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
"	autocmd!
"	autocmd VimEnter * Vexplore
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
"nnoremap <silent> <F3> :vimgrep /<C-R><C-W>/g ** <CR>:cw<CR>
nnoremap <silent> <F3> :!read key_s && grep --color=always -rni "${key_s}" \| less -N -r -I -p "${key_s}" <CR><CR>

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
