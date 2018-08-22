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

set splitright " Default vertical splits to open on the right
set splitbelow " Default horizontal splits to open below
set diffopt+=vertical " Default diff split to vertical

" More obvious way to leave INS-mode in a :terminal buffer
tnoremap <silent> <Esc><Esc> <C-\><C-n>

set expandtab " Because we are not animals
set tabstop=4 " How many spaces displayed for a tab
set shiftwidth=4 " How many spaces for each (auto)indent

" Authorization data: keep this out of git!
if filereadable(glob("~/.auth.vim"))
    source ~/.auth.vim
endif

set termguicolors   " Use 24-bit colour where possible
set background=dark " Use a dark background (some colorschemes obey this)

" NB: Requires neovim-remote
" When running e.g. 'git commit' inside an nvim terminal, this will cause it
" to open the commit message buffer in the current nvim instance (rather than
" a nested nvim inside the neovim-terminal...)
if has('nvim')
    let $VISUAL = 'nvr -cc split --remote-wait'
endif

" Turn off line numbers in terminal
autocmd TermOpen * setlocal nonumber

" Python pre-requisites: Use pyenv to install python2 and python3, to create
" segregated python runtimes for neovim to use:
" NB: Unfortunately if you upgrade pyenv via homebrew later, you'll have to
" repeat these steps
" brew install pyenv pyenv-virtualenv
" # Add 'pyenv' to your oh-my-zsh plugins in ~/.zshrc
" # Start a new shell
" pyenv install 2.7.14
" pyenv install 3.6.3
" pyenv virtualenv 2.7.14 neovim2
" pyenv virtualenv 3.6.3 neovim3
" ## New shell:
" pyenv activate neovim2
" pip install neovim flake8
" pyenv which python # <- g:python_host_prog
" ## New shell:
" pyenv activate neovim3
" pip install neovim flake8
" pyenv which python # <- g:python3_host_prog
" Once you've carried out these commands, uncomment these:
let g:python_host_prog = expand("~/.pyenv/versions/neovim2/bin/python")
let g:python3_host_prog = expand("~/.pyenv/versions/neovim3/bin/python")

" Plugins: https://github.com/junegunn/vim-plug#installation
let g:plug_dir = expand('~/.config/nvim/plugged')
call plug#begin(g:plug_dir)
" Appearance: colours etc
Plug 'iCyMind/NeoSolarized'
" Fancy status lines (see 'g:airline_*' settings below)
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

" Highlight instances of the current word
Plug 'RRethy/vim-illuminate'

" Vim session control
Plug 'tpope/vim-obsession'
set sessionoptions-=buffers

" Improve NetRW windows
Plug 'tpope/vim-vinegar'

" System: External resources
" Git-related:
Plug 'tpope/vim-fugitive'     " :h fugitive
" This adds some helpful things when dealing with Github (.com or enterprise)
" but requires some configuration - see https://github.com/tpope/vim-rhubarb#installation
" for full instructions
let g:github_enterprise_urls = ["https://algithub.pd.alertlogic.net"]
Plug 'tpope/vim-rhubarb'      " :h rhubarb
Plug 'airblade/vim-gitgutter' " :h GitGutter
Plug 'whiteinge/diffconflicts' " :h DiffConflicts

" Startup screen:
Plug 'mhinz/vim-startify'

Plug 'mileszs/ack.vim'  " :h ack | Can be configured for grep, ag, ack
Plug 'thinca/vim-ref'   " :h ref-introduction
                        " e.g. :Ref erlang lists:foldl
" TODO: enable vim-mundo again
" Plug 'simnalamburt/vim-mundo'
let g:notes_directories = ['~/.cache/vim-notes']
let g:notes_conceal_code = 0
Plug 'xolox/vim-misc' | Plug 'xolox/vim-notes'

Plug 'neomake/neomake' " :h neomake-contents

let g:deoplete#enable_at_startup = 1
" TODO There seems to be some weirdnesses around using deoplete:
" rogue python processes, excessive file handles, and sometimes it just
" doesn't work at all. Investigate!
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" TODO Add Python plugin
Plug 'zchee/deoplete-jedi'

" Git runtime files: an earlier version of these is shipped with vim, but
" this is the official distribution now:
" [NB: 'runtime files' e.g. syntax and highlight definitions for commit
" messages]
Plug 'tpope/vim-git'

" readline style input even in vim commandline: where has this plugin
" been...?!
Plug 'tpope/vim-rsi'

Plug 'janko-m/vim-test'

