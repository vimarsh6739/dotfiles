let data_dir = has('nvim') ? stdpath('data') . '/site' : expand('~/.vim')
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . shellescape(data_dir . '/autoload/plug.vim') . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugged')
Plug 'tpope/vim-fugitive'
Plug 'prabirshrestha/vim-lsp'
call plug#end()

set clipboard=unnamedplus,unnamed

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
