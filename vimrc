let mapleader = ","

" install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug
call plug#begin()
" The default plugin directory is ~/.vim/plugged for linux
Plug 'vimwiki/vimwiki'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
colorscheme nord

" FZF configuration
map <C-p> :Files<CR>

" vimwiki configuration
let g:vimwiki_list = [{'path': '$HOME/Dropbox/vimwiki'}] " set path to a directory inside Dropbox
let g:vimwiki_ext = '.md' " set extension to .md
let g:vimwiki_global_ext = 0 " make sure vimwiki doesn't own all .md files
