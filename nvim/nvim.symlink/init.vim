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

vmap // y/<C-R>"<CR>

" Prevent erlang compiler fully loading - we only pull it in for its flycheck
" script. Sorry Csaba!
let g:loaded_erlang_compiler = 1

" vim-airline options
set noshowmode " Disable showing editor mode - airline tells us
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline_theme = 'sanmiguelito'
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
        \ 'slope-lr-solid':  ['', ''],
        \ 'slope-lr-line':   ['', ''],
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
    let sep = 'slope-lr-solid'
    if a:0
        let sep = a:1
    endif
    " TODO Handle unknown keys
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
" Plug 'bling/vim-bufferline'
" Plug 'wellle/targets.vim' " Provides additional text objects for 'operator'
" Plug 'kana/vim-textobj-function' " Text objects for functions

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
    if exists('s:my_erl_globals_done')
        return
    else
        let s:my_erl_globals_done = 1
    endif
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

    " TODO Extend eunit maker to look for tests that call this module?
    " TODO Add eqc maker

    " Run each maker in order, one at a time
    let g:neomake_serialize = 1
    " What to run when calling `:Neomake`
    " let g:neomake_erlang_enabled_makers = ['flycheck', 'eunit', 'eqc', 'dialyzer']

    " TODO Experimental vim-surround setup
    " This enables cs"- to turn "x" into <<"x">>
    let b:surround_45 = "<<\"\r\">>"
    " TODO But how to do the inverse?
endfunction

" Called when opening a file
function! s:erlang_buflocals()
    " TODO Skip also if filename ~= "fugitive://"
    if !exists('s:my_erl_globals_done')
        call s:erlang_globals()
        let s:my_erl_globals_done = 1
    endif

    let b:erlang_module = expand('%:t:r')
    let b:erlang_srcdir = s:erlang_srcdir()
    let b:erlang_app = s:erlang_app(s:erlang_srcdir())
    let fname = expand('%:t')
    if fname =~ ".*_SUITE\.erl"
        let b:rebar3_profile = 'test'
    endif

    set suffixesadd+=.erl
    set suffixesadd+=.hrl
    " Determine what kind of erlang file this is:
    " .config
    " _SUITE.erl
    " _eqc.erl
    " _tests.erl
    " .erl <- may have eunit tests
    let fname = expand('%:t')

    " TODO Figure out something decent to do for regular erlang files
    " e.g. is it a fair assumption that for foo.erl there should be
    " foo_SUITE.erl? Maybe we can check for that, and default to nothing?
    " TODO The BufWritePost later on should only happen if this is set...

    " TODO Some management of enabled_makers
endfunction

function! s:erlang_srcdir()
    return expand('%:p:h')
endfunction
function! s:erlang_app(srcdir)
    " Adjacent to srcfile should be a .app.src
    " TODO Check cache for appname from srcdir
    let appsrc = glob(a:srcdir . '/../src/*.app.src')
    " TODO appsrc == "" if not found
    " TODO Might be up n levels - traverse if not found
    let appname = fnamemodify(appsrc, ':t:r:r')
    return appname
endfunction

" :Neomake [makers]
" Run a make command with the current file as input
" if no makers, use default makers for 'filetype'

" :Neomake! [makers]
" Run a make command with no file as input.
" If no makers specified, use default top-level makers will be used.
" If no top-level default, 'makeprg' will be used.
let g:neomake_verbose = 3
let g:neomake_logfile = './neomake.log'

augroup erlang
    autocmd FileType erlang call s:erlang_buflocals()
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
