" Setup functions that utilises quickmenu.vim

" TODO Some kind of check that quickmenu is actually available
if exists('g:loaded_qmenus')
    finish
endif
let g:loaded_qmenus = 1

" This function generates the content for the Neomake menu dynamically.
" AFAIK it *must* come before the reference to it in g:custom_quickmenus
" below.
" TODO: Clean it up.
function! CurrentNeomakers()
    let ft = &filetype
    let makers = neomake#GetEnabledMakers(ft)
    let items = {}
    for m in makers
        let item = [ 'Neomake ' . m.name, 'Neomake ' . m.name ]
        call extend(items, { m.name: item })
    endfor
    return {'items': deepcopy(items)}
endfunction

" If you want to add a new menu, add its title in this list, then you can use
"   s:qmenuid('mymenu')
" to get its numerical ID.
" TODO Enforce the ordering of s:qmenuids when building top-level menu
let s:qmenuids = ['fugitive', 'vim-test', 'neomake', 'vim-notes']
" Static-ish configuration for menus
" TODO: update this description once TODOs below are TODOne
" Each should either be a dict, where each key is a menu name and its value is
" a dict of name -> [ command, description ] list-pairs
" or a Funcref to a function that returns such a dict.
" The Funcref indirection allows you to e.g. have a menu for Neomake that
" always contains only the currently available makers for the current buffer's
" filetype.
" TODO: Allow special keys in these dicts to control the other allowed fields
" in quickmenu datatypes, e.g. 'ft', description etc
" TODO: add 'docs' markup key to allow quick link to docs for a section:
" directly invoke ':help <subject>' where possible, otherwise maybe open the
" README from the plugin dir?
" TODO: 'bottom' vs 'toggle' option
" TODO: Header
" TODO: 'for' &filetype
" TODO: Should we support both 'fn' and 'items'? Static entries + dynamic
" ones?
" TODO: Change items and outer structure here to List, so that ordering can be
" preserved.
" [ {'neomake': { ... }}, {'fugitive': {'item': [ {'Gstatus': ... }]}} ]
let g:custom_quickmenus = {
            \ 'neomake': {
            \  'fn': function('CurrentNeomakers')
            \ },
            \ 'fugitive/fzf': {
            \  'items': {
            \   'Git': [ ':Git', 'Show changed files' ] ,
            \   'Gdiff':   [ ':Gdiff', 'Show changes from index' ],
            \   'Git commit': [ ':Git commit', 'Commit the currently staged changes' ],
            \   'Git commit amend': [ ':Git commit --amend --reuse-message=HEAD', 
                                    \ 'Add the currently staged changes to the last commit'],
            \   'GitGutter': [ ':call qmenus#bottom("git-gutter")', 'Show GitGutter menu' ],
            \   'Git push': [ ':Git push', 'Push the current branch (requires upstream to be set)' ]
            \ }},
            \ 'git-gutter': {
            \  'items': {
            \   'Refresh': [ ':GitGutter', 'Refresh GitGutter markers' ],
            \   'Preview Hunk': [ ':GitGutterPreviewHunk', 'Preview the current hunk' ],
            \   'Stage Hunk': [ ':GitGutterStageHunk', 'Stage the current hunk' ],
            \   'Revert Hunk': [ ':GitGutterUndoHunk', 'Revert the current hunk' ]
            \ }},
            \ 'vim-test': {
            \  'items': {
            \   'TestNearest': [ ':TestNearest', 'Runs nearest test case' ],
            \   'TestFile': [ ':TestFile', 'Runs the current test file' ],
            \   'TestSuite': [ ':TestSuite', 'Runs the whole test suite' ],
            \   'TestLast': [ ':TestLast', 'Re-runs the last run test' ],
            \   'TestVisit': [ ':TestVisit', 'Visits the last run test' ],
            \   'TestFailed': [ ':ExUnit --failed', 'Retries the failed tests' ]
            \ }},
            \ 'vim-notes': {
            \  'items': {
            \   'Note': [ 'Note', 'Create a new untitled note' ],
            \   'NoteFromSelectedText': [ 'NoteFromSelectedText', 'Creates a note from the selected text' ]
            \ }},
            \ 'sessions': {
            \  'items': {
            \   'SSave': [ 'SSave', 'Save current session' ],
            \   'SLoad': [ 'SLoad | Obsession', 'Load session' ]
            \ }},
            \ 'bookmarks': {
            \  'items': {
            \    'WriteTODO': [ 'WriteTODO', 'Add a dated TODO'],
            \    'BookmarkToggle': [ 'BookmarkToggle', 'Add or remove bookmark at current line' ],
            \    'BookmarkAnnotate <TEXT>': [ 'BookmarkAnnotate', 'Add/edit/remove annotation at current line' ],
            \    'BookmarkNext': [ 'BookmarkNext', 'Jump to the next bookmark downwards' ],
            \    'BookmarkPrev': [ 'BookmarkPrev', 'Jump to the next bookmark upwards' ],
            \    'BookmarkShowAll': [ 'BookmarkShowAll', 'Show bookmarks across all buffers in new window (toggle)' ],
            \    'BookmarkClear': [ 'BookmarkClear', 'Removes bookmarks for current buffer' ],
            \    'BookmarkClearAll': [ 'BookmarkClearAll', 'Removes bookmarks for all buffer' ],
            \    'BookmarkMoveUp [<COUNT>]': [ 'BookmarkMoveUp', 'Move up the bookmark at current line by the specified amount of lines (default: 1)' ],
            \    'BookmarkMoveDown [<COUNT>]': [ 'BookmarkMoveDown', 'Move down the bookmark at current line by the specified amount of lines (default: 1)' ],
            \    'BookmarkMoveToLine <LINE>': [ 'BookmarkMoveToLine', 'Move the bookmark at current line to the specified <LINE>' ],
            \    'BookmarkSave <FILE_PATH>': [ 'BookmarkSave', 'Saves all bookmarks to a file so you can load them back in later' ],
            \    'BookmarkSave <auto>': [ 'BookmarkAutoSave', 'Saves all bookmarks under a file using the current branch name' ],
            \    'BookmarkLoad <FILE_PATH>': [ 'BookmarkLoad', 'Loads bookmarks from a file (see :BookmarkSave)' ]
            \ }},
            \ 'plug.vim': {
            \  'items': {
            \   'PlugUpdate': [ 'PlugUpdate', 'Upgrade all plugins'],
            \   'PlugUpgrade': [ 'PlugUpgrade', 'Upgrade plug.vim']
            \ }},
            \ 'ls-client': {
            \  'items': {
            \   'LSClientEnable': [ 'LSClientEnable', 'Enable Language Server'],
            \   'LSClientDisable': [ 'LSClientDisable', 'Disable Language Server'],
            \   'LSClientRestartServer': [ 'LSClientRestartServer', 'Restart Language Server']
            \ }}
            \ }


