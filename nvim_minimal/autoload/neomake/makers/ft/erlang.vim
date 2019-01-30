" NB: Files like this (i.e. under neomake/makers/ft/) are only sourced
" once: the first time you call a maker from within it.

" This means any initialisation needs to be triggered from within each maker
" or maybe we can load a specific module from erlang/ which loads
" the appropriate functions?

" TODO Something in here gets funky with some projects: s:exe ends up set to
" 'rebar3' while s:proj_type is still 'unknown' which shouldn't be possible
" but happens anyway.
let s:proj_type = 'unknown'

function! s:find_erlang_project_type()
    " Figure out what kind of erlang project this is based on what files we
    " find:
    " [./rebar3 , rebar.config, rebar.lock] -> rebar3
    " [./rebar, rebar.config, rebar.config.lock] -> rebar
    " Otherwise, do not set anything else custom for erlang (!!)
    if filereadable("rebar.config")
        " rebar, but 2 or 3?
        if filereadable("./rebar.lock")
            return ["rebar3", "rebar3"]
        elseif filereadable("./rebar")
            return ["rebar", "./rebar"]
        elseif filereadable("./rebar3")
            return ["rebar3", "./rebar3"]
        elseif filereadable("./rebar.config.lock")
            return ["rebar", "rebar"]
        else
            return ["rebar3", "rebar3"]
        endif
    endif
    " TODO Failsafe for e.g. standalone scripts
    return ["unknown", ""]
endfunction

let [ s:proj_type, s:exe ] = s:find_erlang_project_type()

function! s:maker(rg)
    " TODO Do nothing if s:exe == ''
    let Fn = function('neomake#makers#ft#erlang#'. s:proj_type . '#' . a:rg)
    return Fn()
endfunction

function! neomake#makers#ft#erlang#ProjectType()
    return s:find_erlang_project_type()
endfunction

function! neomake#makers#ft#erlang#EnabledMakers()
    return s:maker('EnabledMakers')
endfunction

function! neomake#makers#ft#erlang#flycheck()
    return s:maker('flycheck')
endfunction

function! neomake#makers#ft#erlang#eunit()
    return s:maker('eunit')
endfunction

function! neomake#makers#ft#erlang#eunitmodule()
    return s:maker('eunitmodule')
endfunction

function! neomake#makers#ft#erlang#compile()
    return s:maker('compile')
endfunction

function! neomake#makers#ft#erlang#ct()
    return s:maker('ct')
endfunction

function! neomake#makers#ft#erlang#ctsuite()
    return s:maker('ctsuite')
endfunction

function! neomake#makers#ft#erlang#tags()
    " TODO Need a better way to manage tags files - some central place for
    " them, based on (git-remote + branch)
    " TODO Need to ignore at least _build/*/lib/${appname}
    " Or maybe we simply make sure we put ./src/* and ./apps/*/src/* first..?
    " TODO Need to control the order of directories (or their presence at all)
    " when building 'tags' file: _checkouts takes precedence
    " Maybe in rebar3 systems we can use 'rebar3 path' somehow?
    let args = []
    if exists('b:erlang_app')
        call extend(args, ['--ignore', '_build/*/lib/'.b:erlang_app])
    endif

    return {
        \ 'exe': g:plug_dir . '/vim-erlang-tags/bin/vim-erlang-tags.erl',
        \ 'args': args,
        \ 'append_file': 0
        \ }
endfunction

"function! neomake#makers#ft#erlang#flycheck()
"    return {
"        \ 'exe': g:plug_dir . '/vim-erlang-compiler/compiler/erlang_check.erl',
"        \ 'args': [],
"        \ 'errorformat': '%f:%l: %tarning: %m,%f:%l: %m,%f: %m',
"        \ }
"    "let g:neomake_erlang_flycheck_args = ['--outdir', 'ebin', '--load', 'longnames', 'foo@127.0.0.1', 'dev1@127.0.0.1', '--cookie', 'riak']
"endfunction

function! neomake#makers#ft#erlang#erlc()
    return {
        \ 'errorformat':
            \ '%W%f:%l: Warning: %m,' .
            \ '%E%f:%l: %m'
        \ }
endfunction
