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

command! -nargs=? -range=% -buffer Hurl silent call append(line('.'), [''] + systemlist('hurl '..<q-args>, getline(<line1>,<line2>))) " | normal! }gq}
nnoremap <buffer> <silent> <plug>(hurl) vip:Hurl<CR>
vnoremap <buffer> <silent> <plug>(hurl) <cmd>Hurl<CR>

" use JQ to format JSON if available
if !exists('s:jq')
  if executable('jq')
    let s:jq = 'jq'
  elseif has('win32') || has('$WSL_DISTRO_NAME')
    if executable('jq-win64.exe')
      let s:jq = 'jq-win64.exe'
    elseif executable('jq-win32.exe')
      let s:jq = 'jq-win32.exe'
    else
      let s:jq = ''
    endif
  else
    let s:jq = ''
  endif
endif

if !empty(s:jq)
  " See https://stackoverflow.com/questions/26214156/how-to-auto-format-json-on-save-in-vim
  augroup FileTypeHurl
    autocmd! * <buffer>
    if exists('##ShellFilterPost')
      autocmd ShellFilterPost <buffer> if v:shell_error | execute 'echom "shell filter returned error " . v:shell_error . ", undoing changes"' | undo | endif
    endif
    autocmd BufWinEnter <buffer> ++once let &l:formatprg = s:jq . ' --compact-output ' .
          \ (&expandtab ? '' : '--tab') . (' --indent ' . &l:shiftwidth) . ' "."'
  augroup END
endif

" see https://stackoverflow.com/questions/21413120/how-can-i-get-gg-g-in-vim-to-ignore-a-comma/21413701#21413701
setlocal cinoptions+=+0

let &cpoptions = s:save_cpo
