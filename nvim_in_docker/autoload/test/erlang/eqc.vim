if !exists('g:test#erlang#eqc#file_pattern')
  let g:test#erlang#eqc#file_pattern = '\v_eqc\.erl$'
endif

function! test#erlang#eqc#test_file(file) abort
  return 1
endfunction

function! test#erlang#eqc#build_position(type, position) abort
    let module = fnamemodify(a:position['file'],':t:r')
    if a:type ==# 'nearest'
        let name = s:nearest_test(a:position)
        if !empty(name)
            return ['-p', module.':'.name]
        else
            return []
        endif
    elseif a:type ==# 'file'
        return ['--module='.module]
    else
        return []
    endif
endfunction

function! test#erlang#eqc#build_args(args) abort
  return  ['eqc'] + a:args
endfunction

function! test#erlang#eqc#executable() abort
  return 'rebar3'
endfunction

let g:test#erlang#eqc#patterns = {'test': ['\v^\s*(prop_\w*)'], 'namespace': []}
function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#erlang#eqc#patterns)
  return join(name['test'], '')
endfunction
