" rebar3 specific makers

let s:exe = 'rebar3'

function! s:profile()
    if exists('b:rebar3_profile')
        return b:rebar3_profile
    endif
    if exists('g:rebar3_profile')
        return g:rebar3_profile
    endif
    return 'default'
endfunction

function! neomake#makers#ft#erlang#rebar3#EnabledMakers()
    if exists('b:erlang_module')
                \ && b:erlang_module =~ '_SUITE'
        return [ 'flycheck', 'tags', 'ctsuite' ]
    endif
    return [ 'flycheck', 'tags', 'compile', 'eunitmodule', 'ct', 'eunit']
endfunction

function! neomake#makers#ft#erlang#rebar3#compile()
    return {
        \ 'exe': 'rebar3',
        \ 'args': ['compile'],
        \ 'errorformat': '%f:%l: %tarning: %m,%f:%l: %m,%f: %m',
        \ }
endfunction

function! s:postprocess(entry)
    " Invalidate lines matching '===>'
    if a:entry.text =~ '===>'
        let a:entry.valid = -1
    endif
    if a:entry.text == '' && a:entry.pattern == ''
        let a:entry.valid = -1
    endif
    " Remove the \V and trailing \$ from a:entry.pattern
    " This is kinda a workaround but it means we can search for test case
    " names when they get logged direct from the loclist
    let newpat = substitute(a:entry.pattern, '\\V\|\\\$$', "", "g")
    let a:entry.pattern = newpat
endfunction

" NB: This has be a globally accessible function, as maker.mapexpr is passed
" directly to map() as a string, not a funcref
function! neomake#makers#ft#erlang#rebar3#flycheckmapexpr(line)
    " Remove ANSI colors
    let monochrome = substitute(a:line,  "\\\[\[01]\\(;[0-9]*\\)\\?m", "", "g")
    " Delete _build/{profile}/lib/{myapp}/(ebin|test)
    if !exists('b:erlang_app')
        return monochrome
    endif
    let ebinpat = '_build/.\+/lib/'.b:erlang_app.'/ebin'
    let testpat = '_build/.\+/lib/'.b:erlang_app.'/test'
    let localised = substitute(monochrome, ebinpat , "src", "g")
    let localised = substitute(localised, testpat, "test", "g")
    return localised
endfunction

function! s:flycheck_postprocess(entry)
    if a:entry.text =~ 'Warning: '
        let a:entry.type = 'W'
        let a:entry.text = substitute(a:entry.text, 'Warning: ', '', "g")
    else
        let a:entry.type = 'E'
    endif
endfunction

function! neomake#makers#ft#erlang#rebar3#flycheck()
    " TODO Use s:profile() to get the path correctly
    return {
        \ 'exe': g:plug_dir . '/vim-erlang-compiler/compiler/erlang_check.erl',
        \ 'args': ['--nooutdir', '--as-test'],
        \ 'errorformat': '%f:%l: %m,%f: %m',
        \ 'postprocess': function('s:flycheck_postprocess')
        \ }
endfunction

function! neomake#makers#ft#erlang#rebar3#customct()
    let efm  = '%-G===>%.%#,'
    let efm .= '%-G %#,'
    let efm .= '%f::%s:%m,'
    let efm .= '%f:%l:%m,'
    let efm .= '%+GFailed %m,'
    let efm .= '%+GResults written to %m,'
    let efm .= '%-G %#%m'
    let maker = {
        \ 'exe': 'rebar3',
        \ 'args': ['as', 'tools', 'ct'],
        \ 'mapexpr': 'neomake#makers#ft#erlang#rebar3#ctmapexpr(v:val)',
        \ 'append_file': 0,
        \ 'postprocess': function('s:postprocess'),
        \ 'errorformat': efm
        \ }
    "if exists('b:erlang_module')
    "            \ && b:erlang_module =~ '_SUITE'
    "    call extend(maker.args, ['--suite', b:erlang_module])
    "endif
    return maker
endfunction

function! neomake#makers#ft#erlang#rebar3#ct()
    let efm = '%-G===>%.%#,'
    let efm .= '%E%%%%%% %f ==> %s: FAILED,'
    let efm .= '%+GFailed %m,'
    let efm .= '%+GResults written to %m,'
    let efm .= '%C%%%%%% %f ==> %m,'
    let efm .= '%C %#%m,'
    let efm .= '%-G %#%m'
    let maker = {
        \ 'exe': 'rebar3',
        \ 'args': ['ct'],
        \ 'mapexpr': 'neomake#makers#ft#erlang#rebar3#ctmapexpr(v:val)',
        \ 'append_file': 0,
        \ 'postprocess': function('s:postprocess'),
        \ 'errorformat': efm
        \ }
    "if exists('b:erlang_module')
    "            \ && b:erlang_module =~ '_SUITE'
    "    call extend(maker.args, ['--suite', b:erlang_module])
    "endif
    return maker
endfunction

function! neomake#makers#ft#erlang#rebar3#ctsuite()
    let efm = '%-G===>%.%#,'
    let efm .= '%E%%%%%% %f ==> %s: FAILED,'
    let efm .= '%+GFailed %m,'
    let efm .= '%+GResults written to %m,'
    let efm .= '%C%%%%%% %f ==> %m,'
    let efm .= '%C %#%m,'
    let efm .= '%-G %#%m'
    let maker = {
        \ 'exe': 'rebar3',
        \ 'args': ['ct'],
        \ 'mapexpr': 'neomake#makers#ft#erlang#rebar3#ctmapexpr(v:val)',
        \ 'append_file': 0,
        \ 'postprocess': function('s:postprocess'),
        \ 'errorformat': efm
        \ }
    if exists('b:erlang_module')
                \ && b:erlang_module =~ '_SUITE'
        call extend(maker.args, ['--suite', b:erlang_module])
    endif
    return maker
endfunction

function! neomake#makers#ft#erlang#rebar3#ctmapexpr(line)
    let clean = neomake#makers#ft#erlang#rebar3#flycheckmapexpr(a:line)
    if exists('b:erlang_module')
        let pat = '%%% ' . b:erlang_module . ' ==>'
        if clean =~ pat
            let clean = substitute(clean, b:erlang_module, expand('%'), "")
        endif
    endif
    return clean
endfunction
    
function! neomake#makers#ft#erlang#rebar3#eunit()
    let eunit_efm  = '%E  %n) %m,'
    " TODO This is awful, but it kinda sorta works.
    " TODO Make this programmatic - we can figure out the paths to look for
    " from the rebar3 vars we now have.
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
    " TODO What profile to use for eunit
    return {
        \ 'exe': 'rebar3',
        \ 'args': ['eunit'],
        \ 'buffer_output': 1,
        \ 'append_file': 0,
        \ 'errorformat': eunit_efm,
        \ 'mapexpr': 'substitute(v:val, "\\[[01]\\(;[0-9]*\\)\\?m", "", "g")',
        \ }
endfunction

function! neomake#makers#ft#erlang#rebar3#eunitmodule()
    let maker = deepcopy(neomake#makers#ft#erlang#rebar3#eunit())
    if exists('b:erlang_module')
        call extend(maker.args, ['--module', b:erlang_module])
    endif
    return maker
endfunction
