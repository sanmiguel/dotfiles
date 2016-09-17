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

set title

set directory=~/.vim/backup,~/tmp,/var/tmp,/tmp

" Easier way to leave INS mode in :terminal windows
tno <silent> <Esc><Esc> <C-\><C-n>

let g:loaded_erlang_compiler = 1

" vim-airline options
set noshowmode " Disable showing editor mode - airline tells us
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#whitespace#mixed_indent_format = 'mix-i[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format = 'mix-i-file[%s]'
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
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

" System: Additional resources
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
Plug 'thinca/vim-ref'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/unite.vim'
Plug 'neomake/neomake'
"Plug 'dhruvasagar/vim-dotoo'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-fugitive' | Plug 'sanmiguel/potential-memory'

" Services: web integrations
let g:gist_get_multiplefile = 1
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'jaxbot/github-issues.vim'

" Languages: erlang
Plug 'vim-erlang/vim-erlang-runtime', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-omnicomplete', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-skeletons', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-tags', {'for': 'erlang'}
" TODO: Only including this to get the erlang_check.erl for now
Plug 'vim-erlang/vim-erlang-compiler', {'for': 'none'}

" Languages: elixir
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'slashmili/alchemist.vim', {'for': 'elixir'}

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
" This is called once, set only globals
function! s:erlang_globals()
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
    "let g:neomake_open_list = 2 " 2 = open but hold cursor pos
    " TODO Maybe we can use '%:p:h'.'/ebin' ?
    let g:neomake_erlang_flycheck_maker = {
        \ 'exe': g:plug_dir . '/vim-erlang-compiler/compiler/erlang_check.erl',
        \ 'args': ["--outdir", "ebin"],
        \ 'errorformat': '%f:%l: %tarning: %m,%f:%l: %m,%f: %m',
        \ }
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
    let g:neomake_erlang_ct_maker = {
                \ 'exe': 'rebar',
                \ 'args': ['-q', 'ct'],
                \ 'buffer_output': 1,
                \ 'append_file': 0
                \ }
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
    " let g:neomake_erlang_enabled_makers = ['flycheck', 'eunit', 'eqc', 'dialyzer']
    let g:neomake_erlang_enabled_makers = ['flycheck', 'eunit', 'eqc', 'dialyzer', 'ct1']

    " TODO Experimental vim-surround setup
    " This enables cs"- to turn "x" into <<"x">>
    let b:surround_45 = "<<\"\r\">>"
    " TODO But how to do the inverse?
endfunction

" This is called when opening every erlang file
function! s:erlang_buf_settings()
    " Determine what kind of erlang file this is:
    " .config
    " _SUITE.erl
    " _eqc.erl
    " .erl <- may have eunit tests
    let subft = "unknown"
    let fname = expand('%:t')
    " TODO Figure out something decent to do for regular erlang files
    " e.g. is it a fair assumption that for foo.erl there should be
    " foo_SUITE.erl? Maybe we can check for that, and default to nothing?
    " TODO The BufWritePost later on should only happen if this is set...
    let b:neomake_erlang_ct1_maker = {
                \ 'exe': 'rebar',
                \ 'args': ['-q', 'ct'],
                \ 'buffer_output': 1,
                \ 'append_file': 0
                \ }
    let suite=fname
    if fname =~ ".*_SUITE\.erl"
        " TODO I wonder if it's possible to have a function that searches
        " backward in the file from cursor position to find the function head
        " (when editing a _SUITE.erl) and calls 'rebar ct suite=foo case=bar'.
        let suite = substitute(fname, "_SUITE.erl", "", "")
        call add(b:neomake_erlang_ct1_maker.args, 'suite='.suite)
    elseif fname =~ "\.erl"
        let suite = substitute(fname, ".erl", "", "")
        let suitesrc = substitute(fname, ".erl", "_SUITE.erl", "")
        if filereadable("test/".suitesrc)
            call add(b:neomake_erlang_ct1_maker.args, 'suite='.suite)
        else
            unlet b:neomake_erlang_ct1_maker " TODO Re-enable
        endif
    endif
    " TODO Perhaps we should look for eunit suites that call this module?
    let eunit_efm = ''
    let eunit_efm .= '%E%m: %.%#...*failed*,'
    let eunit_efm .= '%C%>in function %m (%f\, line %l),'
    let eunit_efm .= '%Z**error,%Z**throw,%Z**exit'
    let b:neomake_erlang_eunit_maker = {
        \ 'exe': 'rebar',
        \ 'args': ['-q', 'eunit', 'skip_deps=true', 'suites=' . expand('%:t:r')],
        \ 'buffer_output': 1,
        \ 'append_file': 0,
        \ 'errorformat': eunit_efm,
        \ }
    let b:neomake_erlang_eunit_dev_maker = deepcopy(b:neomake_erlang_eunit_maker)
    let b:neomake_erlang_eunit_dev_maker.exe = 'cat'
    let b:neomake_erlang_eunit_dev_maker.args = ['rebar-out.log', 'noexist']

    set expandtab
    set shiftwidth=4
    set tabstop=4
    " TODO Some management of enabled_makers
endfunction

let s:my_erl_globals_done = 0
function! s:erlang_ft_settings()
    if !s:my_erl_globals_done
        call s:erlang_globals()
    endif
    call s:erlang_buf_settings()
    let s:my_erl_globals_done = 1
endfunction

augroup erlang
    autocmd FileType erlang call s:erlang_ft_settings()
    autocmd BufWritePost *.erl,*.hrl Neomake flycheck
    "autocmd BufWritePost *_SUITE.erl Neomake ct1
augroup END

function s:elixir_ft_setting()
    let g:neomake_open_list = 2
    " TODO Find a way to just use this from vim-elixir plugin
    let mix_test_efm =   '%E  %n) %m,'
    let mix_test_efm .=  '%+G     ** %m,'
    let mix_test_efm .=  '%+G     stacktrace:,'
    let mix_test_efm .=  '%C     %f:%l,'
    let mix_test_efm .=  '%+G       (%\\w%\\+) %f:%l: %m,'
    let mix_test_efm .=  '%+G       %f:%l: %.%#,'
    let mix_test_efm .=  '** (%\\w%\\+) %f:%l: %m'
    let g:neomake_elixir_mixtest_maker = {
        \ 'exe': 'mix',
        \ 'args': ['test'],
        \ 'append_file': 0,
        \ 'errorformat': mix_test_efm
        \ }
endfunction

augroup elixir
    autocmd FileType elixir call s:elixir_ft_setting()
    autocmd BufWritePost *.ex,*.exs Neomake mixtest
augroup END

colorscheme solarized
