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

set number

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

function! s:airline_seps(...)
    let lr_pairs = {
        \ 'arrow-solid':     ['', ''],
        \ 'arrow-line':      ['' ,''],
        \ 'round-solid':     ['', ''],
        \ 'round-line':      ['', ''],
        \ 'downslope-solid': ['', ''],
        \ 'downslope-line':  ['', ''],
        \ 'upslope-solid':   ['', ''],
        \ 'upslope-line':    ['', ''],
        \ 'flame-solid':     ['', ''],
        \ 'flame-line':      ['', ''],
        \ 'matrix-small':    ['', ''],
        \ 'matrix-large':    ['', ''],
        \ 'jaws':            ['', '']
        \}                     
    let singles = {
        \ 'branch': '',
        \ 'linenr': '',
        \ 'lock'  : '',
        \ 'count' : '',
        \ 'inferno-left':  '',
        \ 'hexagon-solid': '',
        \ 'hexagon-line': '',
        \ 'lego-sideways-oblique': '',
        \ 'lego-upwards-oblique': '',
        \ 'lego-top': '',
        \ 'lego-side': ''
        \ }
    let sep = 'matrix-large'
    if a:0
        let sep = a:1
    endif
    let [g:airline_left_sep, g:airline_right_sep] = get(lr_pairs, sep)
endfunction
call s:airline_seps()

command! -nargs=1 SetAirlineSep call s:airline_seps(<f-args>)

let g:airline#extensions#neomake#jobs_symbol = ''
let g:airline#extensions#neomake#error_symbol = ''
let g:airline#extensions#neomake#warning_symbol = ''
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
Plug 'iCyMind/NeoSolarized'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

" System: Additional resources
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
Plug 'thinca/vim-ref'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/unite.vim'
Plug 'neomake/neomake'
"let g:neomake_error_sign = {
"            \ 'text': '',
"            \ 'texthl': 'NeomakeErrorSign'
"            \ }
"let g:neomake_warning_sign = {
"            \ 'text': '',
"            \ 'texthl': 'NeomakeWarningSign'
"            \ }
"Plug 'dhruvasagar/vim-dotoo'
"Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
"Plug 'tpope/vim-fugitive' | Plug 'sanmiguel/potential-memory'

" TODO: Try these out, from this list: https://github.com/neovim/neovim/wiki/Related-projects#plugins
" Plug 'c0r73x/neotags.nvim'
" Plug 'kassio/neoterm' " Maybe for running tests?
" Plug 'tek/proteome.nvim' " Project management
" Plug 'pgdouyon/vim-accio' " Possible neomake replacement
" Plug 'mhinz/vim-grepper' " :Ack replacement?
" Plug 'janko-m/vim-test' " Probably requires extending for erlang?
" Plug 'jalvesaq/vimcmdline' " Maybe a way to interact with a node easily?
" Plug 'eugen0329/vim-esearch' " For interactive find/replace, refactoring
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Services: web integrations
let g:gist_get_multiplefile = 1
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'jaxbot/github-issues.vim'