" TODO Menus:
"  - useful [neo]vim switches ('set invnumber', 'set smartcase' etc)
"  - try to include a menu for each plugin that has commands
"  - vim-erlang: tags, skeletons, compiler..?
"   - rebar3 menu? Maybe we could do something entertaining like auto-gen a
"   menu based on rebar3's help output...?
"  - auto-generate a 'make' menu based on... tab-completion for 'make'...?!
"  - auto-generate the sessions menu based on the startify sessions list

function! qmenus#load()
    " call MakerMenu()
    call SetupConfiguredMenus()
    call s:maps()
endfunction

" Since quickmenu's API requires so much gymnastics to figure out which
" menu you are working with at any time, here's a convenience function which
" uses our internally stored list of menu names, s:qmenuid(name), and a
" little vimscript trickery, to wrap it up in a more declarative API.
" Caveat: this means we always return to menu 0.
function! qmenus#append(menu, ...)
    let menuid = s:qmenuid(a:menu)
    call quickmenu#current(menuid)
    let args = a:000
    call call('quickmenu#append', args)
    call quickmenu#current(0)
endfunction

" Likewise qmenus#append(..) above, convenience wrapper for quickmenu#reset()
function! qmenus#reset(menu)
    let menuid = s:qmenuid(a:menu)
    call quickmenu#current(menuid)
    call quickmenu#reset()
    call quickmenu#current(0)
endfunction

function! qmenus#header(menu, header)
    let menuid = s:qmenuid(a:menu)
    call quickmenu#current(menuid)
    call quickmenu#header(a:header)
    call quickmenu#current(0)
endfunction

function! qmenus#bottom(menu)
    let menuid = s:qmenuid(a:menu)
    call quickmenu#bottom(menuid)
endfunction

function! qmenus#toggle(menu)
    let menuid = s:qmenuid(a:menu)
    call quickmenu#toggle(menuid)
endfunction

" This one is a bit less obvious:
" We allow a Funcref() in g:custom_quickmenus dict, which we need to call
" whenever we pick the menu. This requires an exported function to call from a
" menu or a key mapping.
function! qmenus#update(menu)
    " TODO reset the menu...
    " TODO Use s:append_menu_items properly
    call qmenus#reset(a:menu)
    let Updfunc = g:custom_quickmenus[a:menu]['fn']
    let items = Updfunc()
    call s:append_menu_items(a:menu, items)
endfunction

" Declaratively add a new menu using a menuspec (see g:custom_quickmenus)
function! qmenus#set(menu, menuspec)
    call s:setup_menu(a:menu, a:menuspec)
endfunction

" Quickmenu has a pretty annoying API that makes you work harder than you
" should need to. Adding entries to a given menu (once you have its id) is
" done in a stateful and side-effect-ridden manner:
" " First select your menu:
" call quickmenu#current(menuid)
" " Now you can set the header:
" call quickmenu#header('my menu name')
" " And add entries to it:
" call quickmenu#append('menu entry', ':MyCommand')
" call quickmenu#append('menu entry', ':MyCommand with args',
"                       'Long description of command')
" " And finally reset quickmenu back to the top:
" call quickmenu#current(0)

