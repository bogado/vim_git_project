" Avoid installing twice or when in unsupported Vim version.
if exists('g:project_plugin') || (v:version < 700)
"	finish
endif
let g:project_plugin = 1

function! s:discover(path)
    silent let l:root = substitute(system('git -C ' . shellescape(a:path) . ' rev-parse --show-toplevel'), '\n', '', '')
    if isdirectory(l:root)
        let b:project = 1
        let b:project_root = l:root
        let b:project_name = fnamemodify(l:root, ":t")
    else
        let b:project = 0
    endif
endfunction

function! s:init(path)
    call s:discover(a:path)
    if b:project == 1
        let l:rc_file = b:project_root . "/.vimrc"
        if (file_readable(l:rc_file))
            exec "source " . l:rc_file
        endif
    endif
endfunction

bufdo call s:init(expand("%:h"))
autocmd! bufnew * call s:init(expand("<afile>:h"))
