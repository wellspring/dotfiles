" [Eclipse Specific]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui')
  set guioptions-=m " turn off menu bar
  set guioptions-=T " turn off toolbar
  set number        " show line numbers
else
  let g:CSApprox_loaded = 1
endif

