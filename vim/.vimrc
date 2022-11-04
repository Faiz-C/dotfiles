set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/share/powerline/bindings/vim/
set laststatus=2
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Vimtex for latex documents
Plugin 'lervag/vimtex'

" Theme I like
Plugin 'haishanh/night-owl.vim'

" Powerline
Plugin 'powerline/powerline' 

call vundle#end()            " required
filetype plugin indent on    " required

" For the night-owl theme
if (has("termguicolors"))
  set termguicolors
endif

" For night-owl theme 
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" TABS
set tabstop=2
set shiftwidth=2
set softtabstop=2

set expandtab
set noshiftround

" LINE NUMBERS
set number

syntax enable
colorscheme night-owl

" Powerline
set t_Co=256

set guifont=Hermit\ Nerd\ Font\ 12

let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0B6"


" Latex stuff
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_FormatDependency_dvi = 'dvi,ps,pdf'
let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:latex_view_general_viewer = 'zathura'

" Extra stuff for me to remember
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
