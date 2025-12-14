
" Settings for compiling LaTeX documents
if exists("current_compiler")
  finish
endif
let current_compiler = "tex"

" ------------------------------------------------------------
" Base commands for :make (filename '%' is appended later)
" ------------------------------------------------------------
let s:pdflatex_base = 'pdflatex -file-line-error -interaction=nonstopmode ' .
      \ '-halt-on-error -synctex=1 -output-directory=%:h'
let s:latexmk_base  = 'latexmk -pdf -output-directory=%:h'

" ------------------------------------------------------------
" Buffer-local state
" ------------------------------------------------------------
let b:tex_use_latexmk = 0
let b:tex_use_shell_escape = 0

" ------------------------------------------------------------
" Detect minted in the preamble (before \begin{document})
" ------------------------------------------------------------
silent execute '!sed "/\\begin{document}/q" ' . expand('%') . ' | grep "minted" > /dev/null'
if v:shell_error
  let b:tex_use_shell_escape = 0
else
  let b:tex_use_shell_escape = 1
endif

" ------------------------------------------------------------
" Ensure VimTeX latexmk config exists (VimTeX reads GLOBAL config)
" ------------------------------------------------------------
function! s:EnsureVimtexLatexmkConfig() abort
  if !exists('g:vimtex_compiler_latexmk') || type(g:vimtex_compiler_latexmk) != v:t_dict
    let g:vimtex_compiler_latexmk = {}
  endif

  " Keep whatever engine user has; only ensure options list exists
  if !has_key(g:vimtex_compiler_latexmk, 'options') || type(g:vimtex_compiler_latexmk.options) != v:t_list
    let g:vimtex_compiler_latexmk.options = [
          \ '-verbose',
          \ '-file-line-error',
          \ '-synctex=1',
          \ '-interaction=nonstopmode',
          \ ]
  endif
endfunction

" ------------------------------------------------------------
" Update VimTeX latexmk options to match b:tex_use_shell_escape
" (NO recompilation triggered here)
" ------------------------------------------------------------
function! s:VimtexApplyShellEscape() abort
  call s:EnsureVimtexLatexmkConfig()

  " Remove shell-escape flags if present
  call filter(g:vimtex_compiler_latexmk.options, {_, v ->
        \ v !=# '-shell-escape' && v !=# '--shell-escape' && v !=# '-no-shell-escape'
        \ })

  " Add -shell-escape if enabled
  if b:tex_use_shell_escape
    call add(g:vimtex_compiler_latexmk.options, '-shell-escape')
  endif
endfunction

" ------------------------------------------------------------
" :make integration (makeprg)
" ------------------------------------------------------------
function! s:TexSetMakePrg() abort
  if b:tex_use_latexmk
    let l:cmd = s:latexmk_base
    " For plain :make + latexmk, pass shell-escape down to LaTeX
    if b:tex_use_shell_escape
      let l:cmd .= ' -latexoption=-shell-escape'
    endif
  else
    let l:cmd = s:pdflatex_base
    if b:tex_use_shell_escape
      let l:cmd .= ' -shell-escape'
    endif
  endif

  " filename LAST (important for pdflatex options!)
  let &l:makeprg = l:cmd . ' %'
endfunction

" ------------------------------------------------------------
" Toggles
" ------------------------------------------------------------
function! s:TexToggleLatexmk() abort
  let b:tex_use_latexmk = !b:tex_use_latexmk
  call s:TexSetMakePrg()
  echo 'latexmk(for :make)=' . b:tex_use_latexmk
endfunction

function! s:TexToggleShellEscape() abort
  let b:tex_use_shell_escape = !b:tex_use_shell_escape

  " Update :make command
  call s:TexSetMakePrg()

  " Update VimTeX latexmk flags (no compilation)
  call s:VimtexApplyShellEscape()

  echo 'shell_escape=' . b:tex_use_shell_escape
endfunction

" ------------------------------------------------------------
" Key mappings (buffer-local, direct)
" ------------------------------------------------------------
nnoremap <buffer> <leader>te :call <SID>TexToggleShellEscape()<CR>
nnoremap <buffer> <leader>tl :call <SID>TexToggleLatexmk()<CR>

" ------------------------------------------------------------
" Initialize makeprg + VimTeX flags once for this buffer
" ------------------------------------------------------------
call s:TexSetMakePrg()
call s:VimtexApplyShellEscape()

" ------------------------------------------------------------
" errorformat (your original)
" ------------------------------------------------------------
setlocal errorformat=%-P**%f
setlocal errorformat+=%-P**\"%f\"

setlocal errorformat+=%E!\ LaTeX\ %trror:\ %m
setlocal errorformat+=%E%f:%l:\ %m
setlocal errorformat+=%E!\ %m

setlocal errorformat+=%Z<argument>\ %m
setlocal errorformat+=%Cl.%l\ %m

setlocal errorformat+=%-G%.%#

