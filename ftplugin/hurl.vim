" Vim filetype plugin.
"
" Only do this when not done yet for this buffer
if exists('b:did_ftplugin') | finish | endif

" Don't load another filetype plugin for this buffer
let b:did_ftplugin = 1

" Allow use of line continuation.
let s:save_cpo = &cpoptions
set cpoptions&vim
setlocal foldmethod=expr
setlocal foldexpr=hurl#fold(v:lnum)

command! -nargs=? -range=% -buffer Hurl silent call append(line('.'), [''] + systemlist('hurl '..<q-args>, getline(<line1>,<line2>)))
nnoremap <buffer> <silent> <plug>(hurl) vip:Hurl<CR>
vnoremap <buffer> <silent> <plug>(hurl) <cmd>Hurl<CR>

let &cpoptions = s:save_cpo
