" vim config
"------------------------------
" [README]
" ========
"
" Install these tools:
"   $ pacman -S the_silver_searcher astyle js-beautify ctags
"
" Then, in order to setup vim, please run the command:
"   :PlugInstall
"------------------------------

"________________________________________________________________________________________________________________________________________________________________________
"
" [VIM Plugin Manager]: Init plug + load plugins
" ==============================================

call plug#begin('~/.vim/plugged')

  " --- (color schemes)
  Plug 'vim-scripts/Lucius'                                                       " [ColorScheme] Lucius                                       +++
  Plug 'tomasr/molokai'                                                           "|[ColorScheme] Molokai                                      +++
  Plug 'vim-scripts/BusyBee'                                                      "|[ColorScheme] BusyBee (dark/blue/supergreen/grey/orange)   +++  // super clear !
 "Plug 'reedes/vim-colors-pencil'                                                 "|[ColorScheme] Pencil (dark/pink/blue OR light)             +++
  Plug 'jordwalke/flatlandia'                                                     "|[ColorScheme] FlatLand (dark/orange/blue/green)            +++
 "Plug 'morhetz/gruvbox'                                                          "|[ColorScheme] Gruvbox (dark/green*3/pink/orange)           ++
  Plug 'nanotech/jellybeans.vim'                                                  "|[ColorScheme] JellyBeans (dark/verypink/blue/green)        ++
 "Plug 'Lokaltog/vim-distinguished'                                               "|[ColorScheme] Distinguished (dark/orange/blue/green)       ++
 "Plug 'nowk/genericdc'                                                           "|[ColorScheme] genericdc (dark/blue/grey/orange OR light)   ++
 "Plug 'ChasingLogic/ChasingLogic-colorscheme-vim'                                "|[ColorScheme] ChasingLogic (dark/pink/blue)                ++
 "Plug 'vim-scripts/rdark'                                                        "|[ColorScheme] rdark (dark/orange/green)                    ++
 "Plug 'goatslacker/mango.vim'                                                    "|[ColorScheme] mango (dark/purple/orange/green OR light)    ++
 "Plug 'larssmit/vim-getafe'                                                      "|[ColorScheme] getafe (dark/blue/green/purple)              ++
 "Plug 'altercation/vim-colors-solarized'                                         "|[ColorScheme] Solarized (darkblue/blu/green/grey OR light) ++
 "Plug 'gregsexton/Atom'                                                          "|[ColorScheme] Atom (silverblue/red OR light)               ++
 "Plug 'zeis/vim-kolor'                                                           "|[ColorScheme] Kolor (darkbrown/yellow/purple/orange/red)   +
 "Plug 'jeetsukumaran/vim-mochalatte'                                             "|[ColorScheme] MochaLatte (brown/orange/beige/green)        +
 "Plug 'vim-scripts/greenvision'                                                  "|[ColorScheme] greenvision (dark & green, matrix style)     +
 "Plug 'vyshane/vydark-vim-color'                                                 "|[ColorScheme] vydark (dark/lightgreen/lightblue/beige)    ?
 "Plug 'adlawson/vim-sorcerer'                                                    "|[ColorScheme] Sorcerer (dark/green/blue/beige/orange)     ?
 "Plug 'gilsondev/lizard'                                                         "|[ColorScheme] Lizard256 (dark/red/green)                  ?
 "Plug 'abra/vim-abra'                                                            "|[ColorScheme] arba (dark/darkblue/green/orange)           ?
 "Plug 'baverman/vim-babymate256'                                                 "|[ColorScheme] BabyMate256 (dark/pastelredgreenblue)        +++
 "Plug 'antlypls/vim-colors-codeschool'                                           "|[ColorScheme] CodeSchool (silverblue/orange/blue/green)    +++
 "Plug 'mikesimons/vim-color-wombat'                                              "|[ColorScheme] Wombat (dark/blue/green/white)               +++
 "Plug 'vim-scripts/wombat256.vim'                                                "|[ColorScheme] Wombat256 (dark/blue/green/white)            +++
 "Plug 'vim-scripts/twilight256.vim'                                              "|[ColorScheme] Twilight256 (dark)                           +++
 "Plug 'chriskempson/vim-tomorrow-theme'                                          "|[ColorScheme] Tomorrow & TomorrowNight (light OR dark)     +++
 "Plug 'vim-scripts/Visual-Studio'                                                "|[ColorScheme] Visual Studio (light)                        ...
 "Plug 'jpo/vim-railscasts-theme'                                                 "|[ColorScheme] RailsCasts (dark/orange/yellow/green/blue)   ...
 "Plug 'uu59/vim-herokudoc-theme'                                                 "|[ColorScheme] Heroku doc (silverblue/supergreen)           ...
 "Plug 'croaky/vim-colors-github'                                                 "|[ColorScheme] Github (light)                               ...

  " --- (general)
  Plug 'junegunn/vim-easy-align', { 'on' : 'EasyAlign' }                          " Align
 "Plug 'vim-scripts/Align', { 'on' : 'Align' }                                    "|Align
 "Plug 'godlygeek/tabular', { 'on' : 'Tab' }                                      "|Align
  Plug 'terryma/vim-multiple-cursors'                                             " Multi-cursor editing in vim (like sublime text)
  Plug 'Lokaltog/vim-easymotion'                                                  " Goto part of the code quickly (\w for target char, \\s, \\f, ...)
  Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert'] }                      " Improved abreviations & search & replace (using :S/ and :%S///g)
  Plug 'tpope/vim-surround'                                                       " surround helpers: change/delete/add  parenthesis/brackets/quotes/tags/...
  Plug 'vim-scripts/auto-pairs'                                                   " auto-closing brackets/quotes + support for ''', space/enter indentation, ...
 "Plug 'kana/smartinput'                                                          "|auto-closing brackets/quotes (similar to auto-pairs, care for escapes, lisp&C syntax)
 "Plug 'vim-scripts/simple-pairs'                                                 "|auto-closing brackets/quotes (similar to auto-pairs, less aggressive -- needs python)
 "Plug 'Raimondi/delimitMate'                                                     "|auto-closing brackets/quotes (similar to auto-pairs -- doesnt work with html :/)
 "Plug 'vim-scripts/netrw.vim'                                                    "|File explorer (in the current window, without using a separated project drawer)
  Plug 'scrooloose/nerdtree'                                                      " File explorer
  Plug 'tomtom/tcomment_vim'                                                      " Comments (better than nerdcommenter)
 "Plug 'scrooloose/nerdcommenter'                                                 "|Comments
  Plug 'scrooloose/syntastic'                                                     " Syntax checking (> 80 lang!!)
 "Plug 'tomtom/checksyntax_vim'                                                   "|runs a syntax check for the current buffer when saving (bash/c/cpp/haskell/html/...)
 "Plug 'vim-scripts/taglist.vim'                                                  "|Tags
  Plug 'majutsushi/tagbar'                                                        " Tags                            { 'on': 'TagbarToggle' }
  Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }                           " Format/indent the code properly (C/C++/C#/ObjC/Java/Python/HTML/CSS/JS/RUBY)
  Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }       " Code completion (C/C++/Python/Ruby/PHP/...)
  Plug 'Shougo/neocomplete.vim'                                                   " Completion engine with cache (even for directories!!)
  Plug 'ervandew/supertab'                                                        " Allow to use TAB for completions (to make Ultisnips work with YouCompleteMe)
  Plug 'SirVer/ultisnips'                                                         " Snippets engine  (new snipmate)
  Plug 'honza/vim-snippets'                                                       " Snippets
  Plug 'Keithbsmiley/investigate.vim'                                             " Doc
  Plug 'tpope/vim-endwise'                                                        " Automatically add 'end' (lua/elixir/ruby/crystal/sh/zsh/vb/vim/c/cpp/objc/matlab)
  Plug 'vim-scripts/IndexedSearch'                                                " when searching with /,?,n,N,*,#, display 'at match #XX out of YY'
  Plug 'rking/ag.vim', { 'on': 'Ag' }                                             " grep/ack search alternative (faster)
  Plug 'Shougo/unite.vim', {'on': 'Unite'}                                        " Search easily for files and buffers (alt to fuzzyfinder/ctrlp)
  Plug 'tsukkee/unite-tag', {'on': 'Unite'}                                       " Search easily for tags -- plugin for Unite
  Plug 'Shougo/unite-outline', {'on': 'Unite'}                                    " Search easily for headlines (class structure, html titles, ...) -- plugin for Unite
 "Plug 'szw/vim-ctrlspace'                                                        "|Alternative to unite (to search easily file/buffers)
  Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }                               " Fuzzy
  Plug 'Shougo/vinarise.vim', {'on': 'Vinarise'}                                  " Hex editing
  Plug 'chrisbra/vim-diff-enhanced'                                               " Diff  (better side-by-side view)
  Plug 'chrisbra/NrrwRgn', { 'on': ['NR'] }                                       " edit the visual in another tab/window (inspired by the narrow feature of emacs)
  Plug 'duff/vim-scratch', { 'on': ['Scratch','sScratch'] }                       " tmp scratch buffer (discarded when vim exit)
  Plug 'nathanaelkane/vim-indent-guides', { 'on': 'IndentGuidesEnable' }          " Color the indentation
  Plug 'moll/vim-bbye', { 'on': 'Bdelete' }                                       " Simple buffer close (inspired by Bclose.vim, but rewritten to be perfect)
 "Plug 'rbgrouleff/bclose.vim', { 'on': 'Bclose' }                                "|Simple buffer close
 "Plug 'fholgado/minibufexpl.vim'                                                 "|Buffer explorer/switcher (elegant & minimal)
  Plug 'vim-scripts/restore_view.vim'                                             " Restore the view of a file (cursor position + folding) when opening it again
  Plug 'vasconcelloslf/vim-interestingwords', { 'on': 'InterestingWords' }        " Highlight multiple words (\k to add a new match, \K to remove all matches)
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }                                     " Asynchronous process manager
 "Plug 'Shougo/vimshell.vim'                                                      "|Shell (vim based)
 "Plug 'vim-scripts/recover.vim'                                                  "|When using file recovery, show a diff :)
 "Plug 'tpope/vim-eunuch'                                                         "|sugar for UNIX shell commands that need it the most (Remove, Move, Mkdir, ...)
 "Plug 'tpope/vim-speeddating'                                                    "|increment/decrement dates (with ctrl+a / ctrl+x)
 "Plug 'editorconfig/editorconfig-vim'                                            "|help to maintain config by projects (indentation, charset, ...)
 "Plug 'sjl/gundo.vim'                                                            "|visualize your Vim undo tree
 "Plug 'sjbach/lusty'                                                             "|fast file opener + buffer switcher
 "Plug 'tpope/vim-repeat'                                                         "|Enable to use '.' (repeat action) with various plugins too
 "Plug 'tommcdo/vim-exchange'                                                     "|Exchange words/lines easily (e.g. cxiw for words, cxx for line, X in visual...)
 "Plug 'tpope/vim-afterimage'                                                     "|Image editing inside vim (ico, png, gif) by converting them to XPM with imagemagick
 "Plug 'vim-scripts/DrawIt'                                                       "|ASCII drawing
 "Plug 'Twinside/vim-codeoverview.git'                                            "|Overview on the side (like sublimetext's minimap, resize automatically!)
 "Plug 'jpalardy/vim-slime'                                                       "|Send text to screen/tmux/REPL easily from vim!
 "Plug 'FredKSchott/CoVim'                                                        "|Shared vim session (like googledoc) with multi cursors

  " --- (specific languages)
  Plug 'vim-scripts/c.vim', {'for': ['c', 'cpp']}                                 " [C/C++] Statement oriented editing of C / C++ programs (to speed up writing code)
  Plug 'vim-scripts/cSyntaxAfter', {'for': ['c', 'cpp']}                          " [C/C++] Operator highlighting for C-like languages
  Plug 'vim-scripts/gtk-vim-syntax', {'for': ['c', 'cpp']}                        " [C/C++] Syntax highlighting for GLib, Gtk+, Xlib, Gimp, Gnome, and more.
  Plug 'justinmk/vim-syntax-extra', {'for': ['c','lex','yacc']}                   " [C/C++] extra syntax highlighting for c, bison, flex
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}                  " [C/C++] extra syntax highlighting for C++11/14
  Plug 'vim-scripts/a.vim', {'for': ['c', 'cpp']}                                 " [C/C++] switch to .c/.h or .cpp/.hpp easily !
  Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp']}                            " [C/C++] help to re-format properly the code
  Plug 'jaxbot/browserlink.vim', {'for': ['html','css','javascript']}             " [HTML] Live-reload (realtime edit + sync webinspector changes back to code)
  Plug 'mattn/emmet-vim', {'for': ['html','css','javascript']}                    " [HTML] Emmet HTML abreviations completion (new zencoding)
  Plug 'othree/html5.vim', {'for': 'html'}                                        " [HTML] HTML5 omnicomplete and syntax
  Plug 'vim-scripts/HTML-AutoCloseTag', {'for': ['html', 'xml']}                  " [HTML] Auto-close tag :)
  Plug 'gregsexton/MatchTag', {'for': ['html', 'xml']}                            " [HTML] Highlight matching tag
  Plug 'tmhedberg/matchit', {'for': ['html', 'xml']}                              " [HTML] Goto the opposite matched tag with %
  Plug 'vim-scripts/loremipsum', {'for': 'html', 'on': 'Loremipsum'}              " [HTML] Lorem ipsum
  Plug 'slim-template/vim-slim', {'for': 'slim'}                                  " [HTML/SLIM] Slim syntax
  Plug 'digitaltoad/vim-jade', {'for': 'jade'}                                    " [HTML/JADE] Jade syntax
  Plug 'tpope/vim-haml', {'for': ['haml', 'scss', 'sass']}                        " [HTML/HAML] HAML/SASS/SCSS syntax
  Plug 'lilydjwg/colorizer', {'for': ['css','javascript','json']}                 " [CSS] Colorize colors (#XXX, #XXXXXX, rgb/rgba)
  Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }                                 " [CSS] CSS3 syntax
  Plug 'rstacruz/vim-ultisnips-css', { 'for': ['css', 'scss'] }                   " [CSS] Extra snippets for css (to write much faster, lazy 2 char :D)
  Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }                             " [CSS/SCSS] SASS/SCSS syntax
  Plug 'groenewege/vim-less', {'for': 'less'}                                     " [CSS/LESS] Less syntax
  Plug 'wavded/vim-stylus', {'for': 'stylus'}                                     " [CSS/STYLUS] Stylus syntax
  Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'json'] }               " [JS] Javascript lang
  Plug 'itspriddle/vim-jquery', { 'for': ['javascript', 'html'] }                 " [JS] JQuery
  Plug 'moll/vim-node', { 'for': ['javascript'] }                                 " [JS] node.js (easy module opening)
  Plug 'elzr/vim-json', { 'for': ['javascript', 'json', 'cson'] }                 " [JS] JSON syntax
  Plug 'tpope/vim-jdaddy', { 'for': 'json' }                                      " [JS] JSON helpers (pretty printer, ...)
  Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}                              " [JS/COFFEESCRIPT] Coffeescript lang
  Plug 'gkz/vim-ls', {'for': 'ls'}                                                " [JS/LIVESCRIPT] Livescript lang
  Plug 'maksimr/vim-jsbeautify', {'for': ['js', 'css', 'html', 'jsx', 'json']}    " [HTML/CSS/JS] Code beautifuler
  Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                                       " [RUBY] Ruby lang
  Plug 'tpope/vim-rails', {'for': 'ruby'}                                         " [RUBY] Ruby on Rails framework
  Plug 'ngmy/vim-rubocop', {'for': 'ruby'}                                        " [RUBY] Ruby static code analyzer (many guidelines)
  Plug 't9md/vim-ruby-xmpfilter', {'for': 'ruby'}                                 " [RUBY] exec ruby code as comment (cool! :D)
  Plug 'basyura/unite-rails', {'on': 'Unite', 'for': 'ruby'}                      " [RUBY] Search easily for models/controllers/views/helpers/... in rails
  Plug 'tpope/vim-rvm', { 'for': 'ruby', 'on': 'Rvm' }                            " [RUBY] Switch rvm versions from inside (e.g. :Rvm 1.9.2)
  Plug 'tpope/vim-bundler', { 'for': 'ruby', 'on': ['Bundle','Bopen'] }           " [RUBY] Lightweight bundler wrapper
  Plug 'tpope/vim-rake', { 'for': 'ruby' }                                        " [RUBY] Rake wrapper
  Plug 'tpope/vim-cucumber', { 'for': 'ruby' }                                    " [RUBY] Cucumber helpers (ruby acceptance testing)
  Plug 'derekwyatt/vim-scala', { 'for': 'scala' }                                 " [SCALA] Scala lang
  Plug 'StanAngeloff/php.vim', { 'for': 'php' }                                   " [PHP] PHP lang
  Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }                             " [PHP] PHP completion
  Plug 'klen/python-mode', { 'for': 'python' }                                    " [PYTHON] PyLint, Rope, Pydoc, breakpoints from box.
  Plug 'fs111/pydoc.vim', { 'for': 'python' }                                     " [PYTHON] integrates Python documentation system into Vim
  Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}                          " [PYTHON] Better indent
  Plug 'sentientmachine/Pretty-Vim-Python', {'for': 'python'}                     " [PYTHON] Better highlighting (like in textmate)
  Plug 'jmcantrell/vim-virtualenv', { 'for': 'python' }                           " [PYTHON] modify python's sys.path/$PATH when using :python
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }                                " [PYTHON] awesome python autocompletion
  Plug 'vim-scripts/applescript.vim', { 'for': 'applescript'}                     " [APPLESCRIPT] applescript syntax
  Plug 'msanders/cocoa.vim', { 'for': 'objc' }                                    " [OBJC] Cocoa/Objective-C
  Plug 'fatih/vim-go', { 'for': 'go' }                                            " [GO] Go lang
 "Plug 'eagletmt/ghcmod-vim'                                                      "|[HASKELL] Happy Haskell programming on Vim, powered by ghc-mod
 "Plug 'eagletmt/neco-ghc'                                                        "|[HASKELL] neocomplcache: completion plugin for Haskell, using ghc-mod
 "Plug 'dag/vim2hs'                                                               "|[HASKELL] collection of vimscripts for Haskell development
 "Plug 'Twinside/vim-hoogle'                                                      "|[HASKELL] query hoogle, the haskell search engine
 "Plug 'wting/rust.vim'                                                           "|[RUST] Rust lang
 "Plug 'phildawes/racer', { 'do': 'cargo build --release' }                       "|[RUST] Code completion for rust
 "Plug 'tpope/vim-fireplace', { 'for': 'clojure' }                                "|[CLOJURE] Clojure REPL support
 "Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }                       "|[CLOJURE] Structured Editing of Lisp S-expressions
 "Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }                       "|[CLOJURE] Colorize parenthesis
 "Plug 'kballard/vim-swift', { 'for': 'swift' }                                   "|[SWIFT] Swift lang (Apple's new language)
 "Plug 'sgeb/vim-matlab', { 'for': 'matlab' }                                     "|[MATHLAB] MathLab lang

  " --- (other syntaxes)
  Plug 'chrisbra/csv.vim'                                                         " [CSV] CSV syntax
  Plug 'stephpy/vim-yaml'                                                         " [YAML] Yaml syntax (fast/simple)
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }                           " [MARKDOWN] Markdown syntax
  Plug 'mustache/vim-mustache-handlebars'                                         " [MUSTACHE] mustache/handlebars syntax
  Plug 'jneen/ragel.vim', { 'for': 'ragel' }                                      " Ragel (rl; cross-language finite state machine to parse regular languages)
  Plug 'vim-scripts/abnf'                                                         " ABNF
  Plug 'dag/vim-fish'                                                             " FISH shell syntax
  Plug 'ekalinin/Dockerfile.vim'                                                  " Dockerfile syntax
  Plug 'vim-scripts/cmake.vim-syntax'                                             " CMake (build tool) syntax
 "Plug 'vim-scripts/scons.vim'                                                    "|SCons (build tool) syntax
 "Plug 'rodjek/vim-puppet'                                                        "|Puppet syntax
 "Plug 'tfnico/vim-gradle'                                                        "|Gradle syntax (for groovy files)

  " --- (textobj)
  Plug 'vim-scripts/argtextobj.vim'                                               " function arguments helpers: delete (daa) or change (cia)
  Plug 'kana/vim-textobj-user'                                                    " create new textobj easily
  Plug 'jceb/vim-textobj-uri'                                                     " uri/url helpers: select (viu)
  Plug 'deris/vim-textobj-email'                                                  " emails helpers: select (vim) or delete (dam)
  Plug 'glts/vim-textobj-comment'                                                 " comments helpers: select (vac) or delete (daC) or change (cic)
  Plug 'machakann/vim-textobj-equation'                                           " equations/comparaisons helpers: whole (viee), or just left (viel) or right (vier)
  Plug 'kana/vim-textobj-lastpat'                                                 " last searched pattern helpers (select stuff between using va/ or va? for example)
  Plug 'deris/vim-textobj-ipmac'                                                  " ipv4/ipv6/mac addresses helper: select (viA)
  Plug 'haya14busa/vim-textobj-number'                                            " number helpers: select (vin / van)
  Plug 'saihoooooooo/vim-textobj-space'                                           " space helpers: select (viS) or delete (daS) or change (ciS)
  Plug 'rhysd/vim-textobj-clang', { 'for': ['c','cpp'] }                          " [C/C++] helpers: most inner def (vi;m), class block (vi;c), function block (vi;f), expression (vi;e), statement (vi;s), parameter/template (vi;p), namespace (vi;n), element under cursor (vi;u), anything (vi;a).
  Plug 'anyakichi/vim-textobj-ifdef', { 'for': ['c','cpp'] }                      " [C/C++] ifdef helpers: select (vi# / va# / vi3 / va3)
  Plug 'tokorom/vim-textobj-objc', { 'for': ['objc'] }                            " [OBJECTIVE_C] @ literals (vi@ / va@) and ^ blocks (vi^ and va^)
  Plug 'kana/vim-textobj-function', { 'for': ['c','java','vim'] }                 " [C/JAVA/VIM] function helpers: select (vaf) or delete (daf) or change (cif)
  Plug 'vimtaku/vim-textobj-keyvalue',{'for': ['javascript','coffee','python','perl','vim'] } " key/value helpers: select (vik / vak)
  Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['html', 'xml']}                " [HTML] tags helpers: select (vix) or delete (dax) or change (cix)
  Plug 'inotom/vim-textobj-cssprop', {'for': ['html', 'css', 'sass']}             " [CSS] css helpers to select value (vic) or 'key: value;' (vac)
  Plug 'inotom/vim-textobj-csscolor', {'for': ['html', 'css', 'sass']}            " [CSS] css helpers to select hex color (vil) or rgb/rgba/hsl (vall)
  Plug 'nelstrom/vim-textobj-rubyblock', {'for': 'ruby'}                          " [RUBY] helper for selecting ruby code blocks
  Plug 'tek/vim-textobj-ruby', {'for': 'ruby'}                                    " [RUBY] helper for blocks (vir/var), functions (vif/vaf), class (vic/vac), name (van)
  Plug 'whatyouhide/vim-textobj-erb', {'for': ['ruby','erb']}                     " [RUBY] helper for selecting erb <% %> blocks
  Plug 'akiyan/vim-textobj-php', { 'for': 'php' }                                 " [PHP] php tags helper: select (viP) or delete (daP) or change (ciP)
  Plug 'bps/vim-textobj-python', { 'for': 'python' }                              " [PYTHON] python helpers for functions (vaf/vif) and class (vac/vic)
 "Plug 'vimtaku/vim-textobj-doublecolon'                                          "|helpers for 'Class::method'

  " --- (versioning)
  Plug 'tpope/vim-git'                                                            " git syntax (gitconfig, gitmodule, gitignore, commit)
  Plug 'tpope/vim-fugitive'                                                       " Git wrapper ('so awesome, it should be illegal')
  Plug 'gregsexton/gitv', { 'on': 'Gitv' }                                        " Gitk clone for vim (git ui :D)
  Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }   " Github events dashboard
  Plug 'airblade/vim-gitgutter'                                                   " show in the side which line are added/modified/deleted
 "Plug 'mhinz/vim-signify'                                                        "|gitgutter alternative for git/hg/darcs/bazaar/svn/cvs/rcs/fossil/accurev/perforce
 "Plug 'vim-scripts/ShowMarks'                                                    "|show in the side the bookmarks (registers)
 "Plug 'ludovicchabant/vim-lawrencium'                                            "|Mercurial wrapper, like fugitive but for hg

  " --- (notes)
  Plug 'neilagabriel/vim-geeknote', { 'on': 'Geeknote' }                          " Evernote access through geeknote app
  Plug 'xolox/vim-notes', { 'for': 'notes' }                                      " Notes syntax

  " --- (dependancies)
 "Plug 'xolox/vim-misc'                                                           "|various utils (dep for: notes, session, shell, ...)
 "Plug 'megaannum/self'                                                           "|allow vim script dev to create object-base script
 "Plug 'megaannum/forms'                                                          "|allow vim script dev to create text user interface (ncurse style)

  " --- (GVIM)
  Plug 'bling/vim-airline'                                                        " Powerline (faster, and with a lot of extensions)
 "Plug 'itchyny/lightline.vim'                                                    "|Powerline (minimal)
 "Plug 'bilalq/lite-dfm', { 'on': 'LiteDFMToggle' }                               "|Distraction Free Mode (like sublimetext)
  if has('gui_running')
   "Plug 'eparreno/vim-l9'                                                        " (L9 - dependancy for autocomplpop)
   "Plug 'othree/vim-autocomplpop'                                                " Automatically display the completion menu while typing
    Plug 'KabbAmine/vCoolor.vim'                                                  " Color picker
  else
   "Plug 'godlygeek/csapprox'                                                     "|Make gvim-only colorschemes work transparently in terminal vim
   "Plug 'vim-scripts/vim-auto-save'                                              "|Automatically save (each seconds)
  endif

