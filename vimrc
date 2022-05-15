let mapleader = "\<space>" 	"设置空格键为mapleader键	
packloadall			"加载所有插件		
silent! helptags ALL		"加载插件的帮助文档
set foldmethod=indent		"基于缩进折叠代码
set nocompatible		"使用vim的高级功能，建议开启，不然就是vi
filetype plugin on		"识别文件类型
let NERDTreeHijackNetrw = 0	
set nu
"set hls			
set incsearch			
syntax on
set history=100
set autoindent	"开始新行时自动处理缩进
set expandtab	"将制表符tab展开为空格
set tabstop=4	"设置制表符为4个空格的宽度
set shiftwidth=4	"自动缩进的空格数


inoremap ' ''<esc>i
inoremap " ""<esc>i
inoremap ( ()<esc>i
inoremap { {}<esc>i
inoremap [ []<esc>i
inoremap < <><esc>i
"inoremap / //<esc>i
"inoremap * **<esc>i

noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

"nerdtree
noremap <leader>n :NERDTreeToggle<cr>	
let NERDTreeShowBookmarks = 1     "启动nerdtree时显示书签
"autocmd VimEnter * NERDTree       "vim启动时打开nerdtree
"当nerdtree是最后一个窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&
  \ b:NERDTree.isTabTree()) | q | endif

"quickfix
"autocmd VimEnter *  :copen  "vim启动时自动打开quickfix
noremap <leader>o :copen<cr>
noremap <leader>c :cclose<cr>

"easymotion
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><leader>h <Plug>(easymotion-linebackward)
map <Leader><leader>l <Plug>(easymotion-lineforward)
map <Leader><leader>. <Plug>(easymotion-repeat)

"fzf
noremap <leader>f :FZF<cr>

"gundo
"noremap <leader>u :GundoToggle<cr>

"ctags，设置更改源文件时自动更新
set tags=tags;
autocmd BufWritePost *.S *.c *.h silent! !ctags -R &

"tagbar
let g:tarbar_width=25
"autocmd BufReadPost *.cpp,*.c,*.h,*.cc,*.cxx,*.S call tagbar#autoopen() "读取这些源文件时自动打开tagbar
noremap <leader>t :TagbarToggle<cr>	"有点慢

"vim-gutentags，ctags自动更新相关
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

"cscope
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=1
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	endif
	set csverb
endif

:set cscopequickfix=s-,c-,d-,i-,t-,e-

"F5查找c语言符号，s=symbol
"F6查找字符串，t=text
"F7查找调用这个变量或函数的地方，c=call
nmap <silent> <F5> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <F6> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <F7> :cs find c <C-R>=expand("<cword>")<CR><CR>


"使用vim-plug管理插件,执行:PlugInstall后会安装到~./vim/plugged中，并且会自动加载
"call plug#begin()

"Plug 'preservim/nerdtree' 

"call plug#end()

"手工安装插件到~./vim/pack/plugins/start
" nerdtree -- https://github.com/preservim/nerdtree
" vim-unimpaired -- https://github.com/tpope/vim-unimpaired
" ctrlp.vim -- https://github.com/ctrlpvim/ctrlp.vim
" vim-easymotion -- https://github.com/easymotion/vim-easymotion
" fzf -- https://github.com/junegunn/fzf.git
" fzf.vim -- https://github.com/junegunn/fzf.vim.git
" tagbar -- https://github.com/preservim/tagbar.git
" vim-gutentags -- https://github.com/ludovicchabant/vim-gutentags.git
" vim-vinegar -- https://github.com/tpope/vim-vinegar.git
" YouCompleteMe -- https://github.com/Valloric/YouCompleteMe.git
    "1. 升级vim到8.1以上
        "sudo add-apt-repository ppa:jonathonf/vim
        "sudo apt-get update
        "sudo apt-get install vim
    "2. 升级c++17
        "sudo apt-get install g++-8
        "sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 \
        "700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
        "sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 \
        "800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
    "3. 升级cmake
        "sudo apt-get autoremove cmake
        "cd ~/Downloads
        "wget https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0.tar.gz
        "tar -zxvf cmake-3.16.0.tar.gz
        "cd cmake-3.16.0
        "apt install libssl-dev build-essential
        "./bootstrap && make && sudo make install
    "4. 安装YouCompleteMe
        "cd ~/.vim/pack/plugins/start/YouCompleteMe
        "git submodule update --init --recursive
        "python3 install.py --clangd-completer

"有两个插件用apt安装
"ctags -- sudo apt-get install ctags
"cscope -- sudo apt-get install cscope