" System: Additional controls
Plug 'tpope/vim-unimpaired' " :help unimpaired
Plug 'tpope/vim-surround'   " :help surround
" quickmenu does nothing without configuration, which we'll do later
Plug 'skywind3000/quickmenu.vim'
" Shortcuts for filetype-sensitive comment toggling:
" in erlang, only recognises single-% comments
Plug 'tpope/vim-commentary'

" Language: erlang
Plug 'vim-erlang/vim-erlang-runtime', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-omnicomplete', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-skeletons', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-tags', {'for': 'erlang'}
Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}
Plug 'vim-scripts/argtextobj.vim'
" Use 'for': 'none' to prevent this actually loading. we just want the
" script in our runtime for neomake
Plug 'sanmiguel/vim-erlang-compiler', {'branch': 'mtc-compile-as-test',
            \ 'for': 'none'}

" Language: elixir
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'slashmili/alchemist.vim', {'for': 'elixir'}

call plug#end()

" =======================================
" Plugin Configurations
" =======================================

" This has to come after the plugins are loaded
colorscheme NeoSolarized

" Airline: configuration
let g:airline#extensions#neomake#enabled = 1
let g:airline_powerline_fonts=1
let g:airline_theme = 'atomic'
let [g:airline_left_sep, g:airline_right_sep] = ['', '']

let g:startify_lists = [
      \ { 'header': ['   Sessions'],       'type': 'sessions' },
      \ { 'header': ['   MRU '.getcwd()], 'type': 'dir' }
      \ ]

let g:startify_fortune_use_unicode = 1
let g:startify_commands = [
    \ ':help reference',
    \ ['Vim Reference', 'h ref'],
    \ {'h': 'h ref'},
    \ {'m': ['My magical function', 'call Magic()']},
    \ ]

" VimTest:
let test#runners = {'Erlang': ['commontest', 'eunit']}
let test#strategy = {'nearest': 'neovim',
    \ 'file': 'neovim',
    \ 'suite': 'neovim'
    \}

" Quickmenus:
call qmenus#load() " See autoload/qmenus.vim

" Language: elixir + autocmd + neomake
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

" Language: erlang + autocmd + neomake
augroup erlang
    autocmd FileType erlang call s:erlang_buflocals()
    autocmd BufEnter *.erl call s:erlang_bufenter()
    " autocmd BufWritePost *.erl,*.hrl Neomake flycheck
augroup END

function! s:erlang_buflocals()
    " TODO Skip also if filename ~= "fugitive://"
    if !exists('s:my_erl_globals_done')
        call s:erlang_globals()
        let s:my_erl_globals_done = 1
    endif

    let b:erlang_module = expand('%:t:r')
    let b:erlang_srcdir = s:erlang_srcdir()
    let b:erlang_app = s:erlang_app(s:erlang_srcdir())
    let b:rebar3_profile = 'test'

    set suffixesadd+=.erl
    set suffixesadd+=.hrl
endfunction

function! s:erlang_bufenter()
    let @m = b:erlang_module
endfunction

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
    set path+=include
    " TODO Paths should change based on project type: rebar rebar3 etc
    set path+=deps/**
    set path+=_build/default/lib
    let g:erlang_tags_ignore = [ ".eunit", ".qc", "logs" ]

    " Enable this to have neomake log its actions:
    "let g:neomake_logfile = './neomake.log'

    " Control how neomake uses the loclist:
    " 0 = do not open
    " 1 = open and jump to first
    " 2 = open but hold cursor pos
    let g:neomake_open_list = 2

    " Run each maker in order, one at a time
    let g:neomake_serialize = 1
    let g:neomake_serialize_abort_on_error = 1

    " TODO Experimental vim-surround setup
    " This enables cs"< to turn "x" into <<"x">>
    let g:surround_60 = "<<\"\r\">>"
    let g:surround_62 = "<<\"\r\">>"
    " TODO But how to do the inverse?

    " EXPERIMENTAL:
    " Disable the auto-flycheck on BufWritePost for now, replace with
    command! W w | Neomake flycheck
endfunction

function! s:erlang_srcdir()
    return expand('%:p:h')
endfunction
function! s:erlang_app(srcdir)
    " Adjacent to srcfile should be a .app.src
    let appsrc = glob(a:srcdir . '/../src/*.app.src')
    " TODO appsrc == "" if not found
    " TODO Might be up n levels - traverse if not found
    let appname = fnamemodify(appsrc, ':t:r:r')
    return appname
endfunction