call plug#end()


"________________________________________________________________________________________________________________________________________________________________________
"
" [General settings]
" ==================

set nocompatible                                                                  " Enable all the features of VIM (incompatible with the old VI)
set modeline                                                                      " Allow per-file settings via modeline
filetype plugin on                                                                " Enable the filetype detection
filetype plugin indent on                                                         " Enable the filetype detection
syntax on                                                                         " Enable syntax highlighting (for dev)
set mouse=nvih                                                                    " Enable mouse (except in Command mode, to be able to copy/paste with X)
"set keymodel=startsel selectmode=mouse,key                                       "|Use select mode rather than visual mode (like any other editor)
set wildmenu                                                                      " Enable completion menu
set encoding=utf-8 fileencoding=utf-8 termencoding=utf-8                          " Set the encoding to use (UTF8)
set hidden                                                                        " Enable to open new files without saving the current buffer (hide it, dont close it)
set autoindent smartindent                                                        " Enable automatic code intendation (dev)
set autoread                                                                      " Auto-reload the file when it's modified by an external app
set wrap                                                                          " Automatically wrap text to the next line
"set listchars=tab:▸\ ,eol:·                                                      "|Display invisible EOL trailing characters (dev) -- alternative: 'set list'
"set list                                                                         "|If enabled, display those invisible characters (see above)
"set ignorecase                                                                   "|Ignore case when searching (otherwise use \c while searching)
"set autochdir                                                                    "|Go to the folder of the opened file
"set noerrorbells                                                                 "|Disable noise (should be ok on terminals that support virtual bell)
"set virtualedit=all                                                              "|Allow the cursor to be anywhere in the screen (cool to insert text at any place)
set incsearch                                                                     " Start searching while typing, in realtime (before pressing ENTER, not after)
set hlsearch                                                                      " Highlight all elements when searching (PS: search keywords/regex available in reg "/)
set nofoldenable                                                                  " I fucking hate code folding.
set history=200                                                                   " Store 200 lines max in the history
set scrolloff=3                                                                   " Have a 3-lines margin (up and down) when scrolling
set shortmess=a                                                                   " Avoid the 'hit ENTER' prompts (e.g. when exec an external command)
set backspace=2                                                                   " Make backspace key work like other apps (delete over line breaks, ...)
"let mapleader = ","                                                              "|Set the leader to ',' (comma) for azerty/qwerty instead of the default \ (backslash)
set viminfo='20,<1000,s10,h                                                       " Set maxline in registers (copy/paste...) to 1000 instead of 50
set shell=zsh                                                                     " Use Zsh as the system shell for vim
set iskeyword+=/,.,:                                                              " Add '/', '.', and ':' to a the vim definition of a word (nice when doubleclick)

