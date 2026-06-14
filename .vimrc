let data_dir = has('nvim') ? stdpath('data') . '/site' : expand('~/.vim')
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . shellescape(data_dir . '/autoload/plug.vim') . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/vim-peekaboo'
call plug#end()

let mapleader = ' '
let maplocalleader = ' '

set timeout timeoutlen=500
set clipboard=unnamedplus,unnamed
colorscheme wildcharm

" Pending-key help, similar to which-key.nvim in Neovim.
let g:which_key_map = {}
let g:which_key_map['/'] = 'search current buffer'
let g:which_key_map['s'] = {
      \ 'name': '+search',
      \ 'h': 'help',
      \ 'k': 'keymaps',
      \ 'f': 'files',
      \ 's': 'commands',
      \ 'w': 'current word',
      \ 'g': 'grep',
      \ 'd': 'diagnostics',
      \ 'r': 'resume',
      \ '.': 'recent files',
      \ '/': 'open buffers',
      \ 'n': 'nvim files',
      \ }

nnoremap <silent> <leader> :<C-U>WhichKey '<Space>'<CR>
augroup vim_which_key
  autocmd!
  autocmd VimEnter * call which_key#register('<Space>', 'g:which_key_map')
augroup END

" Register preview for ", @, and Ctrl-R.
let g:peekaboo_delay = 0
let g:peekaboo_compact = 1

let s:register_popup = 0

function! s:close_register_popup() abort
  if exists('*popup_close') && s:register_popup > 0
    call popup_close(s:register_popup)
  endif
  let s:register_popup = 0
endfunction

function! s:register_preview_lines() abort
  let l:registers = ['"', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '+', '*', '.', '%', '#', '/', ':']
  let l:lines = ['reg  value']

  for l:register in l:registers
    let l:value = getreg(l:register)
    let l:value = substitute(l:value, "\n", '\\n', 'g')
    let l:value = substitute(l:value, "\r", '\\r', 'g')
    let l:value = substitute(l:value, "\t", '\\t', 'g')
    if strlen(l:value) > 90
      let l:value = strpart(l:value, 0, 87) . '...'
    endif
    call add(l:lines, printf('%-3s  %s', l:register, l:value))
  endfor

  return l:lines
endfunction

function! s:show_cmdline_registers() abort
  if exists('*popup_create')
    call s:close_register_popup()
    let s:register_popup = popup_create(s:register_preview_lines(), {
          \ 'line': &lines - 1,
          \ 'col': 1,
          \ 'pos': 'botleft',
          \ 'minwidth': 40,
          \ 'maxwidth': 100,
          \ 'maxheight': 14,
          \ 'time': 8000,
          \ })
  endif

  return "\<C-R>"
endfunction

cnoremap <expr> <C-R> <SID>show_cmdline_registers()

augroup vim_cmdline_register_preview
  autocmd!
  autocmd CmdlineLeave * call s:close_register_popup()
augroup END

" Automatic completion, roughly matching blink.cmp's LSP/path suggestions.
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect

imap <C-Space> <Plug>(asyncomplete_force_refresh)
imap <C-@> <Plug>(asyncomplete_force_refresh)

augroup vim_completion_sources
  autocmd!
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
        \ 'name': 'buffer',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#buffer#completor'),
        \ }))
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
        \ 'name': 'file',
        \ 'allowlist': ['*'],
        \ 'priority': 10,
        \ 'completor': function('asyncomplete#sources#file#completor'),
        \ }))
augroup END

" Fuzzy finding, mirroring the most-used Telescope bindings.
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
endif

function! s:project_root() abort
  let l:dir = expand('%:p:h')
  if empty(l:dir) || !isdirectory(l:dir)
    let l:dir = getcwd()
  endif

  let l:root = systemlist('git -C ' . shellescape(l:dir) . ' rev-parse --show-toplevel')
  if v:shell_error == 0 && !empty(l:root)
    return l:root[0]
  endif

  return getcwd()
endfunction

let s:last_search = []

function! s:remember_search(fn, args) abort
  let s:last_search = [a:fn, a:args]
endfunction

function! s:fzf_resume() abort
  if empty(s:last_search)
    echo 'No previous Vim search picker'
    return
  endif

  call call(s:last_search[0], s:last_search[1])
endfunction

function! s:fzf_files() abort
  call s:remember_search(function('s:fzf_files'), [])
  call fzf#vim#files(s:project_root(), fzf#vim#with_preview(), 0)
endfunction

function! s:fzf_grep(query) abort
  if !executable('rg')
    echoerr 'ripgrep (rg) is required for <leader>sg'
    return
  endif

  call s:remember_search(function('s:fzf_grep'), [a:query])
  call fzf#vim#grep2(
        \ 'rg --column --line-number --no-heading --color=always --smart-case --',
        \ a:query,
        \ fzf#vim#with_preview({'dir': s:project_root()}),
        \ 0)
