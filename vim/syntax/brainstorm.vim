" Vim syntax file
" Language:             Minimal alternative to markdown for brainstorming about various project that doesn't have their own file yet.
" Maintainer:           None.
" Last Change:          17 dec 2017
"
" e.g.
" -----
" [categ][categ][categ] Text with `code` (e.g. foo bar, see also http://... and http://...) -- and ask Jeff.
"   - list
" -----

if exists("b:current_syntax")
  finish
endif

" -- Syntax
syn match  Comment    "^\s*#.*"
syn match  Section    "^\s*\[\S\+\]" nextgroup=Idea
syn region Code       start=" `" end="` \?"
syn region String     start=" '" end="' \?"
syn region String     start=" \"" end="\" \?"
syn region Precision  start="\s(" end=")" contains=Example,SeeAlso,Special,Highlight,Extra,Code
syn match  Example    "e\.g\.\s\+[^)]*" contains=SeeAlso,Special,Highlight,Extra,Code
syn match  List       "^\s*\(\d\+\(\.\d\+\)*[\]/:.\)}]\+\|[-~*+>]\)\s\+" nextgroup=ListText
syn match  SeeAlso    "\(like\|see\|and\|or\):\?\s\+\(\S\+:\?\s\+\)\?https\?:[^ )]\+"
syn match  SeeAlso    "https\?:[^ )]\+"
syn match  Extra      "\s\+-[-\>]\s\+"
syn match  Extra      "\s\+\/\{2,}\s\+[^)]\+"
syn match  Special    "\(TODO\|DONE\|WARNING\):" nextgroup=SpecialDescription
syn match  Highlight  "\(COOL\|BEST\|AWESOME\|URGENT\|NOW\)"
syn match  Number     "\d\+"
syn match  Number     "[\\0]x[A-Fa-f0-9]\+"

" -- Color
hi Comment   ctermfg=240
hi Section   ctermfg=2
hi Idea      ctermfg=253
hi Precision ctermfg=245
hi Example   ctermfg=245 cterm=italic
hi SeeAlso   ctermfg=208
hi Extra     ctermfg=4
hi Code      ctermfg=198
hi List      ctermfg=2
hi Special   ctermfg=1
hi Highlight ctermfg=1
hi Number    ctermfg=3
hi String    ctermfg=3

" -- Extra settings
setlocal textwidth=10000 fo-=a noexpandtab
setlocal commentstring=#\ %s
let g:endwise_no_mappings = 1
let g:AutoPairsMapCR = 0

" -- Extra shortcuts
"[NORMAL]
nmap     <buffer>   ci      	:s/^\(\s*\S\+\s\+\).*$/\1/<cr>A|                     " Change idea (or list item) (ci)
nmap     <buffer>   O       	"syy"sPci|                                           " Insert a new idea before   (Shift+O)
nmap     <buffer>   <S-CR>  	O|                                                   " Insert a new idea before   (Alt+Enter)
nmap     <buffer>   o       	"syy"spci|                                           " Insert a new idea after    (o)
nmap     <buffer>   <CR>    	o|                                                   " Insert a new idea after    (Enter)
nnoremap <buffer>   !       	o<cr>[]<space><left><left>|                          " Insert a new section after (!)
"[INSERT]
imap     <buffer>   <CR>    	<Esc>o|                                              " Insert a new idea after    (Enter, in insert mode)
inoremap <buffer>   [13;2u  <Esc>o<space><space>-<space>|                        " Insert a new list after    (Shift+Enter, in insert mode) -- a bit confusing indeed
inoremap <buffer>   [13;5u  <Esc>o<space><space>-<space>|                        " Insert a new list after    (Ctrl+Enter, in insert mode) -- a bit confusing indeed
inoremap <buffer>   <CR>  	<Esc>o<space><space>-<space>|                        " Insert a new list after    (Alt+Enter, in insert mode) -- a bit confusing indeed
imap     <buffer>   <Tab>   	<Esc>?\s*\[<cr>"syy''"spci|                          " Insert a new idea after    (Enter, in insert mode)


