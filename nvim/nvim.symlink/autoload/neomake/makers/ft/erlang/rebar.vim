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
function! neomake#makers#ft#erlang#rebar#compile()
    return {
        \ 'exe': 'rebar',
        \ 'args': ['compile'],
        \ 'append_file' : 0,
        \ 'buffer_output': 1
        \ }
endfunction

" TODO eunit (or CT) might be used to start EQC/PropEr tests
" TODO rebar eunit: current file
function! neomake#makers#ft#erlang#rebar#eunit()
    let maker = {
            \ 'exe': 'rebar',
            \ 'args': ['eunit'],
            \ 'append_file': 0
            \}
    if exists('b:rebar_eunit_suites') " TODO Support g:
        call add(maker.args, 'suites=' . b:rebar_eunit_suites)
    endif
    return maker
endfunction

function! neomake#makers#ft#erlang#rebar#ct()
    " TODO: how to support:
    "  - :Neomake ct   <- to run CT for *this* file
    "  - :Neomake! ct  <- to run CT for project?
    " TODO FIXME errorformat
    return {
        \ 'exe': 'rebar',
        \ 'args': ['ct'],
        \ 'errorformat': ''
        \ }
endfunction

" TODO This needs validating really
function! neomake#makers#ft#erlang#rebar#ctsuite()
    " TODO: how to support:
    "  - :Neomake ct   <- to run CT for *this* file
    "  - :Neomake! ct  <- to run CT for project?
    " TODO FIXME errorformat
    let maker = {
        \ 'exe': 'rebar',
        \ 'args': ['ct'],
        \ 'errorformat': ''
        \ }
    if exists('b:erlang_module')
                \ && b:erlang_module =~ '_SUITE'
        call extend(maker.args, ['--suite', b:erlang_module])
    endif
    return maker
endfunction

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
