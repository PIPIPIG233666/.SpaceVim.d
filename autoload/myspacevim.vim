function! myspacevim#before() abort
    " you can defined mappings in bootstrap function
    " for example, use kj to exit insert mode.
    let g:syntastic_ebuild_checkers = ['pkgcheck']

    let g:vimspector_sidebar_width = 75
    let g:vimspector_bottombar_height = 15
    let g:vimspector_code_minwidth = 90
    let g:vimspector_terminal_maxwidth = 75
    let g:vimspector_terminal_minwidth = 20
    let g:vimspector_variables_display_mode = 'full'

    " reset neoformat so that it picks up the correct .clang-format
    let g:neoformat_enabled_cpp = ['clangformat']

    call SpaceVim#plugins#tasks#reg_provider(function('s:make_tasks'))
    " lua require('taskprovider')
endfunction

" I want to leave copilot on for all files except files in a certain directory:
" I actually need to try harder by myself on eecs281 so disable copilot for that
augroup copilot_toggle
  autocmd!
  autocmd BufNewFile,BufRead * let b:copilot_enabled = 1
  autocmd BufNewFile,BufRead $HOME/eecs281-sp24/* let b:copilot_enabled = 0
augroup END

function! myspacevim#after() abort
    " you can remove key binding in bootstrap_after function
endfunction

function! s:make_tasks() abort
if filereadable('Makefile')
    let subcmds = filter(readfile('Makefile', ''), "v:val=~#'^.PHONY'")
    let conf = {}
    for subcmd in subcmds
        let commands = split(subcmd)[1:]
        for cmd in commands
            call extend(conf, {
                        \ cmd : {
                        \ 'command': 'make -j24',
                        \ 'args' : [cmd],
                        \ 'isDetected' : 1,
                        \ 'detectedName' : 'make:'
                        \ }
                        \ })
        endfor
    endfor
    return conf
else
    return {}
endif
endfunction
