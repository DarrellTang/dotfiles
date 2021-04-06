if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'preservim/NERDTree'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/AutoComplPop'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pedrohdz/vim-yaml-folds'
call plug#end()

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:terraform_fold_sections=1

set rnu nu hlsearch ignorecase incsearch smartcase fdm=syntax nofoldenable ts=4 sw=4 complete+=kspell completeopt=menuone,longest autoread


" autocmd vimenter * NERDTree

map <C-n> :NERDTreeToggle<CR>

inoremap <expr> <C-j> pumvisible() ? "<C-n>" :"<C-j>"
inoremap <expr> <C-k> pumvisible() ? "<C-p>" : "<C-k>"

" Select the complete menu item like CTRL+y would.
inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
set rtp+=/usr/local/opt/fzf
