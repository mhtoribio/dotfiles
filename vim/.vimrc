let mapleader = ","

" install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" vim-plug
call plug#begin()
" The default plugin directory is ~/.vim/plugged for linux
Plug 'vimwiki/vimwiki'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
" Set colorscheme (requires true-color to work properly)
"colorscheme nord
colorscheme gruvbox
set background=dark

" FZF configuration
map <C-p> :Files<CR>

" Relative line numbers
set relativenumber
set nu

" Tab width
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab

" Misc options
set noerrorbells
set nowrap
set nohlsearch
set incsearch
set scrolloff=8

" vimwiki configuration
let g:vimwiki_list = [{'path': '$HOME/Dropbox/vimwiki'}] " set path to a directory inside Dropbox
let g:vimwiki_ext = '.md' " set extension to .md
let g:vimwiki_global_ext = 0 " make sure vimwiki doesn't own all .md files