function! s:maps()
    noremap <C-H> :call qmenus#bottom('fugitive/fzf')<CR>
    noremap <C-T> :call qmenus#bottom('vim-test')<CR>
    noremap <LocalLeader><LocalLeader> :call quickmenu#bottom(99)<CR>
endfunction

function! s:qmenuid(menu)
    " Shortcut for non-named menus e.g. 99
    if type(a:menu) == v:t_number
        return a:menu
    endif
    let i = index(s:qmenuids, a:menu)
    if i < 0
        call add(s:qmenuids, a:menu)
        let i = index(s:qmenuids, a:menu)
        call quickmenu#current(i)
        call quickmenu#header(a:menu)
        call quickmenu#current(0)
        "call QuickmenuQuickmenu()
        return (len(s:qmenuids) - 1)
    endif
    return i
endfunction

" TODO Quickmenu.vim configuration
" This is going to take a while to get right
" <F12> isn't viable (along with any other <Fx> key) because OSX eats it
" <c-\> ?

function! QuickmenuQuickmenu()
    let menuid = 99 " Special number. Let's hope you don't add >98 menus to s:qmenuids
    call quickmenu#current(menuid)
    call quickmenu#reset()
    let i = 0
    for name in s:qmenuids
        let cmd = 'call quickmenu#bottom('.string(i).')'
        call quickmenu#append(name, cmd)
        let i += 1
    endfor
    call quickmenu#current(0)
endfunction

function! SetupConfiguredMenus()
    for key in keys(g:custom_quickmenus)
        call s:setup_menu(key, g:custom_quickmenus[key])
    endfor
endfunction

function! s:setup_menu(name, menuspec)
    if has_key(a:menuspec, 'fn')
        let cmd = 'call qmenus#update('.string(a:name).')'
                    \ . '| call qmenus#bottom('.string(a:name).')'
        call s:append_menu_items(99, [a:name, cmd, a:name])
    else
        let cmd = 'call qmenus#bottom('. string(a:name) .')'
        call s:append_menu_items(99, [a:name, cmd, a:name])
        call s:append_menu_items(a:name, a:menuspec)
    endif
endfunction

function! s:append_menu_items(menu, menuspec)
    if type(a:menuspec) == v:t_list
        let [name, cmd, desc] = a:menuspec
        call qmenus#append(a:menu, name, cmd, desc)
        return
    elseif ! has_key(a:menuspec, 'items')
        return
    endif
    for name in keys(a:menuspec['items'])
        let [ cmd, desc ] = a:menuspec['items'][name]
        call qmenus#append(a:menu, name, cmd, desc)
    endfor
endfunction

function! s:append_meta_menu(menu, Menufunc)
    " This creates a top-level link to a menu that will rebind every time you
    " call it.
    call qmenus#header(a:menu, a:menu)
    let items = Menufunc()
    call s:append_menu_items(a:menu, items)
endfunction

"function! AppendIngestMakers()
"    call quickmenu#current(0)
"    call quickmenu#header('Ingest makers')
"    call quickmenu#append('make compile', 'T make compile')
"    call quickmenu#append('make distclean', 'T make distclean')
"    call quickmenu#append('make ct', 'T make ct')
"    call quickmenu#append('make unit', 'T make unit')
"    " TODO Would be cool to get a nice coverage report
"    call quickmenu#append('make test', 'T make test')
"    call quickmenu#append('make shell', 'T make shell')
"    " TODO Only activate this for projects that have it
"    call quickmenu#append('make package', 'T make package')
"    " TODO Put a warning on this
"    call quickmenu#append('make lockclean', 'T make lockclean')
"endfunction

" function! MakerMenu()
"     let mid = s:qmenuid('quickmakers')
"     call quickmenu#current(mid)
"     call quickmenu#reset()
"     call quickmenu#header("Quickmake")

"     call quickmenu#append('proper:module', 
"                 \ 'T rebar3 proper -d %:h -m %:t:r')
    
"     let erlopts = " -pa \"/Users/michaelcoles/git/ferd/recon/_build/default/lib/recon/ebin\""
"     if filereadable('config/shell.config')
"         let erlopts .= " -config config/shell.config"
"     endif
"     call quickmenu#append('test console',
"                 \ 'T erl '. erlopts .' -pa $(rebar3 as test path) -pa _checkouts/*/ebin')

"     noremap <LocalLeader>1 :call quickmenu#bottom(<SID>qmenuid('quickmakers'))<CR>

"     call quickmenu#current(0)
" endfunction

" call quickmenu#append('erlang -module()', "call append(0, '-module('.expand('%:t:r').').')")
" call quickmenu#append('erlang make:files()', "T make:files([\"".expand('%')."\"], [load]).")
