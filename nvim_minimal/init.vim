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
set wildmode=longest,full
set wildignorecase " Ignore case when tab-completing a wildcard
set wildignore+=.beam " When tab-completing filenames, ignore .beam

" 'completeopt' affects the completion engine
" see :h 'ins-completion'
set completeopt+=longest
" Remove 'preview' in favour of float-preview.nvim
set completeopt-=preview

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

" Unmap the new default Y y$
unmap Y

" Map \/ to temporarily stop highlighting search
nnoremap <silent> \o :nohlsearch<CR>

" Turn off line numbers in terminal
autocmd TermOpen * setlocal nonumber

" Python pre-requisites: Use pyenv to install python2 and python3, to create
" segregated python runtimes for neovim to use:
" brew install pyenv pyenv-virtualenv
" # Add 'pyenv' to your oh-my-zsh plugins in ~/.zshrc: an exercise left for
" the reader
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
let g:plug_home = expand('~/.config/nvim/plugged')
call plug#begin()
" Appearance: colours etc
Plug 'iCyMind/NeoSolarized'
" Auto-dark-/light-mode
Plug 'f-person/auto-dark-mode.nvim'

" Fancy status lines (see 'g:airline_*' settings below)
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

" Highlight instances of the current word
Plug 'RRethy/vim-illuminate'

" Vim session control
Plug 'tpope/vim-obsession'
set sessionoptions-=buffers

" TODO: Investigate dotted filetype syntax. Maybe we can define an eqc
" ft that augments erlang? Might be helpful for erlang/eqc dev

" Snippets
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Improve NetRW windows
Plug 'tpope/vim-vinegar'

" System: External resources
" fzf: install it from homebrew, then this will enable it:
" TODO FIXME Use `brew --prefix` to get the path
Plug '/opt/homebrew/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
" optional for icon support
Plug 'nvim-tree/nvim-web-devicons'

" Plug 'git@bitbucket.org:sanmiguel/todoist.vim', {'branch': 'python3'}

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Git-related:
Plug 'tpope/vim-fugitive'     " :h fugitive
" This adds some helpful things when dealing with Github (.com or enterprise)
" but requires some configuration - see https://github.com/tpope/vim-rhubarb#installation
" for full instructions
Plug 'tpope/vim-rhubarb'      " :h rhubarb
let g:gitgutter_override_sign_column_highlight = 0
Plug 'airblade/vim-gitgutter' " :h GitGutter
Plug 'whiteinge/diffconflicts' " :h DiffConflicts

Plug 'mattn/webapi-vim' | Plug 'mattn/vim-gist'

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

" Git runtime files: an earlier version of these is shipped with vim, but
" this is the official distribution now:
" [NB: 'runtime files' e.g. syntax and highlight definitions for commit
" messages]
Plug 'tpope/vim-git'

" readline style input even in vim commandline: where has this plugin
" been...?!
Plug 'tpope/vim-rsi'

Plug 'skywind3000/asyncrun.vim'
Plug 'vim-test/vim-test'

" Place signs based on qflist/loclist
Plug 'dhruvasagar/vim-markify'

" System: Additional controls
Plug 'tpope/vim-unimpaired' " :help unimpaired
Plug 'tpope/vim-surround'   " :help surround
" quickmenu does nothing without configuration, which we'll do later
Plug 'skywind3000/quickmenu.vim'
" Shortcuts for filetype-sensitive comment toggling:
" in erlang, only recognises single-% comments
Plug 'tpope/vim-commentary'
Plug 'ryanoasis/vim-devicons'

Plug 'MattesGroeger/vim-bookmarks'

Plug 'TamaMcGlinn/quickfixdd'
" Use a floating window instead of old school preview window
Plug 'ncm2/float-preview.nvim'

" Plug 'SmiteshP/nvim-navic' | Plug 'utilyre/barbecue.nvim'

" TODO Try out the _native_ lsp client
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/lsp-status.nvim'
" fzf+lsp
"Plug 'gfanto/fzf-lsp.nvim'
"Plug 'nvim-lua/plenary.nvim'

" Language Server client/management
Plug 'prabirshrestha/vim-lsp' | Plug 'mattn/vim-lsp-settings'


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
Plug 'tpope/vim-projectionist'
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
" Plug 'slashmili/alchemist.vim', {'for': 'elixir'}

call plug#end()

if !isdirectory(g:plug_home)
    execute 'PlugInstall'
endif

" =======================================
" Initialise the neovide stuff
" =======================================
if exists("g:neovide")
    call myneovide#init()
endif

" =======================================
" Plugin Configurations
" =======================================

" This has to come after the plugins are loaded
let g:neosolarized_italic = 1
let g:neosolarized_contrast = "high"
let g:neosolarized_diffmode = "high"
colorscheme NeoSolarized

