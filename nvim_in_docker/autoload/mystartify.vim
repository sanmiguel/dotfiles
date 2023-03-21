if ! exists('*startify#get_lastline')
    finish
endif

" Startify now allows custom lists, based on callback functions.
" From mhinz:
"
" Okay.. since the old name g:startify_list_order is long out-of-date anyway,
" I introduced a new option g:startify_lists. That option does the same as
" the old one, but uses a different format.

" If g:startify_list_order exists but not g:startify_lists, it gets converted 
" to the new format automatically. I will mark g:startify_list_order as
" deprecated in the docs later.

" Since we're using an undocumented new option, I pushed the code to master,
" since it won't break backward compatibility.

" So, update the plugin and put this in your vimrc:


" You probably have to adjust the function a bit, but it should explain the 
" general approach.

" The option requires a type key. The header key is optionally.

" If the type key is a function, that function should return a list of dicts,
" whereas each dict requires a line and cmd key.

" To make it clear, s:neovim_commits() returns this in my case:

" [{'cmd': 'Git -C /data/repo/neovim show cca407b43',
"   'line': 'cca407b43 DirChanged: support <buffer> (#8140)'},
"  {'cmd': 'Git -C /data/repo/neovim show 0093c25dd', 'line': '0093c25dd doc: nodejs'},
"  {'cmd': 'Git -C /data/repo/neovim show 338664e96',
"   'line': '338664e96 node/provider: support g:node_host_prog #8135'},
"  {'cmd': 'Git -C /data/repo/neovim show 5ce8158a5',
"   'line': '5ce8158a5 vim-patch:8.0.0316: :help z? does not work (#8134)'},
"  {'cmd': 'Git -C /data/repo/neovim show f5b0f5e17',
"   'line': 'f5b0f5e17 Merge pull request #8127 from jamessan/update-pvs-headers'},
"  {'cmd': 'Git -C /data/repo/neovim show e24e98534',
"   'line': 'e24e98534 ci/AppVeyor: use PowerShell (#8124)'},
"  {'cmd': 'Git -C /data/repo/neovim show 4e5e6506b',
"   'line': '4e5e6506b pvscheck: Ignore exit code of pvs-studio-analyzer'},
"  {'cmd': 'Git -C /data/repo/neovim show 8bd1bbcec',
"   'line': '8bd1bbcec Add missing PVS headers to new files'},
"  {'cmd': 'Git -C /data/repo/neovim show c7f95fde1',
"   'line': "c7f95fde1 ci/travis: Don't destroy cache during prepare"},
"  {'cmd': 'Git -C /data/repo/neovim show 241c380da',
"   'line': "241c380da Merge #8117 'build/CI/MSVC/LuaRocks'"}]
" (You can check :StartifyDebug to see what got registered exactly.)

" Does it work for you? Do you miss anything?
