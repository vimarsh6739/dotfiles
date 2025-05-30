" Vim filetype plugin file
" Language: MLIR Assembly
" Maintainer: The MLIR team

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal softtabstop=2 shiftwidth=2
setlocal expandtab
setlocal comments+=://
setlocal commentstring=//\ %s
setlocal synmaxcol=10000
" We treat sequences of the following characters as forming 'keywords', with
" the aim of easing movement around MLIR identifiers:
" * identifier prefixes: '%' and '@' (@-@)
" * all characters where isalpha() returns TRUE (@)
" * the digits 0-9 (48-57)
" * other characters that may form identifiers: '_', '.', '-', '$'
" Comment this out to restore the default behaviour
setlocal iskeyword=%,@-@,@,48-57,_,.,-,$

