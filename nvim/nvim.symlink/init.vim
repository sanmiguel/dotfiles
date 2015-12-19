syntax on
set laststatus=2
set showtabline=2
set background=dark

set ignorecase
set smartcase

set clipboard+=unnamed " Copy to/paste from system clipboard

set expandtab
set tabstop=4
set shiftwidth=4

set showcmd
set showmatch

set wildmode=list:longest

set diffopt+=vertical

set completeopt+=longest

set directory=~/.vim/backup,~/tmp,/var/tmp,/tmp

let g:loaded_erlang_compiler = 1

" vim-airline options
set noshowmode " Disable showing editor mode - airline tells us
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n'  : 'N',
            \ 'i'  : 'I',
            \ 'R'  : 'R',
            \ 'c'  : 'C',
            \ 'v'  : 'V',
            \ 'V'  : 'VL',
            \ '' : 'VB',
            \ 's'  : 'S',
            \ 'S'  : 'SL',
            \ '' : 'SB',
            \ }

" Authorization data: keep this out of git!
if filereadable(glob("~/.auth.vim"))
    source ~/.auth.vim
endif

let g:gissues_lazy_load = 1

" Plugins
let g:plug_dir = expand('~/.config/nvim/plugged')
call plug#begin(g:plug_dir)

" Vim: colorschemes, themes, appearance
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'

" System: Additional resources
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
Plug 'thinca/vim-ref'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/unite.vim'
Plug 'benekastah/neomake'
"Plug 'dhruvasagar/vim-dotoo'

" Services: web integrations
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'jaxbot/github-issues.vim'

" Languages: erlang
Plug 'vim-erlang/vim-erlang-runtime', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-omnicomplete', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-skeletons', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-tags', {'for': 'erlang'}
" TODO: Only including this to get the erlang_check.erl for now
"Plug 'vim-erlang/vim-erlang-compiler', {'for': 'erlang'}

" Languages: elixir
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'sanmiguel/helpex.vim', {'for': 'elixir'}

" Languages: go
Plug 'fatih/vim-go', {'for': 'go'}

" Languages: python

call plug#end()

set formatoptions-=o
set splitright

" vim-help spelunking gold
set switchbuf+=useopen,usetab
"set switchbuf+=split " newtab overrides

" Somehow hitting <Tab> twice is less confusing than once to start
" chomping matches.
set wildmode=list:longest,list:full
set wildignorecase
set wildignore+=*.beam

" Lovingly ripped off from github.com/aerosol/dotfiles
function! s:erlang_ft_setting()
    set suffixesadd+=.erl
    set suffixesadd+=.hrl
    set suffixes+=.beam
    "" TODO These will need tweaking if it's a rebar3 project
    " The presence of multiple build dirs is troublesome (i.e. profiles)
    " but perhaps it's sufficient for 90% of cases to only include _build/dev?
    set path+=src
    set path+=deps/**
    let g:erlang_tags_ignore = ".eunit"

    " Experimental neomake/erlang options
    " TODO Need to pick up the path to this script on-the-fly
    let g:neomake_open_list = 2 " 2 = open but hold cursor pos
    let g:neomake_erlang_flycheck_maker = {
        \ 'exe': g:plug_dir . '/vim-erlang-compiler/compiler/erlang_check.erl',
        \ 'args': [],
        \ 'errorformat': '%f:%l: %tarning: %m,%f:%l: %m,%f: %m',
        \ }
    " TODO Perhaps we should look for eunit suites that call this module?

    let eunit_efm = ''
    let eunit_efm .= '%E%m: %.%#...*failed*,'
    let eunit_efm .= '%C%>in function %m (%f\, line %l),'
    let eunit_efm .= '%Z**error,%Z**throw,%Z**exit'

    " TODO This barfs on .config files because they are also ft=erlang lol
    let g:neomake_erlang_eunit_maker = {
        \ 'exe': 'rebar',
        \ 'args': ['-q', 'eunit', 'skip_deps=true', 'suites=' . expand('%:t:r')],
        \ 'buffer_output': 1,
        \ 'append_file': 0,
        \ 'errorformat': eunit_efm,
        \ }

    let g:neomake_erlang_eunit_dev_maker = deepcopy(g:neomake_erlang_eunit_maker)
    let g:neomake_erlang_eunit_dev_maker.exe = 'cat'
    let g:neomake_erlang_eunit_dev_maker.args = ['rebar-out.log', 'noexist']

    "let g:neomake_logfile = './neomake.log'

    " TODO Extend eunit maker with errorformat
    " TODO Extend eunit maker to look for tests that call this module?
    " TODO Add eqc maker
    let g:neomake_erlang_eqc_maker = {
                \ 'exe': 'rebar',
                \ 'args': ['-q', 'qc'],
                \ 'buffer_output': 1,
                \ 'append_file': 0
                \ }
    " TODO Add xref maker
    " TODO Add ct maker
    " TODO Add typer maker
    " TODO Add dialyzer maker
    let g:neomake_erlang_dialyzer_maker = {
        \ 'exe': 'make',
        \ 'args': ['dialyzer'],
        \ 'append_file': 0
        \ }

    " Run each maker in order, one at a time
    let g:neomake_serialize = 1
    " What to run when calling `:Neomake`
    " TODO This runs in alphabetical order...?
    " TODO Raise an issue
    let g:neomake_erlang_enabled_makers = ['flycheck', 'eunit', 'eqc', 'dialyzer']

    " TODO Experimental vim-surround setup
    " This enables cs"- to turn "x" into <<"x">>
    let b:surround_45 = "<<\"\r\">>"
    " TODO But how to do the inverse?

endfunction
augroup erlang
    autocmd FileType erlang call s:erlang_ft_setting()
    autocmd BufWritePost *.erl,*.hrl,*.config Neomake flycheck
augroup END
au VimEnter * :colorscheme solarized
au VimEnter * :AirlineRefresh
