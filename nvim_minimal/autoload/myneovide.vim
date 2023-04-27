function! myneovide#init()
    " Font size management
    " Nicked from https://github.com/neovide/neovide/issues/1301
    let g:neovide_font_default_size = 16
    let g:neovide_font_size_delta = 0
    let g:neovide_font_family = 'Hasklug\ Nerd\ Font\ Mono'
    " Sneaky sneaky: for some reason, calling this during startup
    " causes the window to resize to very small.
    " Instead, hook onto the thing we know is probably last: StartifyReady
    autocmd User StartifyReady silent! execute('set guifont='.g:neovide_font_family.':h'.g:neovide_font_default_size)

    function! ResizeFont(delta)
        let g:neovide_font_size_delta = g:neovide_font_size_delta + a:delta
        execute('set guifont='.g:neovide_font_family.':h'. (g:neovide_font_default_size + g:neovide_font_size_delta))
    endfunction

    function! ResetFontSize()
        let g:neovide_font_size_delta = 0
        execute('set guifont='.g:neovide_font_family.':h'.g:neovide_font_default_size)
    endfunction

    noremap <expr><D-=> ResizeFont(1)
    noremap <expr><D--> ResizeFont(-1)
    noremap <expr><D-0> ResetFontSize()

    " TODO: It looks like maybe g:neovide_transparency is enough to do this.
    " TODO: For some reason it _doesn't_ apply to signs/linenr column or tab
    " header row. Maybe plugins not respecting the alpha for some reason?
    " g:neovide_transparency = 1.0 // default
    " g:neovide_transparency = 0.0 // match bg alpha color
    let g:transparency = v:false
    let g:transparency_alpha = 0.8
    function! ToggleTransparency()
        let g:transparency = !g:transparency
        call SetTransparency(g:transparency, g:transparency_alpha)
    endfunction

    function! SetTransparency(state, alpha)
        if a:state
            let g:neovide_transparency = 0.0
            let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * a:alpha))
        else
            let g:neovide_transparency = 1.0
            silent! unlet g:neovide_background_color
            colorscheme NeoSolarized
        endif
        " Redraw the entire screen
        mode
    endfunction

    noremap <expr><D-u> ToggleTransparency()

    " map cmd+n to open a new window in neovide
    map <D-n> :silent !neovide<CR>

    " system clipboard
    nmap <D-c> "+y
    vmap <D-c> "+y
    nmap <D-v> "+p
    inoremap <D-v> <c-r>+
    cnoremap <D-v> <c-r>+
    tnoremap <D-v> <c-r>+

    " TODO WHat was this for?
    " use <D-r> to insert original character without triggering things like auto-pairs
    " inoremap <c-r> <c-v>

endfunction