set shiftwidth=2 tabstop=2                                                        " [TAB] Set the Tab size
set expandtab smarttab                                                            " [TAB] Use spaces instead of real \t (better for align) -- use :retab for manual
set wildmode=list:longest,full                                                    " [TAB] Show a list when pressing tab
set nonumber                                                                      " [001] Disable line number on the left (dev)  -- add 'ru' for relative lines numbers
set numberwidth=3                                                                 " [001] Set the left number bar size to 3 digits (by default, but have more if needed)
set backup                                                                        " [BACKUP] Enable file backups
set backupdir=~/.vim/backups                                                      " [BACKUP] Set a unique backup directory (to avoid having files in project dir)
set directory=~/.vim/tmp                                                          " [TMP] Set a unique tmp directory (to avoid having files in project dir)
set showmode                                                                      " [STATUS2] Show the current mode in the statusbar (e.g. INSERT)
set showcmd                                                                       " [STATUS2] Show partial command (Note: if the terminal is slow, try putting it off!)
set ruler                                                                         " [STATUS1/CURSOR] Display the cursor position (line,column)
"set cursorline                                                                   "|[CURSOR] Highlight the cursor line (too slow :/)
"set cursorcolumn                                                                 "|[CURSOR] Highlight the cursor column (too slow :/)
set go+=a                                                                         " [CLIPBOARD] Visual selection automatically copied to the clipboard
set clipboard=unnamed,unnamedplus                                                 " [CLIPBOARD] Make yanking/deleting automatically copy to the system clipboard
set nopaste                                                                       " [CLIPBOARD] Disable the paste mode by default

