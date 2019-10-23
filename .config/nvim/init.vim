set nocompatible
filetype off

" Plugins
call plug#begin()

  " Spaceline
  Plug 'taigacute/spaceline.vim'

  "Fuzzy search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  
  " Auto completion and linting
  "Plug 'neoclide/coc.nvim' , {'branch': 'release'}

  " Deoplete.nvim - https://github.com/Shougo/deoplete.nvim
  Plug 'Shougo/deoplete.nvim'

  " ALE - for all the linters
  Plug 'dense-analysis/ale'

  " Neoformat - https://github.com/sbdchd/neoformat
  Plug 'sbdchd/neoformat'

  " PearTree
  Plug 'tmsvg/pear-tree'

  " Vim Gutter
  "Plug 'airblade/vim-gitgutter'

  " Vimdevicons
  Plug 'ryanoasis/vim-devicons'

  "Utility and quality of life  
  ""========================================
  Plug 'Yggdroot/indentLine'

  Plug 'Shougo/context_filetype.vim'

  " easymotion
  Plug 'easymotion/vim-easymotion' 
  
  "tpope plugins
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-markdown'
  
  Plug 'matze/vim-move'

  ""Snippets
  Plug 'SirVer/ultisnips'

  Plug 'jiangmiao/auto-pairs'

  Plug 'mhinz/vim-grepper'

  " Startify
  Plug 'mhinz/vim-startify'

  " Easy Jump Window
  Plug 't9md/vim-choosewin'

  " Comment Plugins
"  Plug 'tyru/caw.vim'
"
  " Alignment lion
  Plug 'tommcdo/vim-lion'

  " quickrun
  Plug 'thinca/vim-quickrun'

  " Gruvbox Theme
  Plug 'morhetz/gruvbox'

call plug#end()

" Nvim speedup startup - when using terminal only
"let did_install_default_menus = 1
"let did_install_syntax_menu = 1
set inccommand=nosplit

filetype plugin indent on 

"Required by COC.vim
set shell=/usr/bin/zsh

" Mappings 
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
"nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
"nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
nmap <leader>b <Plug>(choosewin)

" Choosewin settings
let g:choosewin_overlay_enable = 1

" vim-move modifier to CTRL
let g:move_key_modifier = 'C'

" Set Terminal Colors
set termguicolors

" colorscheme
colorscheme gruvbox

" Indenting
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
set autoindent

" IndentLine Plugin
let g:indentLine_faster     = 1
let g:indentLine_setConceal = 1

" Line numbering
set number
set relativenumber

nmap s <Plug>(easymotion-overwin-f2)

let g:EasyMotion_smartcase = 1
set foldmethod=marker