endfunction

function! s:fzf_live_grep() abort
  call s:fzf_grep('')
endfunction

function! s:fzf_grep_current_word() abort
  call s:fzf_grep(expand('<cword>'))
endfunction

function! s:fzf_help_tags() abort
  call s:remember_search(function('s:fzf_help_tags'), [])
  execute 'Helptags'
endfunction

function! s:fzf_keymaps() abort
  call s:remember_search(function('s:fzf_keymaps'), [])
  execute 'Maps'
endfunction

function! s:fzf_commands() abort
  call s:remember_search(function('s:fzf_commands'), [])
  execute 'Commands'
endfunction

function! s:lsp_diagnostics() abort
  call s:remember_search(function('s:lsp_diagnostics'), [])
  if exists(':LspDocumentDiagnostics') != 2
    echoerr 'vim-lsp diagnostics are not available'
    return
  endif

  execute 'LspDocumentDiagnostics --buffers=*'
endfunction

function! s:fzf_oldfiles() abort
  call s:remember_search(function('s:fzf_oldfiles'), [])
  execute 'History'
endfunction

function! s:fzf_buffers() abort
  call s:remember_search(function('s:fzf_buffers'), [])
  execute 'Buffers'
endfunction

function! s:fzf_current_buffer() abort
  call s:remember_search(function('s:fzf_current_buffer'), [])
  execute 'BLines'
endfunction

function! s:fzf_open_buffers() abort
  call s:remember_search(function('s:fzf_open_buffers'), [])
  execute 'Lines'
endfunction

function! s:nvim_config_dir() abort
  for l:dir in [expand('~/.config/nvim'), expand('~/dotfiles/nvim.conf')]
    if isdirectory(l:dir)
      return l:dir
    endif
  endfor

  return expand('~')
endfunction

function! s:fzf_nvim_files() abort
  call s:remember_search(function('s:fzf_nvim_files'), [])
  call fzf#vim#files(s:nvim_config_dir(), fzf#vim#with_preview(), 0)
endfunction

nnoremap <silent> <leader>sh :call <SID>fzf_help_tags()<CR>
nnoremap <silent> <leader>sk :call <SID>fzf_keymaps()<CR>
nnoremap <silent> <leader>sf :call <SID>fzf_files()<CR>
nnoremap <silent> <leader>ss :call <SID>fzf_commands()<CR>
nnoremap <silent> <leader>sw :call <SID>fzf_grep_current_word()<CR>
nnoremap <silent> <leader>sg :call <SID>fzf_live_grep()<CR>
nnoremap <silent> <leader>sd :call <SID>lsp_diagnostics()<CR>
nnoremap <silent> <leader>sr :call <SID>fzf_resume()<CR>
nnoremap <silent> <leader>s. :call <SID>fzf_oldfiles()<CR>
nnoremap <silent> <leader><leader> :call <SID>fzf_buffers()<CR>
nnoremap <silent> <leader>/ :call <SID>fzf_current_buffer()<CR>
nnoremap <silent> <leader>s/ :call <SID>fzf_open_buffers()<CR>
nnoremap <silent> <leader>sn :call <SID>fzf_nvim_files()<CR>

" C/C++ LSP setup for Vim, mirroring the clangd setup in Neovim.
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_document_highlight_enabled = 1

function! s:clangd_root_uri() abort
  let l:root = lsp#utils#find_nearest_parent_file_directory(
        \ lsp#utils#get_buffer_path(),
        \ ['compile_commands.json', 'compile_flags.txt', '.clangd', '.git/'])

  if empty(l:root)
    let l:root = getcwd()
  endif

  return lsp#utils#path_to_uri(l:root)
endfunction

if executable('clangd')
  augroup vim_lsp_clangd
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->['clangd', '--log=verbose']},
          \ 'root_uri': {server_info->s:clangd_root_uri()},
          \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'inc'],
          \ })
  augroup END
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif

  nmap <buffer> grn <plug>(lsp-rename)
  nmap <buffer> gra <plug>(lsp-code-action)
  xnoremap <buffer> gra :LspCodeAction<CR>
  nmap <buffer> grr <plug>(lsp-references)
  nmap <buffer> gri <plug>(lsp-implementation)
  nmap <buffer> grd <plug>(lsp-definition)
  nmap <buffer> grD <plug>(lsp-declaration)
  nmap <buffer> gO <plug>(lsp-document-symbol-search)
  nmap <buffer> gW <plug>(lsp-workspace-symbol-search)
  nmap <buffer> grt <plug>(lsp-type-definition)
  nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup vim_lsp_mappings
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