" --- (plugins)
let g:NERDTreeMouseMode = 2                                                       " [NerdTree] clicking with the mouse open instantly (no double-click needed)
let g:NERDTreeWinSize = 31                                                        " [NerdTree] set the file explorer panel size (width)
let g:EasyMotion_smartcase = 1                                                    " [EasyMotion] Turn on case insensitive feature
let g:EasyMotion_do_mapping = 0                                                   " [EasyMotion] Disable the default mappings
let g:did_UltiSnips_vim_after = 1                                                 " [Ultisnips] Disable the default ultisnips mapping keys (to override shortcuts)
let g:UltiSnipsExpandTrigger = "<tab>"                                            " [UltiSnips] better keybinding for snippets (play nice with completion using supertab)
let g:UltiSnipsJumpForwardTrigger = "<tab>"                                       " [UltiSnips] better keybinding for snippets (play nice with completion using supertab)
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"                                    " [UltiSnips] better keybinding for snippets (play nice with completion using supertab)
let g:UltiSnipsEditSplit="vertical"                                               " [UltiSnips] split the window when using :UltiSnipsEdit
let g:ycm_confirm_extra_conf = 0                                                  " [YouCompleteMe] allow the default config in ~/.ycm_extra_config.py
let g:ycm_use_ultisnips_completer = 1                                             " [YouCompleteMe] make YCM query the UltiSnips plugin for possible snippet completions
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']                        " [YouCompleteMe] make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']                        " [YouCompleteMe] make YCM compatible with UltiSnips (using supertab)
let g:SuperTabDefaultCompletionType = '<C-n>'                                     " [SuperTab] make YCM compatible with UltiSnips (using supertab)
let g:unite_source_history_yank_enable = 1                                        " [Unite] Enable clipboard history search
let g:unite_source_history_yank_save_clipboard = 1                                " [Unite] Sync with the system clipboard
let g:unite_source_history_yank_limit = 10000                                     " [Unite] Limit the clipboard to 10k
let g:unite_source_history_yank_file = $HOME.'/.vim/clipboard.txt'                " [Unite] Use a file to store the clipboard data (similar to yankring)
let g:unite_source_file_mru_limit = 1000                                          " [Unite] Most Recently Used limit
let g:unite_enable_start_insert = 1                                               " [Unite] Start unite in insert mode
let g:unite_update_time = 200                                                     " [Unite] Shorten the default update time to 200ms
if executable('ag')                                                               " (Ag)
  let g:unite_source_grep_command = 'ag'                                          " [Unite] Set the grep command (Ag: the silver searcher), faster ack/grep alternative
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'           " [Unite] Set the grep options
  let g:unite_source_grep_recursive_opt = ''                                      " [Unite] Set the grep options (recursive)
