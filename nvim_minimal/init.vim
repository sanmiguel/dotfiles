set laststatus=2       " Always show the statusline under the bottom buffers
set showtabline=2      " Always show the tabline at the top of the window
set mouse=a            " Allow mouse/trackpad control in all modes
set clipboard+=unnamed " Use the system clipboard for yank/paste operations

set ignorecase  " Case-insensitive search by default
set smartcase   " :h smartcase
" if you want to case-sensitive search for an all-lowercase term,
" prepend your search pattern with '\C' e.g.
" /\Csensible

set showcmd    " Display some info about current command in bottom line
set showmatch  " Display matching parens (if on-screen)

set number     " Display line numbers

" 'wildmode' affects tab-completion in commands
set wildmode=list:longest,list:full
set wildignorecase " Ignore case when tab-completing a wildcard
set wildignore+=.beam " When tab-completing filenames, ignore .beam

" 'completeopt' affects the completion engine
" see :h 'ins-completion'
set completeopt+=longest

set title " Set the window title automatically

set directory=~/.cache/nvim,/tmp " Where nvim will put swap files

set diffopt+=vertical " Default diff split to vertical

" More obvious way to leave INS-mode in a :terminal buffer
tno <silent> <Esc><Esc> <C-\><C-n>

set expandtab " Because we are not animals
set tabstop=4 " How many spaces displayed for a tab
set shiftwidth=4 " How many spaces for each (auto)indent

" Authorization data: keep this out of git!
if filereadable(glob("~/.auth.vim"))
    source ~/.auth.vim
endif

set termguicolors   " Use 24-bit colour where possible
set background=dark " Use a dark background (some colorschemes obey this)
colorscheme NeoSolarized

" Plugins: https://github.com/junegunn/vim-plug#installation
let g:plug_dir = expand('~/.config/nvim/plugged')
call plug#begin(g:plug_dir)
" Appearance: colours etc
Plug 'iCyMind/NeoSolarized'
" Fancy status lines (see 'g:airline_*' settings below)
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

" System: External resources
Plug 'tpope/vim-fugitive'     " :h fugitive
Plug 'airblade/vim-gitgutter' " :h GitGutter
Plug 'mileszs/ack.vim' " :h ack | Can be configured for grep, ag, ack
Plug 'thinca/vim-ref'  " :h ref-introduction
		       " e.g. :Ref erlang lists:foldl

Plug 'neomake/neomake' " :h neomake-contents

" System: Additional controls
Plug 'tpope/vim-unimpaired' " :help unimpaired
Plug 'tpope/vim-surround'   " :help surround
" quickmenu does nothing without configuration, which we'll do later
Plug 'skywind3000/quickmenu.vim'

" Language: erlang
Plug 'vim-erlang/vim-erlang-runtime', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-omnicomplete', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-skeletons', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-tags', {'for': 'erlang'}
Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}
Plug 'vim-scripts/argtextobj.vim'
" TODO: Only including this to get the erlang_check.erl for now
Plug 'vim-erlang/vim-erlang-compiler', {'for': 'none'}

" Language: elixir
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'slashmili/alchemist.vim', {'for': 'elixir'}

call plug#end()

let g:airline_powerline_fonts=1
let g:airline_theme = 'solarized'
