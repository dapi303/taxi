" Vim plugin to switch working directory
" Last Change: 2021 Oct 1
" Maintainer: Damian Piotrowski <dapiotrowski93@gmail.com>
" License:	This file is placed in the public domain.

if exists("g:loaded_taxi")
  finish
endif
let g:loaded_taxi = 1


if !exists("g:taxi_directories")
  let g:taxi_directories=['~/']
endif

if !hasmapto('<Plug>Taxi')
  map <C-x> <Plug>Taxi
endif
noremap <script> <Plug>Taxi :Taxi<CR>

let s:keepcpo           = &cpo

let g:taxi_buff_name = "taxi_locations"
let g:taxi_select_idx = 1
let g:taxi_add_headers = 1
let g:taxi_header_hilight = 1
let g:taxi_short_name = 1

set cpo&vim

command! TaxiOpen call s:OpenOne()
" ------------------------------------------------------------------------------
fun! s:OpenOne()
  let l:bufnr = bufwinnr(g:taxi_buff_name)
  if l:bufnr > 0
    execute l:bufnr . "wincmd w"
  else
    call s:Open()
  endif
endfun

fun! s:Open()
  call s:newBuffer()
  if bufwinnr(g:taxi_buff_name) == bufwinnr('%')
    call s:fillBuffer()
  endif
  call cursor(g:taxi_select_idx, 1)
  set cursorline
endfun

fun! s:fillBuffer()
  let s:line_nr = 1
  let s:headers = []
  let s:taxi_items = []
  for directory in g:taxi_directories
    call s:parseDir(directory)
  endfor

  let s:line_nr = 1
  for line in s:taxi_items
    if index(s:headers, s:line_nr) >= 0 || g:taxi_short_name == 0
      call setline(s:line_nr, line)
    else 
      call setline(s:line_nr, substitute(line, ".*\/", "", ""))
    endif
    let s:line_nr += 1
  endfor

  if g:taxi_header_hilight == 1
    call s:hilightHeaders()
  endif
endfun

fun! s:hilightHeaders()
  let l:pattern = ''
  for line in s:headers
    if strlen(l:pattern) > 0
      let l:pattern = l:pattern.'\|'
    endif
    let l:pattern = l:pattern.'\%'.line.'l'
  endfor

  highlight TaxiHeaderHl ctermfg=red
  execute 'match TaxiHeaderHl /'.l:pattern.'/'
endfun

fun! s:parseDir(directory)
  if g:taxi_add_headers == 1
    call add(s:headers, s:line_nr)
    call add(s:taxi_items, a:directory)
    let s:line_nr += 1
  endif

  let l:items = globpath(a:directory, '*')

  for target in split(l:items)
    call add(s:taxi_items, target)
    let s:line_nr += 1
  endfor
endfun

fun! s:newBuffer()
  silent! execute 'split new'
  silent! execute 'edit '.g:taxi_buff_name
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  map <buffer> <Enter> :call <SID>Process()<cr>
endfun

fun! s:Process()
  let l:bufnr = bufwinnr(g:taxi_buff_name)
  if l:bufnr == bufwinnr('%')
    if index(s:headers, line('.')) >= 0
      return
    endif

    if exists('s:taxi_items')
      let l:current = line('.') - 1
      let g:taxi_select_idx = l:current
      let l:file = s:taxi_items[g:taxi_select_idx]
      close
      execute 'lcd '.l:file.' |  pwd | e .'
    endif
  endif
endfun

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