elseif executable('ack-grep')                                                     " (Ack)
  let g:unite_source_grep_command = 'ack-grep'                                    " [Unite] Set the grep command (perl's Ack), faster grep
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -H'          " [Unite] Set the grep options
  let g:unite_source_grep_recursive_opt = ''                                      " [Unite] Set the grep options (recursive)
endif                                                                             " (-)
let g:airline_theme='murmur'                                                      " [Airline] Set the theme (other interesting themes... :AirlineTheme *badwolf*/powerlineish/kalisi/laederon/wombat (green), *murmur*/jellybeans/*simple*/zenburn (blue), monochrome/raven/serene/lucius/*ubaryd* (dark), sol (light))
let g:airline#extensions#syntastic#enabled = 1                                    " [Airline] Enable syntax checking plugin
let g:airline#extensions#tabline#enabled = 1                                      " [Airline] Enable light tab switching for airline (not only buffers!)
let g:airline#extensions#branch#enabled = 1                                       " [Airline] Enable branch detection
let g:airline#extensions#nrrwrgn#enabled = 0                                      " [Airline] Disable narrowregion integration (to avoid errors due to :NR lazy loading)
let g:airline#extensions#whitespace#checks = ['indent']                           " [Airline] Disable the trailing check detection (since we use highlight colors)
let g:airline_powerline_fonts = 1                                                 " [Airline] Use powerline font (for a better style)
"let g:airline_section_a = DEFAULT                                                                               "|[Airline] 1st section L: mode
let g:airline_section_b = '(%p%%) %l:%v'                                                                         " [Airline] 2nd section L: percentage + line + column
let g:airline_section_c = '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#' " [Airline] 3rd section L: filename
"let g:airline_section_x = DEFAULT                                                                               "|[Airline] -3 section R: filetype
let g:airline_section_y = '%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}'                         " [Airline] -2 section R: git modifications (if gutter)
let g:airline_section_z = '%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'                         " [Airline] -1 section R: branch name
let g:gitgutter_max_signs = 5000                                                  " [GitGutter] Maximum number of line that we want to analyse
let g:investigate_command_for_python = '/usr/bin/zeal --query ^s'                 " [Investigate] Set 'zeal' path (Dash alternative for linux) for browsing documentation
let g:textobj_clang_more_mappings = 1                                             " [vim-textobj-clang] enable extended objects (class, function, ...)
let g:tcommentMaps = 0                                                            " [TComment] disable the default keyboard mappings