" Change search highlight colour - makes cursor easier to spot
highlight Search guibg='#dc322f' guifg='#073642' gui=reverse,italic
highlight IncSearch guibg='#dc322f' guifg='#073642'

" for treesitter folding:
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=2
set foldlevel=2
set foldlevelstart=2

" For LSP folding
" let g:lsp_fold_enabled = 1
" set foldmethod=expr
"   \ foldexpr=lsp#ui#vim#folding#foldexpr()
"   \ foldtext=lsp#ui#vim#folding#foldtext()

lua <<EOF
-- barbecue setup
-- require'barbecue'.setup()

-- treesitter: configuration
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "erlang", "elixir", "eex", "heex", "lua", "vim", "vimdoc", "query" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
      select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
              },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          -- include_surrounding_whitespace = true,
          },
      },
}

local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option('background', 'dark')
		vim.cmd('colorscheme NeoSolarized')
	end,
	set_light_mode = function()
		vim.api.nvim_set_option('background', 'light')
		vim.cmd('colorscheme NeoSolarized')
	end,
})
auto_dark_mode.init()
EOF

" Maps for FZF
noremap <C-f> :FZF<CR>

" Airline: configuration
let g:airline_powerline_fonts=1
let g:airline_theme = 'sanmiguelito'
let [g:airline_left_sep, g:airline_right_sep] = ['', '']
let g:airline_section_b = ''

" lsp airline section

let g:airline_skip_empty_sections = 1
let g:airline_section_b = '%{airline#util#wrap(airline#extensions#hunks#get_hunks(),100)}'

" TODO FIXME: Switch over to 'lsp' native nvim client
" maybe that has a way to manually type a function name and search for
" references
" vim-lsc: configuration
set shortmess-=F
let g:lsc_hover_popup = v:false
let g:lsc_auto_map = {
            \ 'defaults': v:true,
            \ 'Completion': 'omnifunc'
            \ }
let g:lsc_server_commands = {'elixir': g:plug_home . '/elixir-ls/release/language_server.sh'}

" vim-lsp configuration:
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    " nmap <buffer> gd <plug>(lsp-definition)
    " nmap <buffer> gs <plug>(lsp-document-symbol-search)
    " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    " nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    " nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    " let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    autocmd!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

augroup lsp_statusline
    autocmd!
    "autocmd User lsp_progress_updated ... Update airline somehow
augroup END


autocmd CompleteDone * silent! pclose

" Illuminate: highlight word under cursor
let g:Illuminate_delay = 100
hi illuminatedWord cterm=underline gui=underline

" vim-bookmarks:
let g:bookmark_save_per_working_dir = 1
" TODO: let g:bookmark_auto_save_file = '/some/path/that/is/backed/up'

" Startify: configuration
" TODO Extension for vim-startify: function to search for a session by it's
" $PWD: then you can have a startup script that automatically resumes a
" session if there's one for the $PWD
" NB THis needs a way to turn it off - something you can pass from the CLI
"
" TODO When extending vim-startify, replace '[e]mpty buffer' with '[n]ew note'
" TODO In issue view: quickmenu for taking action:
"  - Reply
"  - Create branch ('gh-${issue-nr}')
"  - Create branch (prompt)
"  - Close
" TODO In pull-request view, add quickmenu for checking out for review:
"  - Clone to /tmp/${repository.full_name}
"  - Clone to ~/git/${repository.full_name}
"  - Prompt for path to type manually
" TODO Note 'hub clone user/repo' can work with Enterprise, but needs:
" GITHUB_HOST=myenterprise.host.com hub clone user/repo
" TODO hub checkout $PULL_URL
" TODO ^^ git diff --numstat $base-branch
" TODO ^^ open each changed buffer, run ':Gdiff master'

" TODO Function to return the list of saved bookmark files by mtime
" list of dicts:
" { 'line': 'text to display',
" \ 'cmd': ':BookmarkLoad $line'
" \ }
let s:bookmark_sets_dir = '~/.local/share/nvim/vim-bookmarks/'
function! s:list_bookmark_files()
    let list = []
    let files = glob(fnameescape(s:bookmark_sets_dir).'**/{,.}*', 1, 1)
    for bmfile in files
        let list += [{ 'line': fnamemodify(bmfile, ":t"), 'cmd': 'call BookmarkLoad("'. expand(bmfile) .'", 0, 0)' }]
    endfor
    return list
endfunction

" TODO the cmd above fails because it tries to load bookmarks for files that
" don't exist. Would need to extend vim-bookmarks to handle that
" (automatically open the files??)
function! s:save_bookmark_file()
    let branch = fugitive#Head()
    let filepath = fnameescape(expand(s:bookmark_sets_dir) . branch)
    " TODO Auto-create path if necessary
    call BookmarkSave(filepath, 0)
