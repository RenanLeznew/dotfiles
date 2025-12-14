nmap dsm <Plug>(vimtex-env-delete-math)
" Use `am` and `im` for the inline math text object
omap am <Plug>(vimtex-a$)
xmap am <Plug>(vimtex-a$)
omap im <Plug>(vimtex-i$)
xmap im <Plug>(vimtex-i$)


" Use `ai` and `ii` for the item text object
omap ai <Plug>(vimtex-am)
xmap ai <Plug>(vimtex-am)
omap ii <Plug>(vimtex-im)
xmap ii <Plug>(vimtex-im)

" Disable insert mappings 
let g:vimtex_imaps_enabled=0

" Example: adding `\big` to VimTeX's delimiter toggle list
let g:vimtex_delim_toggle_mod_list = [
  \ ['\left', '\right'],
  \ ['\big', '\big'],
  \]

" Example: make `<leader>wc` call the command `VimtexCountWords`;
noremap <leader>wc <Cmd>VimtexCountWords<CR>

" ...or single-shot compilation, if you prefer.
nmap <localleader>c <Plug>(vimtex-compile-ss)
nmap <localleader>v <plug>(vimtex-view)
" Filter out some compilation warning messages from QuickFix display
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'LaTeX Warning: .\+ float specifier changed to',
      \ 'LaTeX hooks Warning',
      \ 'Package siunitx Warning: Detected the "physics" package:',
      \ 'Package hyperref Warning: Token not allowed in a PDF string',
      \]

if has("unix") == 1
  let g:vimtex_view_method='zathura'
elseif has("win32") == 1
  let g:vimtex_view_method='SumatraPDF'
end

if !exists("g:vim_window_id")
  let g:vim_window_id = system("xdotool getactivewindow")
endif

  function! s:TexFocusVim() abort
    sleep 400m  " Give window manager time to recognize focus moved to Zathura
    silent execute "!xdotool windowfocus " . expand(g:vim_window_id)
    redraw!
  endfunction

  augroup vimtex_event_focus
    au!
    au User VimtexEventView call s:TexFocusVim()
  augroup END
compiler tex