" --- (style)
colors desert                                                                     " Set colorscheme (default one, if no plugin installed)
colors jellybeans                                                                 " Set colorscheme
highlight Cursor guifg=white guibg=steelblue|                                     " [CURSOR] Normal cursor color (blue)
highlight vCursor guifg=white guibg=orange|                                       " [CURSOR] Selection cursor color (orange)
highlight iCursor guifg=white guibg=green|                                        " [CURSOR] Insert cursor color (green)
highlight rCursor guifg=black guibg=green|                                        " [CURSOR] Replace cursor color (green)
"highlight Spellbad term=underline gui=undercurl guisp=Orange|                    "|[SPELLCHECK] Mistake color
highlight ExtraWhitespace ctermbg=DarkRed guibg=DarkRed|                          " [TRAILING WHITESPACES] color: red! (to notice useless space/tabs easily)
match ExtraWhitespace /\s\+$/                                                     " [TRAILING WHITESPACES] regexp
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/                               " [TRAILING WHITESPACES] regexp
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/                        " [TRAILING WHITESPACES] regexp
autocmd InsertLeave * match ExtraWhitespace /\s\+$/                               " [TRAILING WHITESPACES] regexp
autocmd BufWinLeave * call clearmatches()                                         " [TRAILING WHITESPACES] -
highlight Pmenu    ctermfg=230 ctermbg=238 guifg=#ffffd7 guibg=#444444|           " [POPUP MENU] normal color (grey; from wombat256)
highlight PmenuSel ctermfg=232 ctermbg=192 guifg=#080808 guibg=#cae982|           " [POPUP MENU] selection color (yellowish; from wombat256)
hi SignColumn term=standout ctermfg=242 ctermbg=236 guifg=#777777 guibg=#333333A| " [GitGutter] sign column (greish)
hi LineNr     term=standout ctermfg=242 ctermbg=236 guifg=#777777 guibg=#333333A| " number column (greish; same as gitgutter)


" --- (statusline)
if has('statusline')
  set laststatus=2                                                                " [STATUS] Always show the status bar
  set statusline=%<%f\                                                            " [STATUS-LEFT] filename
  set statusline+=%w%h%m%r                                                        " [STATUS-LEFT] options
 "set statusline+=%{fugitive#statusline()}                                        "|[STATUS-LEFT] git
 "set statusline+=\ [%{&ff}/%Y]                                                   "|[STATUS-LEFT] filetype
  set statusline+=\ [%{getcwd()}]                                                 " [STATUS-LEFT] current directory
  set statusline+=\ [HEX=0x\%02.2B]                                               " [STATUS-LEFT] ASCII / Hexadecimal value of char
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%                                         " [STATUS-RIGHT] line/column/percentage
endif

" --- (gui)
if has('gui_running')
  set guioptions-=T                                                               " turn off GUI toolbar (icons)
  set guioptions-=r                                                               " turn off GUI right scrollbar
  set guioptions-=L                                                               " turn off GUI left scrollbar
  set winaltkeys=no                                                               " turn off stupid fucking alt shortcuts (to access menu)
  set mousemodel=popup                                                            " Rightclick trigger a context menu
  set guicursor=n-o-sm:block-blinkoff0                                            " [CURSOR] normal: block cursor (without blinking)
  set guicursor+=v-ve:block-vCursor-blinkoff0                                     " [CURSOR] visual: block cursor (without blinking)
  set guicursor+=r-cr:block-rCursor-blinkoff0                                     " [CURSOR] replace: block cursor (without blinking)
  set guicursor+=i-c-ci:ver25-iCursor-blinkoff0                                   " [CURSOR] insert: vertical bar cursor (without blinking)
  if has("gui_gtk2")
    set guifont=Inconsolata\ 7                                                    " Linux   -> use font Inconsolata (small)
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h12                                                " OS X    -> use font Menlo
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI                                                " Windows -> use font Consolas
  endif
else
  set t_Co=256                                                                    " Force terminal vim to use 256 colors (sometimes useful when using screen/tmux)
endif


"________________________________________________________________________________________________________________________________________________________________________
"
" [Commands]
"============

" --- (cmd)
command! Wroot :w !sudo tee %|                                                    "               Wroot : save the current file as root (using sudo)
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>|             "              Bclose : Alias for bbye's Bdelete (when used to the old Bclose plugin)

" --- (automatic)
autocmd BufWritePost vimrc source %                                               " Reload automatically the '.vimrc' config when saved.
autocmd StdinReadPre * let s:std_in=1                                             " Define a variable to indicate there's text coming from stdin (e.g. via a unix pipe).
autocmd VimEnter * if !argc()&&!exists("s:std_in")|NERDTree|else|start|endif      " If no file/arg is specified, open nerdtree to select a file. Otherwise, start VIM in INSERT mode


"________________________________________________________________________________________________________________________________________________________________________
"
" [Shortcuts]
"=============

