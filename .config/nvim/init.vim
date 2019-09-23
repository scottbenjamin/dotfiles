set nocompatible
filetype off

" Plugins
call plug#begin()
  " Spaceline
  Plug 'taigacute/spaceline.vim'

  "Fuzzy search
  "Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  "
  " Auto completion and linting
  Plug 'neoclide/coc.nvim' , {'branch': 'release'}

  " Neoformat - https://github.com/sbdchd/neoformat
  Plug 'sbdchd/neoformat'

  " Vimdevicons
  Plug 'ryanoasis/vim-devicons'

  " Deoplete.nvim - https://github.com/Shougo/deoplete.nvim
  Plug 'Shougo/deoplete.nvim'

  if has('nvim')
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins'  }
  else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  "Utility and quality of life  
  ""========================================

  Plug 'Shougo/context_filetype.vim'

  " easymotion
  Plug 'easymotion/vim-easymotion' 
  
  "tpope plugins
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  " Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-fugitive'
  
  ""Snippets
  Plug 'SirVer/ultisnips'

  Plug 'jiangmiao/auto-pairs'

  " Startify
  Plug 'mhinz/vim-startify'

  " Easy Jump Window
  Plug 't9md/vim-choosewin'

  " Comment Plugins
  Plug 'tyru/caw.vim'

  " quickrun
  Plug 'thinca/vim-quickrun'

  " On-demand lazy load
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!']  }

  " Gruvbox Theme
  Plug 'morhetz/gruvbox'

call plug#end()

filetype plugin indent on 
" Nvim speedup startup - when using terminal only
"let did_install_default_menus = 1
"let did_install_syntax_menu = 1
set inccommand=nosplit

"Required by COC.vim
set shell=/usr/bin/zsh

" Mappings 
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
nmap <leader>b <Plug>(choosewin)

" Choosewin settings
let g:choosewin_overlay_enable = 1

" colorscheme
colorscheme gruvbox

" Indenting
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
set autoindent

" Line numbering
set number
set relativenumber

nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1

set foldmethod=marker

