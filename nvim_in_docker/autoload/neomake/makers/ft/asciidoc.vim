function! neomake#makers#ft#asciidoc#EnabledMakers() abort
    return ['generate']
endfunction

function! neomake#makers#ft#asciidoc#generate() abort
    let base = neomake#makers#ft#asciidoc#asciidoc()
    return {
        \ 'exe': 'docker',
        \ 'append_file': 0,
        \ 'args': {-> ['run', '--rm', '-v', expand('%:p:h') . ':/documents/', 'asciidoctor/docker-asciidoctor', 'asciidoctor', '-r', 'asciidoctor-diagram', expand('%:t')]}
        \ }
endfunction