" --- F1 to F12 keys
noremap   <F1>        <Esc>:help<Space>|                                          "                  F1 : Help
noremap   <F2>        <Esc>:nohl<CR>|                                             "                  F2 : disable search highlighting
noremap   <F3>        <Esc>:Autoformat<CR><CR>|                                   "                  F3 : format/indent code properly
set pastetoggle=<F4>|                                                             "                  F4 : switch on/off the paste mode (enable/disable indentation)
noremap   <F5>        <Esc>:make<CR>|                                             "                  F5 : build
noremap   <F6>        <Esc>:exec ":e ~/.vim/after/ftplugin/".&ft.".vim"<cr>|      "                  F6 : edit the vim config for the current language
noremap   <F7>        <Esc>:e $MYVIMRC<CR>|                                       "                  F7 : edit ~/.vimrc
noremap   <F8>        <Esc>:UltiSnipsEdit<CR>|                                    "                  F8 : new code snippet
noremap   <F9>        <Esc>:TagbarToggle<cr>|                                     "                  F9 : display/hide tags explorer
noremap   <F10>       <Esc>:GitGutterToggle<CR>|                                  "                 F10 : display/hide line git modifications (left side)
noremap   <F11>       <Esc>:set number!<CR>|                                      "                 F11 : display/hide line numbers (left side)
noremap   <F12>       <Esc>:NERDTreeToggle<CR>|                                   "                 F12 : display/hide file explorer

" --- ctrl keys
noremap   <C-x>       dd|                                                         "            CTRL + X : cut (the line)
vnoremap  <C-x>       d|                                                          "            CTRL + X : cut (the selection)
noremap   <C-c>       yy|                                                         "            CTRL + C : copy (the line)
vnoremap  <C-c>       y|                                                          "            CTRL + C : copy (the selection)
nnoremap  <C-S-v>     <Esc>:set nopaste<CR>"*p|                                   "    SHIFT + CTRL + V : paste (with indentation)
nnoremap  <C-v>       <Esc>:set paste<CR>"*p:set nopaste<CR>|                     "            CTRL + V : paste (without indentation) -- "* or "+ ?
vnoremap  <C-v>       "*p|                                                        "            CTRL + V : paste into the selection
inoremap  <C-v>       <C-r>*|                                                     "            CTRL + V : paste
cnoremap  <C-v>       <C-r>*|                                                     "            CTRL + V : paste
noremap   <C-n>       <Esc>:ene<CR>|                                              "            CTRL + N : new file (unnamed)
noremap   <C-s>       <Esc>:w!<CR>|                                               "            CTRL + S : save
noremap   <C-S-z>     <Esc>:redo<CR>|                                             "    SHIFT + CTRL + Z : cancel last undo (redo)
noremap   <C-z>       <Esc>:undo<CR>|                                             "            CTRL + Z : undo
noremap   <C-d>       <Esc>yypi|                                                  "            CTRL + D : duplicate the line
vnoremap  <C-d>       yP|                                                         "            CTRL + D : duplicate the selection
noremap   <C-j>       J|                                                          "            CTRL + J : join the current line(s) with the next one
inoremap  <C-j>       <Esc>J|                                                     "            CTRL + J : join the current line with the next one
noremap   <C-b>       <Esc>:make<CR>|                                             "            CTRL + B : build
noremap   <C-t>       <Esc>:tabnew<CR>|                                           "            CTRL + T : create a new tab/layout
noremap   <C-S-Left>  <Esc>:tabprev<CR>|                                          " SHIFT + CTRL + LEFT : go to the previous tab/layout
noremap   <C-S-Right> <Esc>:tabnext<CR>|                                          "SHIFT + CTRL + RIGHT : go to the next tab/layout
noremap   <C-S-w>     <Esc>:tabclose<CR>|                                         "    SHIFT + CTRL + W : close the current tab/layout
noremap   <C-w>       <Esc>:Bdelete<CR>|                                          "            CTRL + W : close the current buffer
noremap   <C-l>       <Esc>:redraw<CR>|                                           "            CTRL + L : redraw screen (in case of a display bug)
vnoremap  <C-l>       o0O$|                                                       "            CTRL + L : select the full line(s)
noremap   <C-f>       <Esc>:Unite grep:.<CR>|                                     "            CTRL + F : [Unite] search in file content (classic grep, like ack/ag)
noremap   <C-g>       <Esc>:Unite file_rec/async<CR>|                             "            CTRL + G : [Unite] recursive file list (async)
noremap   <C-Right>   <C-W>l|                                                     "        CTRL + RIGHT : move to the split on the right
noremap   <C-Left>    <C-W>h|                                                     "         CTRL + LEFT : move to the split on the left
noremap   <C-Down>    <C-W>j|                                                     "         CTRL + DOWN : move to the split below
noremap   <C-Up>      <C-W>k|                                                     "           CTRL + UP : move to the split above
nnoremap  <C-S-CR>    O|                                                          "       SHIFT + ENTER : insert line before
nnoremap  <C-CR>      o|                                                          "               ENTER : insert line after
nnoremap  <C-_>       :TComment<cr>|                                              "            CTRL + / : comment
vnoremap  <C-_>       :TCommentMaybeInline<cr>|                                   "            CTRL + / : comment
inoremap  <C-_>       <C-o>:TComment<cr>|                                         "            CTRL + / : comment

" --- alt keys
noremap   √           <C-v>|                                                      "             ALT + V : start VISUAL BLOCK mode (original ctrl-v) -- OS X
noremap   <Esc>v      <C-v>|                                                      "             ALT + V : start VISUAL BLOCK mode (original ctrl-v) -- Linux
noremap   <A-Left>    <Esc>:bprevious<CR>|                                        "          ALT + LEFT : goto previous opened buffer/file
noremap   <A-Right>   <Esc>:bnext<CR>|                                            "         ALT + RIGHT : goto next opened buffer/file
noremap   <A-Down>    <Esc>:tabprevious<CR>|                                      "          ALT + DOWN : goto the previous tab/layout
noremap   <A-Up>      <Esc>:tabnext<CR>|                                          "            ALT + UP : goto the next tab/layout

