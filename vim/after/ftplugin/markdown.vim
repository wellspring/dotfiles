"________________________________________________________________________________________________________________________________________
" [local config]
"================

setlocal ts=2 sts=2 sw=2 expandtab fo+=naw fo-=c12 textwidth=75
setlocal formatlistpat=^\\s*\\d\\+(\\.\\d\\+)*[\\]/:.)}]\\+\\s\\+\|^\\s*[-~*+]\\s\\+\|^\\s*\\[.\\{-1,}\\]:\\?\\s*
setlocal conceallevel=2

highlight ExtraWhitespace ctermbg=NONE guibg=NONE


" Markdown specific (plasticboy/vim-markdown plugin)
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_fenced_languages = ['bash=sh', 'ruby', 'erb=eruby', 'python', 'rust=rs', 'c++=cpp', 'html', 'css', 'scss=sass', 'coffee', 'js=javascript', 'json=javascript', 'xml', 'ini=dosini']
let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_folding_level = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_math = 1
let g:tex_conceal = ""

" RFC (and other docs) specific: READ ONLY
autocmd BufNewFile,BufReadPost /disk/doc/* set readonly textwidth=72

" Markdown specific keyboard shortcuts...
nnoremap <buffer>     #         :s/^\(\s*#*\)\s*/\1# /<cr>|          " -: Markdown title. (prepend  with '# ')
noremap  <buffer>     -         :s/^\s*/&- /<cr>A|                   " -: Markdown list. (prepend lines with '- ')
noremap  <buffer>     >         :s/^\s*/&> /<cr>|                    " >: Markdown quote. (prepend lines with '> ')
noremap  <buffer>     <         :s/^\(\s*\)> /\1/<cr>|               " <: Markdown unquote. (remove '> ' at the beginning of each lines)
vnoremap <buffer>     C         "cdI```<cr>```<esc>"cP<up>A|         " C: Markdown code block.
vnoremap <buffer>     c         :s/\%V.*\%V/`&`/<cr>|                " c: Markdown code.
vnoremap <buffer>     s         :s/\%V.*\%V/~~&~~/<cr>|              " s: Markdown strikethrough.
vnoremap <buffer>     i         :s/\%V.*\%V/_&_/<cr>|                " i: Markdown italic.
vnoremap <buffer>     b         :s/\%V.*\%V/**&**/<cr>|              " b: Markdown bold.

"---
"NOTE: disabled +a formatoptions (automatic formatting of paragraphs, forcing
"to do it manually with `gq` instead), as it works really badly with markdown
"sadly. It screws up things by joining lines when having lists (*/-/> bullets)
"or when having titles (underlined with ----- or =====), which just makes
"things unusable. Moved to using a map instead to do it automatically only
"when needed.
"A solution could be to add +w too? (see `:help autoformat`)
