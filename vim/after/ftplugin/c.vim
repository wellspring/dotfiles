"________________________________________________________________________________________________________________________________________
" [local config]
"================

setlocal ts=4 sts=4 sw=4 expandtab

"________________________________________________________________________________________________________________________________________
" [shortcuts]
"=============
noremap   <leader>i   <Esc>gg?#include<CR>o#include <LT>.h><Left><Left><Left>|    " Add a new system include (at the top of the file)
noremap   <leader>I   <Esc>gg?#include<CR>o#include ".h"<Left><Left><Left>|       " Add a new local include (at the top of the file)

"noremap  <leader>a        " Add a new argument to the function
"noremap  <leader>A        " Add a new attribute to the class
"noremap  <leader>l        " Add a new local variable

"noremap  <leader>vf   <Esc>:exec "?".substitute(tagbar#currenttag('%s','No current tag :/'),"()$","","")."(\\_[^{;]*)" <bar> nohl<CR>viw
"noremap  <leader>va       " Select the 1st argument of the current function
"noremap  <leader>va4      " Select the 4th argument of the current function
"noremap  <leader>vb       " Select the current block
"noremap  <leader>vif      " Select the current if() block
"noremap  <leader>vs       " Select the current switch() block
"noremap  <leader>vl       " Select the current for/while/do loop block

"noremap  <leader>cf       " Rename the current function (using :S from abolish.vim) in the whole file(s?)
"noremap  <leader>cc       " Rename the current class (using :S from abolish.vim) in the whole file(s?)
"noremap  <leader>cA       " Rename the current attribute (using :S from abolish.vim) in the whole file(s?)

" Possibility to select the function with its documentation in text objects
" RIGHT in visualmode should move to the next argument/statement
" SHIFT+RIGHT in visualmode should move the argument/statement to the right


"----
"not working:
"noremap <leader>va <Esc>:exec "?" . substitute(tagbar#currenttag('%s','No current tag :/'),"()$","","") . "(\\_[^{;]*)?;/(/e+1"<CR>:nohl<CR>vaa