" --- super keys
map       <D-x>       <C-x>|map <T-x> <C-x>|                                      "        [SUPER + X]  ->  [CTRL + X]
map       <D-c>       <C-c>|map <T-c> <C-c>|                                      "        [SUPER + C]  ->  [CTRL + C]
map       <D-v>       <C-v>|map <T-v> <C-v>|                                      "        [SUPER + V]  ->  [CTRL + V]
map       <D-n>       <C-n>|map <T-n> <C-n>|                                      "        [SUPER + N]  ->  [CTRL + N]
map       <D-s>       <C-s>|map <T-s> <C-s>|                                      "        [SUPER + S]  ->  [CTRL + S]
map       <D-z>       <C-z>|map <T-z> <C-z>|                                      "        [SUPER + Z]  ->  [CTRL + Z]
map       <D-d>       <C-d>|map <T-d> <C-d>|                                      "        [SUPER + D]  ->  [CTRL + D]
map       <D-b>       <C-b>|map <T-b> <C-b>|                                      "        [SUPER + B]  ->  [CTRL + B]
map       <D-t>       <C-t>|map <T-t> <C-t>|                                      "        [SUPER + T]  ->  [CTRL + T]
map       <D-w>       <C-w>|map <T-w> <C-w>|                                      "        [SUPER + W]  ->  [CTRL + W]
map       <D-f>       <C-f>|map <T-f> <C-f>|                                      "        [SUPER + F]  ->  [CTRL + F]
map       <D-g>       <C-g>|map <T-g> <C-g>|                                      "        [SUPER + G]  ->  [CTRL + G]

" --- leader
nnoremap  <Leader>gi  :!git init<CR>|                                             "                 \gi : init a new git directory
nnoremap  <Leader>gc  :Gcommit<CR>|                                               "                 \gc : commit the changes
nnoremap  <Leader>gC  :Gcommit -a<CR>|                                            "                 \gC : add all files & commit the changes
nnoremap  <Leader>gt  :Gwrite<CR>:Gcommit<CR>|                                    "                 \gt : add this file & commit
nnoremap  <Leader>ga  :Gwrite<CR>|                                                "                 \ga : add this file
nnoremap  <Leader>gA  :Git add .<CR>|                                             "                 \gA : add all files
nnoremap  <Leader>gs  :Gstatus<CR>|                                               "                 \gs : show git status (- to add/reset, or p to add with --patch)
nnoremap  <Leader>gl  :Glog<CR>|                                                  "                 \gl : show git logs
nnoremap  <Leader>gd  :Gdiff |                                                    "                 \gd : show git diff (of the specified file)
nnoremap  <Leader>gp  :Git push |                                                 "                 \gp : push the commits to a remote repository
nnoremap  <Leader>gP  :Git pull |                                                 "                 \gP : pull the updates from a remote repository
nnoremap  <Leader>gco :Git checkout |                                             "                \gco : checkout
nnoremap  <Leader>gb  :Gblame<CR>|                                                "                 \gb : show authors/dev of each lines
nnoremap  <Leader>gh  :Gbrowse<CR>|                                               "                 \gh : open the current file on github
nnoremap  <Leader>gv  :Gitv<CR>|                                                  "                 \gv : user interface for git (like gitk, but inside vim!)
nnoremap  <Leader>d   :diffget<CR>                                                "                  \d : diff: get the diff  (from the other pane)
nnoremap  <Leader>dp  :diffput<CR>                                                "                 \dp : diff: put the diff  (to the other pane)
nnoremap  <Leader>du  :diffupdate<CR>                                             "                 \du : update the diff (in case of a display bug)
nnoremap  <Leader>k   :call InterestingWords('n')<CR>                             "                  \k : highlight a new word (like search, but multi-highlight!)
nnoremap  <Leader>K   :call UncolorAllWords()<CR>                                 "                  \K : clear all matches
nmap     <Leader><Up> <Plug>(easymotion-k)|                                       "              \ + UP : move up (using letters marks)
nmap   <Leader><Down> <Plug>(easymotion-j)|                                       "            \ + DOWN : move down (using letters marks)
nmap   <Leader><Left> <Plug>(easymotion-linebackward)|                            "            \ + LEFT : move left (using letters marks)
nmap  <Leader><Right> <Plug>(easymotion-lineforward)|                             "           \ + RIGHT : move right (using letters marks)
nmap      <Leader>l   <Plug>(easymotion-lineforward)|                             "                  \l : move right (using letters marks)
nmap      <Leader>j   <Plug>(easymotion-j)|                                       "                  \j : move down (using letters marks)
nmap      <Leader>k   <Plug>(easymotion-k)|                                       "                  \k : move up (using letters marks)
nmap      <Leader>h   <Plug>(easymotion-linebackward)|                            "                  \h : move left (using letters marks)

" --- other
nmap      s           <Plug>(easymotion-s)|                                       "                   s : easy bidirectional motion (pick a letter; try also -s2)
noremap   .           <Esc>:A<CR>|                                                "                   . : switch from source to header (.c <-> .h)
noremap   `           <Esc>:Unite -quick-match buffer<CR>|                        "                   ` : select buffer (quick & lazy way)
noremap   ~           <Esc>:Unite history/yank<CR>|                               "                   ~ : select clipboard
nmap      ga          <Plug>(EasyAlign)|                                          "                  ga : align
vmap      <CR>        <Plug>(EasyAlign)|                                          "               ENTER : align selection
nnoremap  <BS>        <Esc>cc|                                                    "                 DEL : delete line (+ start insert mode)
vnoremap  <BS>        c|                                                          "                 DEL : delete selection (+ start insert mode)
inoremap  <C-S-Tab>   <C-d>|                                                      "  CTRL + SHIFT + TAB : unindent the line
nnoremap  <C-S-Tab>   a<C-d><Esc>|                                                "  CTRL + SHIFT + TAB : unindent the line
inoremap  <C-S-]>     <C-d>|                                                      "    CTRL + SHIFT + ] : unindent the line
nnoremap  <C-S-]>     a<C-d><Esc>|                                                "    CTRL + SHIFT + ] : unindent the line
nnoremap  <C-Tab>     a<C-t><Esc>|                                                "          CTRL + TAB : indent the line
inoremap  <C-Tab>     <C-t>|                                                      "          CTRL + TAB : indent the line (can't bind ctrl+[ due to terminal limitations)
nnoremap  <C-]>       a<C-t><Esc>|                                                "            CTRL + ] : indent the line
inoremap  <C-]>       <C-t>|                                                      "            CTRL + ] : indent the line
vnoremap  <S-Tab>     <|                                                          "         SHIFT + TAB : un-indent the selection
vnoremap  <Tab>       >|                                                          "                 TAB : indent the selection
nnoremap  <S-Esc>     <C-i>|                                                      "         SHIFT + ESC : go to the next cursor location (in the jumplist)
nnoremap  <Esc>       <C-o>|                                                      "                 ESC : go to the previous cursor location
noremap   +           <C-a>|                                                      "                   + : increment the number
noremap   -           <C-x>|                                                      "                   + : decrement the number
"map      \           :|                                                          "                   \ : lazy ':' on qwerty keyboards (\ instead of using shift+;)

" --- command helpers
cnoremap  >fn         <C-r>=expand('%:p')<CR>|                                    "                 >fn : insert the filename (in cmd)
cnoremap  >dir        <C-r>=expand('%:p:h').'/'<CR>|                              "                >dir : insert the directory (in cmd)