let g:todoist_api_token = "~/.config/todoist/api.token"
Plug '~/git/sanmiguel/todoist.vim' ", {'do': ''}  Need to install the python lib

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
    set suffixes+=.beam
    "" TODO These will need tweaking if it's a rebar3 project
    " The presence of multiple build dirs is troublesome (i.e. profiles)
    " but perhaps it's sufficient for 90% of cases to only include _build/dev?
    set path+=src
    set path+=deps/**
    let g:erlang_tags_ignore = [ ".eunit", ".qc", "logs" ]

    " Experimental neomake/erlang options

    " Enable this to have neomake log its actions:
    "let g:neomake_logfile = './neomake.log'

    " Control how neomake uses the loclist:
    " 0 = do not open
    " 1 = open and jump to first
    " 2 = open but hold cursor pos
    let g:neomake_open_list = 2

    " TODO Extend eunit maker with errorformat
    " TODO Extend eunit maker to look for tests that call this module?
    " TODO Add eqc maker
    let g:neomake_erlang_eunit_maker = {
                \ 'exe': 'rebar',
                \ 'args': ['eunit'],
                \ 'append_file': 0
                \}
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
    let g:neomake_erlang_flycheck_maker = {
        \ 'exe': g:plug_dir . '/vim-erlang-compiler/compiler/erlang_check.erl',
        \ 'args': [],
        \ 'errorformat': '%f:%l: %tarning: %m,%f:%l: %m,%f: %m',
        \ }
    let g:neomake_erlang_flycheck_args = ['--outdir', 'ebin', '--load', 'longnames', 'foo@127.0.0.1', 'dev1@127.0.0.1', '--cookie', 'riak']

    " Run each maker in order, one at a time
    let g:neomake_serialize = 1
    " What to run when calling `:Neomake`
    " let g:neomake_erlang_enabled_makers = ['flycheck', 'eunit', 'eqc', 'dialyzer']
    let g:neomake_erlang_enabled_makers = ['flycheck', 'eunit', 'ct', 'eqc', 'dialyzer']

    " TODO Experimental vim-surround setup
    " This enables cs"- to turn "x" into <<"x">>
    let b:surround_45 = "<<\"\r\">>"
    " TODO But how to do the inverse?
endfunction

function! s:find_erlang_project_type()
    " Figure out what kind of erlang project this is based on what files we
    " find:
    " [./rebar3 , rebar.config, rebar.lock] -> rebar3
    " [./rebar, rebar.config, rebar.config.lock] -> rebar
    " Otherwise, do not set anything else custom for erlang (!!)
    if filereadable("rebar.config")
        " rebar, but 2 or 3?
        if filereadable("./rebar3")
            return ["rebar3", "./rebar3"]
        elseif filereadable("./rebar")
            return ["rebar", "./rebar"]
        elseif filereadable("./rebar.lock")
            return ["rebar3", "rebar3"]
        elseif filereadable("./rebar.config.lock")
            return ["rebar", "rebar"]
        else
            " TODO This should ultimately change to "rebar3" by default
            return ["rebar", "rebar"]
        endif
    endif
    " TODO Failsafe for e.g. standalone scripts
    return ["unknown", ""]
endfunction

" This is called when opening every erlang file
function! s:erlang_buf_settings()
    set suffixesadd+=.erl
    set suffixesadd+=.hrl
    " Determine what kind of erlang file this is:
    " .config
    " _SUITE.erl
    " _eqc.erl
    " _tests.erl
    " .erl <- may have eunit tests
    let fname = expand('%:t')

    " FIXME Re-enable this to get re-compiled artifacts in ebin
    " let b:neomake_erlang_flycheck_args = ["--outdir", expand('%:p:h:h')."/ebin"],

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
        let b:neomake_erlang_ct_args = deepcopy(g:neomake_erlang_ct_maker.args)
        call add(b:neomake_erlang_ct_args, 'suite='.suite)
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

    " TODO Some management of enabled_makers
endfunction

function! s:erlang_ft_settings()
    if !exists('s:my_erl_globals_done')
        call s:erlang_globals()
        let s:my_erl_globals_done = 1
    endif
    " Figure out which executable we should call
    let [maker_type, maker_exe] = s:find_erlang_project_type()

    if maker_type == "rebar"
        call s:erlang_rebar_settings(maker_exe)
    elseif maker_type == "rebar3"
        call s:erlang_rebar3_settings(maker_exe)
    endif

    call s:erlang_buf_settings()
endfunction

" :Neomake [makers]
" Run a make command with the current file as input
" if no makers, use default makers for 'filetype'

" :Neomake! [makers]
" Run a make command with no file as input.
" If no makers specified, use default top-level makers will be used.
" If no top-level default, 'makeprg' will be used.

function! s:erlang_rebar_settings(exec)
    " Supported rebar 2.5.1, 2.6.1
    " NB: The notion of single-file compilation does not exist with rebar:
    " it's all or nothing. This leaves us in a slightly odd place to run a set
    " of makers regularly.
    " NB: We use 'flycheck' from the vim-erlang-compiler project to provide
    " quick compilation of a single file

    " TODO flycheck: compile a single file (i.e. '%') quickly
    " TODO rebar compile: entire project (might only be necessary as a pre-req
    " to other steps, and rebar might always take care of it for us. Include
    " for completeness)
    let g:neomake_erlang_compile_maker = {
                \ 'exe': a:exec,
                \ 'args': ['compile'],
                \ 'append_file' : 0,
                \ 'buffer_output': 1
                \ }

    " TODO eunit (or CT) might be used to start EQC/PropEr tests
    " TODO rebar eunit: current file
    let b:neomake_erlang_eunit_args = deepcopy(g:neomake_erlang_eunit_maker.args)
    call add(b:neomake_erlang_eunit_args, 'suites=' . expand('%:t:r'))
    let b:neomake_erlang_eunit_maker = {
                \ 'exe': a:exec,
                \ 'args': ['eunit', 'suites=' . expand('%:t:r')],
                \ 'append_file': 0
                \}
    " TODO rebar eunit: entire project
    " TODO rebar qc: current file
    " TODO rebar qc: entire project
    " TODO rebar ct: current file
    " TODO rebar ct: entire project
    " TODO rebar xref
    " TODO rebar dialyze: might require a build-plt step first
    " TODO read cover analysis

    " TODO: enabled makers:
    " There are 2 main entrypoints we want here, for different uses:
    "  1.  compile and test the current file ONLY:
    "   This should be what gets done on BufWrite - it can take a while so we
    "   will want to think about some kind of job-queueing for it but TODO
    "   Maybe neomake takes care of that for us?
    "   - flycheck
    "   - eunit single
    "   - ct single
    "   - qc single
    "  2. compile and test the entire project:
    "   - compile
    "   - eunit
    "   - ct
    "   - qc
    "   - xref
    "   - dialyze
    "   - cover ?!
endfunction

function! s:erlang_rebar3_settings(exec)
    let eunit_efm  = '%E  %n) %m,'
    " TODO This is awful, but it kinda sorta works.
    let eunit_efm .= '%Z%[ ]%#%%%% %.%#/_build/test/lib/%[%^/]%#/%f:%l:in %.%#,'
    " TODO When you match on '%f' in a line, it puts that filename in the
    " buflist and the matching index in a:entry.bufnr
    " Until we figure out how to do that ourselves, this workaround will
    " suffice.
    let eunit_efm .= '%Z%[ ]%#%%%% %f:%l:in %.%#,'
    let eunit_efm .= '%+C%[ ]%#%m'
    " let eunit_efm .= '%+C%[ ]%#expected: %m,'
    " let eunit_efm .= '%+C%[ ]%#got: %m,'
    " let eunit_efm .= '%C%[ ]%#Failure/Error: %m'

    " NB: Use 'mapexpr' to filter our ANSI colour sequences.
    let g:neomake_erlang_eunit_maker = {
        \ 'exe': 'rebar3',
        \ 'args': ['eunit'],
        \ 'buffer_output': 1,
        \ 'append_file': 0,
        \ 'errorformat': eunit_efm,
        \ 'mapexpr': 'substitute(v:val, "\\[[01]\\(;[0-9]*\\)\\?m", "", "g")',
        \ }
endfunction

function! s:erlang_flycheck_settings()
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

set termguicolors
colorscheme NeoSolarized
