"**************************************************************************"
"*** .vimrc wellspring's file -- Thanks to the authors of the functions ***"
"**************************************************************************"

" [General]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Activer toutes fonctionalités de VIM (imcompatible avec VI)
set nocompatible
" Changer le nombre de ligne gardée dans l'historique de vim
set history=200
" Changer le <leader>
let mapleader = ","
" Laisser une marge de 5 lignes lors d'un scroll
set scrolloff=3
" Influence le comportement de backspace
set backspace=2
" Ignorer la case lors des recherches
"set ignorecase
" Commencer les recherches pendant la frappe
set incsearch
" Change la taille de la barre horizontale à gauche
set numberwidth=3
" Change le nombre d'espace prit par une tabulation
set shiftwidth=4
set tabstop=4
" Utiliser des espaces a la places des tabulations
set expandtab
" Activer l'indentation automatique de vim
set autoindent
" Activer la coloration syntaxique
syntax on
" Activer le retour a la ligne automatique
set wrap
" DéActiver la souris dans tous les modes
set mouse=a
" Désactive l'affichage des numeros de ligne lorsque l'on programme
set nonumber
" Affichage de la position du curseur dans la ligne de status
set ruler
" Affichage d'une liste lors de l'utilisation de la touche TAB
set wildmode=list:longest,full
" Affichage du mode et de la commande dans la ligne de status
set showmode
set showcmd
" Actualiser le fichier lorsqu'il est modifié par un autre programme
set autoread
" Se place par rapport au dossier du fichier en cours
set autochdir
" Montrer les caracteres de fin de ligne
"set list
set listchars=eol:¤,trail:-
" Definir une palette de couleurs
colors desert
set t_Co=256
"let xterm16_brightness = 'default'
"let xterm16_colormap = 'soft'
"colo xterm16 
" set completeopt as don't show menu and preview
set completeopt=menuone,menu,longest,preview
" Popup menu hightLight Group
highlight Pmenu ctermbg=13 guibg=LightGray
highlight PmenuSel ctermbg=7 guibg=DarkBlue guifg=White
highlight PmenuSbar ctermbg=7 guibg=DarkGray
highlight PmenuThumb guibg=Black
" MiniBufExplorer colors
highlight MBENormal guibg=LightGray guifg=DarkGray
highlight MBEChanged guibg=Red guifg=DarkRed
highlight MBEVisibleNormal term=bold cterm=bold gui=bold guibg=Gray guifg=Black
highlight MBEVisibleChanged term=bold cterm=bold gui=bold guibg=DarkRed guifg=Black

" [Plugins]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:miniBufExplMapWindowNavVim = 0
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplUseSingleClick = 1

let OmniCpp_NamespaceSearch = 2
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_DefaultNamespaces = ["std"]
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_SelectFirstItem = 0

let b:usemarks = 0

" [Functions]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CloseProject() 
" Close Project window
   let current_bf = bufnr('%')
   :Project
   let project_bf = bufnr('%')
   :bw
   if current_bf != project_bf
       exe bufwinnr(current_bf).'wincmd w'
   endif
endfunction
command! -nargs=0 CloseProject :call s:CloseProject()

function! ToggleProject()
" Toggle Project plugin open or not.
    if exists('g:proj_running')
        :CloseProject
		echo "Project plugin is now closed."
    else
        :Project
		echo "Project plugin is now opened."
    endif
endfunction

function! ToggleMousePaste()
" Toggle Mouse and Paste activated or not.
	if &mouse == "a"
		set paste
		set mouse=
		echo "Mouse is off and Paste is on."
	else
		set nopaste
		set mouse=a
		echo "Mouse is on and Paste is off."
	endif
endfunction

function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" [Mapping]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Aide de vim
noremap <F1> <Esc>:help<Space>
" Désactiver le surlignage des recherches et passer en mode insertion
noremap <F2> <Esc>:nohl<CR>
" Sauvegarde rapide et retour en mode insertion
noremap <F3> <Esc>:w!<CR>
" Passer ou non en mode collage avec la touche F4
noremap <F4> <Esc>:call ToggleMousePaste()<CR>
" Activer ou desactiver VimCommander avec la touche F11
noremap <F12> <Esc>:cal VimCommanderToggle<CR>
" Sauvegarde en mode insertion avec CTRL+s
inoremap <C-s> <Esc>:w!<CR>
" Ferme le tampon actif
noremap <C-w> <Esc>:Bclose<CR>
" Passe du fichier source au fichier de header (.c <-> .h)
noremap . <Esc>:A<CR>
" Va au tampon precedent/suivant
noremap + <Esc>:MBEbp<CR>
noremap - <Esc>:MBEbn<CR>
" Se déplacer dans les fenetres plus rapidement avec CTRL+h/j/k/l
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
" Utiliser les onglets plus rapidement
noremap <leader>tn :tabnew %<CR>
noremap <leader>te :tabedit
noremap <leader>tc :tabclose<CR>
noremap <leader>tm :tabmove
" Cree le fichier ctags
noremap <F2> <Esc>:silent !ctags --fields=afiKmsSzn *<CR>:redraw!<CR>
" Smart mapping for tab completion (Tip #102)
inoremap <Tab> <c-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-x><C-o>
" Ecrit rapidement un main en C
iab xmain int main (int argc, char **argv<right><cr>{
" Dupliquer la ligne en mode insertion
inoremap <C-d> <Esc>yypi
" Inserer rapidement le chemin et dossier du fichier
cnoremap >fn <C-r>=expand('%:p')<CR>
cnoremap >fd <C-r>=expand('%:p:h').'/'<CR>
" Ecrire l'heure et la date plus rapidement
iab xdate <C-r>=strftime("%d/%m/%y")<CR>
iab xtime <C-r>=strftime("%H:%M:%S")<CR>
" Utiliser les marques en programmation
imap <M-Insert> !mark!
imap <M-Delete> !jump!
imap <M-S-Delete> !jumpB!
imap <C-J> <Plug>MarkersJumpF
map  <C-J> <Plug>MarkersJumpF
imap <C-K> <Plug>MarkersJumpB
map  <C-K> <Plug>MarkersJumpB
imap <C-<> <Plug>MarkersMark
vmap <C-<> <Plug>MarkersMark