endfunction
command! BookmarkAutoSave call s:save_bookmark_file()

let g:startify_lists = [
      \ { 'header': ['   Sessions'],       'type': 'sessions' },
      \ { 'header': ['   MRU '.getcwd()], 'type': 'dir' },
      \ { 'header': ['   Bookmark Sets'], 'type': function('s:list_bookmark_files')}
      \ ]

let g:startify_fortune_use_unicode = 1
let g:startify_commands = [
    \ ':help reference',
    \ ['Vim Reference', 'h ref'],
    \ {'h': 'h ref'},
    \ {'m': ['My magical function', 'call Magic()']},
    \ ]

let g:startify_session_autoload = 1
let g:startify_session_save_qflist = 1
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1



" VimTest:
" let test#runners = {'Erlang': ['commontest', 'eqc', 'eunit']}
let g:test#runner_commands = ['ExUnit']
let test#neovim#term_position = "botright vertical"
" let test#strategy = {
"     \ 'nearest': 'asyncrun',
"     \ 'file': 'asyncrun',
"     \ 'suite': 'shtuff'
"     \ }
let test#strategy = 'shtuff'
let g:shtuff_receiver = 'testrunner'
let g:test#preserve_screen = 1

" AsyncRun 
let g:asyncrun_open = 10

" Quickmenus:
call qmenus#load() " See autoload/qmenus.vim

" Language: elixir + autocmd 
function s:elixir_ft_setting()
    let g:surround_101 = "{:error, \r}" " yse
    let g:surround_111 = "{:ok, \r}" " yso
    let g:surround_37 = "%{\r: }" " ys%
    let g:surround_58 = "\r:" "  ys:
    let g:surround_59 = ":\r" " ys;
    let g:surround_124 = "|> \r" " ys|
    let g:surround_107 = ".\r" " ysk

    " With makeprg and errorformat set like this we can run :make and capture
    " qflist contents with locations set correctly
   setlocal makeprg=mix\ test
   setlocal errorformat=%Wwarning:\ %m
   setlocal errorformat+=%-C\\s%#
   setlocal errorformat+=%C\ \ \ \ #\ %f:%l%#
   setlocal errorformat+=%C\ \ \ \ %s%#
   setlocal errorformat+=%+Cexpected\ %m
   setlocal errorformat+=%E%>==\ Compilation\ error\ in\ file\ %f\ ==
   setlocal errorformat+=%C**\ %m%#
   setlocal errorformat+=%+C\ \ \ \ %m
   setlocal errorformat+=%C\ \ \ \ %f:%l:\ %m%#
   setlocal errorformat+=%E%>\ \ %n)\ %m
   setlocal errorformat+=%+G\ \ \ \ \ **\ %m
   setlocal errorformat+=%+G\ \ \ \ \ stacktrace:
   setlocal errorformat+=%C\ \ \ \ \ %f:%l
   setlocal errorformat+=%+G\ \ \ \ \ \ \ (%\\w%\\+)\ %f:%l:\ %m
   setlocal errorformat+=%+G\ \ \ \ \ \ \ %f:%l:\ %.%#
   setlocal errorformat+=**\ (%\\w%\\+)\ %f:%l:\ %m

                " \%Wwarning: %m,
                " \%C\ \ \ \ #\ %f:%l,
                " \%C\ \ \ \ %m,
endfunction

augroup elixir
    autocmd FileType elixir call s:elixir_ft_setting()
    autocmd BufNewFile,BufRead *.heex set syntax=heex.html filetype=heex.html
augroup END

" Language: erlang + autocmd + neomake
augroup erlang
    autocmd FileType erlang call s:erlang_buflocals()
    autocmd BufEnter *.erl call s:erlang_bufenter()
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

    " TODO Experimental vim-surround setup
    " This enables cs"< to turn "x" into <<"x">>
    let g:surround_60 = "<<\"\r\">>"
    let g:surround_62 = "<<\"\r\">>"
    " Enable cs}o and cs}e to turn a tuple into {ok | error, body}
    let g:surround_101 = "{error, \r}"
    let g:surround_111 = "{ok, \r}"
    " Enable cs}# to turn a tuple into a map
    let g:surround_35 = "#{ \r }"
    " TODO But how to do the inverse?
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

" Custom text objects: line
xnoremap il g_o^
onoremap il <silent> :normal vil<CR>
xnoremap al $o^
onoremap al <silent> :normal val<CR>

" Sneaky reuse a surround to insert a todo
let g:surround_100 = "TODO mtc (" . strftime('%Y-%m-%d') . "): \r"
