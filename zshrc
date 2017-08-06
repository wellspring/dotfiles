# ********************************************************************* #
#                            * .zshrc file *                            #
#                              ~~~~~~~~~~~                              #
#   Author         : William Hubault <contact A T williamhubault.com>   #
#   Description    : configuration for zsh (shell)                      #
#   Last modified  : 11/04/2017                                         #
#   Version        : 2.0.0                                              #
# ********************************************************************* #

####
# ZSH Config
########
ZDOTDIR="$HOME"
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'     # (exclude "/")
SPROMPT="$PS0%K{7}%F{0} %BDid you mean \\\`%F{28}%r%F{0}\\\`?%b %F{7}%k %F{235}[Yes, No, Abort, Edit]%f " #Unknown \\\`%F{1}%R%F{0}\\\`
REPORTMEMORY=100    # If the command uses more than 100MB, also do as if it was ran with `time`.
REPORTTIME=3        # If the command takes more than 3 seconds (of non-wait time), do as if executed with time.
TIMEFMT="$(tput setaf 240)---
Time spent: %E   (%U in user mode, %S in kernel -- used %P CPU + up to %MMB memory)"
WATCHFMT="%(a.$(tput setaf 22)>>>.$(tput setaf 160)<<<)  %n $(tput op) has %a %(l.on TTY %l .)(connected from %(M.'%M'.this machine), at %w)."
WATCH=all
LOGCHECK=5
TMPPREFIX=/tmp/shellfile_
TMPSUFFIX=.tmp
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root line)
ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
#ZSH_HIGHLIGHT_STYLES[default]=none
#ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
#ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
#ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold
#ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
#ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
#ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
#ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
#ZSH_HIGHLIGHT_STYLES[commandseparator]=none
#ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
#ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
#ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
#ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
#ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
#ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
#ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
#ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
#ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
#ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
#ZSH_HIGHLIGHT_STYLES[assign]=none

# TODO: [ HAVE THE `autoload` / `setopt` here! as it contains always_export! ]

####
# Variables  TODO: [MOVE THAT SECTION AT THE END]
########
export SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
export PATH=/usr/local/bin:/usr/local/rvm/bin:$PATH
export CDPATH="~:/disk" #"~:/disk:/usr/src:/usr:/var"
#export FPATH="~/.zsh/functions"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export DIRSTACKSIZE=64

export EDITOR="/usr/bin/vim"
export PAGER="/usr/bin/less"
export BROWSER="/usr/bin/qutebrowser"
export TERMINAL="/usr/bin/urxvtc"
export SVN_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

export VMWARE_USE_SHIPPED_GTK="yes"
export RAILS_ENV=development
export LC_COLLATE="C"

export COLUMNS
export ROWS

####
# Load ZSH addins
########
zmodload -i zsh/complist
autoload -U compinit
compinit
autoload -U promptinit
promptinit
autoload -Uz vcs_info
autoload -U colors
autoload -U zargs
autoload -U zmv
autoload -U age
# Use # symbol for comments in the shell.
setopt INTERACTIVECOMMENTS
# Export all variables by default.
setopt ALL_EXPORT
# Add some globbing features.
setopt EXTENDEDGLOB
# Something like foo/$arr result as foo/b foo/a foo/r.
setopt RCEXPANDPARAM
# Show tab choices just after the first TAB.
unsetopt LIST_AMBIGUOUS
# Perform a path search even on command names with slashes in them. (dangerous)
unsetopt PATH_DIRS
# Remove useless jockers, instead of giving an error.
setopt NULLGLOB
# When a number is found, do sort numerically.
setopt NUMERIC_GLOB_SORT
# Do not show a question when "rm *".
#setopt RM_STAR_SILENT
# Do not treat \ in echo if -e is not specified. (like in bash)
setopt BSD_ECHO
# Resolve  symbolic links to their true values when changing directory.
setopt CHASE_LINKS
# If the command is invalid but a folder exist, go to this folder.
setopt AUTO_CD
# Do not assign lower priority to background processes.
unsetopt BG_NICE
# Do not use = to replace with full pathname.
setopt NOEQUALS
# Do not add duplicate commands to history.
setopt HIST_IGNORE_DUPS
# Try  to  correct  the  spelling of commands.
setopt CORRECT
# Create hash table to find faster commands and directories, and correct them. (removed: need to rehash all the time)
#setopt HASH_CMDS
#setopt HASH_DIRS
setopt NOHASHDIRS
setopt NOHASHCMDS
# Log old paths automatically with pushd when using cd.
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
# Display PID and exit value on suspend and report them immediatly or at exit.
setopt PRINT_EXIT_VALUE
setopt LONG_LIST_JOBS
setopt CHECKJOBS
setopt NOTIFY
# Some nice options for history
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
#setopt SHARE_HISTORY
setopt BANG_HIST
# Authorize prompt variable substitution (used by vcs)
setopt PROMPT_SUBST


####
# Completion
########
# Use cache for commands with big list of results.
#zstyle ':completion:*' use-cache on
#zstyle ':completion:*' cache-path ~/.zsh/cache
# Prevent CVS files/directories from being completed.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
# Fuzzy matching of completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
# Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'
# Command cd will never select the parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Complete process IDs (with menu)
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

#zstyle ':completion:*' menu select=0
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' use-compctl false

# Completion for "man" (by Gossamer)
compctl -f -x 'S[1][2][3][4][5][6][7][8][9]' -k '(1 2 3 4 5 6 7 8 9)' \
  - 'R[[1-9nlo]|[1-9](|[a-z]),^*]' -K 'match-man' \
  - 's[-M],c[-1,-M]' -g '*(-/)' \
  - 's[-P],c[-1,-P]' -c \
  - 's[-S],s[-1,-S]' -k '( )' \
  - 's[-]' -k '(a d f h k t M P)' \
  - 'p[1,-1]' -c + -K 'match-man' \
  -- man

# Other completitions
compctl -b bindkey
compctl -v export
compctl -o setopt
compctl -v unset
compctl -o unsetopt
compctl -v vared
compctl -c which

####
# Bindings
########
# VIM mode
#bindkey -v
# Emacs mode
bindkey -e
# My bindings
bindkey '^[[7~'   beginning-of-line                   # Home
bindkey '^[[1~'   beginning-of-line                   # Home
bindkey '^[[H'    beginning-of-line                   # Home
bindkey '^[OH'    beginning-of-line                   # Home
bindkey '^[OF'    end-of-line                         # End
bindkey '^[[F'    end-of-line                         # End
bindkey '^[[4~'   end-of-line                         # End
bindkey '^[[8~'   end-of-line                         # End

bindkey '^R'      history-incremental-search-backward # Ctrl+R
bindkey '^[[5~'   history-search-backward             # PgUp
bindkey '^[[6~'   history-search-forward              # PgDn

bindkey '^?'      backward-delete-char                # Backspace
bindkey '^H'      backward-delete-word                # Alt+Backspace
bindkey '^[[1;5D' backward-word                       # Ctrl+Left
bindkey '^[[1;5C' forward-word                        # Ctrl+Right
bindkey '^[[3;5~' delete-word                         # Ctrl+Del
bindkey '^[[3~'   delete-char                         # Del
bindkey '^[[2~'   overwrite-mode                      # Ins

bindkey '^U'      undo                                # Ctrl+U
bindkey '^O'      paste-xclip                         # Ctrl+O
bindkey '^B'      start-background                    # Ctrl+B
bindkey '^P'      push-line                           # Ctrl+P
bindkey '^L'      clear-screen-motd                   # Ctrl+L
bindkey '^N'      comment-line                        # Ctrl+N
bindkey '^Y'      start-silent                        # Ctrl+Y
bindkey '^J'      start-root                          # Ctrl+J
bindkey '^F'      repeat-second-last                  # Ctrl+F
bindkey '^K'      kill-line                           # Ctrl+K

bindkey '§'       vi-match-bracket                    # Shift+!
bindkey '¡'       vi-join                             # Alt+!
bindkey '¬'       what-cursor-position                # Alt+?
bindkey '¿'       what-cursor-position                # Alt+Shift+?
bindkey 'º'       vi-find-next-char                   # Alt+:
bindkey '»'       insert-last-word                    # Alt+.
bindkey '®'       insert-last-word                    # Alt+Shift+.

bindkey ' '       magic-space                         # Space

#bindkey -s '^T'   "uptime\n"                          # C-T
bindkey -s '^|l'  " | less\n"                         # C-| l
bindkey -s '^|g'  ' | grep ""OD'                    # C-| g
bindkey -s '^|s'  ' | sed -e "s///g"ODODODOD' # C-| s

####
# Global aliases
########
alias -g ~~=\`current-git-dir\`
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias -g ........='../../../../../../..'
alias -g .........='../../../../../../../..'
alias -g ..........='../../../../../../../../..'
alias -g ...........='../../../../../../../../../..'

####
# Suffix aliases
########
# Auto edit files
alias -s {c,cc,cpp,h,com,bat,css,xml,txt,lst,list,rc,conf,.htaccess,.htpasswd}=$EDITOR
# Auto open links
alias -s {com,org,net,fr,htm,html}=$BROWSER
# Auto open documents
alias -s {doc,docx,odt,sdw,xls,xlsx,xlc,sdc,ods,ppt,pptx,pps,sda,sdd,odp}='libreoffice'
# Auto open pdf
alias -s {pdf,PDF}='evince'
# Auto open images
alias -s {jpg,JPG,jpeg,JPEG,png,PNG,gif,GIF,tga,TGA,bmp,BMP,xpm,tiff,pcx}='display'
# Auto open movies
alias -s {mpg,mpeg,avi,divx,ogm,wmv,m4v,mp4,mov,mkv,flv}='mplayer -idx'
# Auto open audio
alias -s {mp3,ogg,wav,flac,fla}='mplayer'
# Auto open other files
alias -s blend='blender'
alias -s svg='inkscape'
alias -s tex='kile'
alias -s psd='gimp'
alias -s iso='k3b'

####
# Aliases
########
alias reload='source ~/.zshrc; rehash'
alias zshrc=$EDITOR' ~/.zshrc ; reload'
alias zs='zshrc'
alias i3c=$EDITOR' ~/.i3/config ; i3-msg restart'
alias vimrc=$EDITOR' ~/.vimrc'

alias bestof="history | awk '{a[\$2]++ }END{for(i in a){print a[i]" "i}}' | sort -rn | head"
alias sounduse='fuser -v /dev/snd/* /dev/dsp*'

alias xx='extractlast'
alias x='extract'

alias oo='ooffice'
alias p='mplayer -msgcolor -msglevel all=0:statusline=9 -monitoraspect 4:3'
alias fastplay='mplayer -af scaletempo -speed'
alias m='cmus'

alias -- -='cd -'

# Is there any grc app installed (to colorize output)?
if [ `hash grc 2>/dev/null` ]; then
    alias cl='grc -es --colour=auto'
    alias wcc='cl i686-mingw32-gcc'
    alias as='cl as'
    alias ld='cl ld'
    alias gcc='cl gcc'
    alias g++='cl g++'
    alias gas='cl gas'
    alias diff='cl diff'
    alias make='cl make'
    alias ping='cl ping -c 3'
    alias netstat='cl netstat'
    alias configure='cl ./configure'
    alias traceroute='cl /usr/sbin/traceroute'
fi

alias build="./configure --prefix=/usr && make && su -c 'make install'"
alias nomake='/usr/bin/make -s'
alias vcm='vi **/CMakeLists.txt'
alias mk='make -j5'
alias mi='make install'
alias cm="cmake -H. -Bbuild && (cd build && make -j5)"
alias menuconfig='nomake menuconfig'

alias ls='ls -vFG --color=auto' sl='ls'
alias ll='ls -l' mm='ll'
alias l1='ls -1'
alias l='ls -dF'
alias la='ls -la'
alias lh='ls -lh'
alias lx='ls -lXB'
alias l.='ls -d .[^.]*'
alias lse='ls -d *(/^F)'
alias lll='ls -la | less'
alias lsx='ls -l *(*[1,10])'
alias lsd='ls -d [^.]*(-/DN)'
alias lsbig="ls -flh *(.OL[1,10])"
alias lsnew="ls -rl *(D.om[1,10])"
alias lsold="ls -rtlh *(D.om[1,10])"
alias lssmall="ls -Srl *(.oL[1,10])"

alias cd..='cd ..'
alias '..'='cd ..'

[ -f "/usr/bin/acp" ] && alias cp='nocorrect acp -g ' || alias cp='nocorrect cp'
[ -f "/usr/bin/amv" ] && alias mv='nocorrect amv -g ' || alias mv='nocorrect mv'
nocorrect rmcd() { cd .. && rmdir -v "$OLDPWD"; }
nocorrect mcd(){ mkdir -vp "$1" && cd "$1"; }
alias mkdir='nocorrect mkdir -p'
alias mkcd='mcd'
alias md='mkdir'
alias rd='rmdir'

alias grep='grep --color=auto'
#alias chmod='chmod -c' # not working on OS-X
#alias chown='chown -v'
alias tree='tree -FC'
alias ps='ps auxww' #'f' not working on OS-X
alias hex='od -t x1'

alias getkey='gpg --recv-keys --keyserver wwwkeys.pgp.net'
alias route='route -n'

alias nano='nano -w'
alias :e=$EDITOR
alias @=$EDITOR
alias :q='exit'

alias tmux="tmux -2"

alias G='grep'
alias J='jobs'
alias T='tmux'
alias S='screen'
alias W='watch'
alias W0='watch -n 0'
alias W1='watch -n 1'

alias bigfiles='BLOCKSIZE=1048576 du -x | sort -nr | head -10'
alias duf='du -sh * .* | sort -h'
alias duh='du -sh'
alias sizeof='duh'
alias dfh='df -lPH | grep -v "^tmpfs" | sort -hk3'
alias dff='df -lPH | awk "NR==1 || /^tmpfs/" | sort -hk3'

alias xlog="grep --binary-files=without-match --color -nsie '(EE)' -e '(WW)' /var/log/Xorg.0.log"
alias lastkernel='lynx -dump http://kernel.org/kdist/finger_banner' lk='lastkernel'
alias tmsg='tail -f /var/log/messages'

alias gd="git diff"
alias gl="git rlog"
alias gll="git slog"
alias gs="git status"
alias gc="git commit"
alias gca="git commit -a"
alias ga="git add"
alias gt="git tag"
alias gb="git branch"
alias gj="git checkout"
alias gjc="git checkout -b"
alias gm="git merge --no-ff"
alias gcl="git clone"
alias gh="hub clone"

alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias rc="rails console"
alias rs="rails server"

alias netip="curl icanhazip.com"
alias lanip='ip addr show dev $(ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$3 }"'
alias lanprefix='ip addr show dev $(ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$4 }"'

alias please='sudo $(fc -ln -1)'
#alias a="sudo aptitude"
#alias ai="sudo aptitude install"
#alias as="aptitude search"

#systemctl enable ...
#systemctl start ...

alias cx="chmod +x"


####
# Small functions
########
load() { for conf; do [ -e "$conf" ] && source "$conf"; done }
calc() { echo "$*" | bc }
sdate() { date +%d-%m-%Y }
.grep() { grep "$*" -R . }

arg() { awk "{print \$$1}" }
mdc() { mkdir -p "$1" && cd "$1" }
plap() { ls -l ${^path}/*$1*(*N) }
suidfind() { ls -latg $path/*(sN) }
psg() { ps auxww | grep $1 | grep -vv grep }
isocdrom() { dd if=/dev/cdrom of=$1 bs=2048 }
isoburner() { dd if=/dev/burner of=$1 bs=2048 }
hgrep() { grep $1 ~/.zsh_history | sed s"/[^;]*;//" }
remindme() { sleep $1 && zenity --info --text "$2" & }
wikien() { ${=BROWSER} http://en.wikipedia.org/wiki/"${(C)*}" }
wikifr() { ${=BROWSER} http://fr.wikipedia.org/wiki/"${(C)*}" }
disassemble() { gcc -pipe -S -o - -O -g $* | as -aldh -o /dev/null }
google() { ${=BROWSER} "http://www.google.com/search?&num=100&q=$*" }
gethrefs() { perl -ne 'while ( m/href="([^"]*)"/gc ) { print $1, "\n"; }' $* }
backup() { tar jcvf "$HOME/Backups/`basename $1`-`date +%Y%m%d%H%M`.tar.bz2" $1 }
getlinks() { perl -ne 'while ( m/"((www|ftp|http):\/\/.*?)"/gc ) { print $1, "\n"; }' $* }
timezone() { ruby -e "require 'tzinfo'; puts Time.parse('$*').strftime('=> %Hh%M - %d/%m/%Y (%Z)');" }

clear-screen-motd() { clear; motd; zle push-input; zle send-break }
exec-ncmpc() { BUFFER="ncmpc" ; zle accept-line }
exec-alsamixer() { BUFFER="alsamixer" ; zle accept-line }
comment-line() { BUFFER="#"$BUFFER ; zle accept-line }
start-background() { BUFFER=$BUFFER" &" ; zle accept-line }
start-root() { BUFFER='su -c "'$BUFFER'"' ; zle accept-line }
paste-xclip() { BUFFER=$BUFFER"`xclip -o`" ; zle end-of-line }
start-silent() { BUFFER=$BUFFER" &>/dev/null" ; zle accept-line }
repeat-second-last() { zle up-history ; zle up-history ; zle accept-line ; }
zle -N repeat-second-last
zle -N clear-screen-motd
zle -N start-background
zle -N exec-alsamixer
zle -N comment-line
zle -N start-silent
zle -N paste-xclip
zle -N exec-ncmpc
zle -N start-root

####
# Big functions
########

# Extract the file and delete it. (by wellspring)
extractlast () {
    filename=$(basename $_)
    if [ -e $filename ]; then
        extract $filename
        rm $filename
    else
        echo "Error: file $filename doesn't exist."
    fi
}

# Jump between directories (by Nikolai Weibull)
d () {
    emulate -L zsh
    autoload -U colors
    local color=$fg_bold[blue]
    integer i=0
    dirs -p | while read dir; do
        local num="${$(printf "%-4d " $i)/ /.}"
        printf " %s  $color%s$reset_color\n" $num $dir
        (( i++ ))
    done
    integer dir=-1
    read -r 'dir?Jump to directory: ' || return
    (( dir == -1 )) && return
    if (( dir < 0 || dir >= i )); then
        echo d: no such directory stack entry: $dir
        return 1
    fi
    cd ~$dir
}

# Jump between project directories (by wellspring)
g () {
    if [ ! -e ~/.zshdirs ]; then
        echo "Please use the command gadd to add a new directory in ~/.zshdirs"
        return
    fi
    dirs=$(sed '/^$/d' ~/.zshdirs)
    max=$(echo $dirs | wc -l)
    dir=-1
    echo $dirs | nl
    read -r 'dir?Jump to directory: ' || return
    if (( dir < 0 || dir >= max )); then
        echo g: no such directory number $dir
        return 1
    fi
    cd $(echo $dirs | sed -n "${dir}p")
}
gadd () {
    if [ ! -d "$1" ]; then
        echo "Usage: $0 <dir>"
        echo "  (then use the cmd 'g' to select a directory to goto)"
        exit
    fi
    ls -d "$*" >> ~/.zshdirs
}

# Add the specified path to the $PATH if it's not there yet
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Find out which libs define a symbol (by grml-team)
lcheck () {
    if [[ -n "$1" ]] ; then
        nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
    else
        echo "Usage: lcheck " >&2
    fi
}

# Clean up directory by removing well known tempfiles (by grml-team)
purge () {
    FILES=(*~(N) .*~(N) \#*\#(N) *.o(N) a.out(N) *.core(N) *.cmo(N) *.cmi(N) .*.swp(N))
    NBFILES=${#FILES}
    if [[ $NBFILES > 0 ]] ; then
        print $FILES
        local ans
        echo -n "Remove these files? [y/n] "
        read -q ans
        if [[ $ans == "y" ]] ; then
            rm ${FILES}
            echo ">> $PWD purged, $NBFILES files removed"
        else
            echo "Ok. .. than not.."
        fi
    fi
}

# RFC 2396 URL encoding in Z-Shell (by grml-team)
urlencode () {
    setopt localoptions extendedglob
    input=( ${(s::)1} )
    print ${(j::)input/(#b)([^A-Za-z0-9_.!~*\'\(\)-])/%${(l:2::0:)$(([##16]#match))}}
}

# Slowly print out parameters (by grml-team)
slow_print() {
    for argument in "${@}" ; do
        for ((i = 1; i <= ${#1} ;i++)) ; do
            print -n "${argument[i]}"
            sleep 0.08
        done
        print -n " "
    done
    print ""
}

# Replacement for command cp with a progress bar. (by wellspring)
function ccp () {
    ! [[ $# -ge 2 ]] && echo "Usage : $0 <src> <dest>" && return 1
    rsync --progress -av $*
}

#-- NEW--
ssh() { if [ $# -eq 0 ]; then ssh-select; else command ssh "$@"; fi }


#---------------------------------------------------------------------------------------------------
# Security:
# ========
trap clear 0  # Clear screen on logout
umask 077     # Set the default permissions


#---------------------------------------------------------------------------------------------------
# Prompt:
# ======

# -- Set the prefix for the terminal's window.
TITLE_PREFIX="  "

# -- Set the powerline prompt
if [ -n "$SSH_CLIENT" ]; then
  c=${DOCKER_MACHINE_NAME:+30}${DOCKER_MACHINE_NAME:-240}
  HOST_PS1="%K{160}%F{7} SSH @ %m %F{160}%K{$c}%F{7}"
  TITLE_PREFIX="${TITLE_PREFIX}SSH @ $HOST » "
fi
if [ -n "$DOCKER_MACHINE_NAME" ]; then
  HOST_PS1="${HOST_PS1}%K{30}%F{7} DOCKER @ $DOCKER_MACHINE_NAME %F{30}%K{240}%F{7}"
  TITLE_PREFIX="${TITLE_PREFIX}DOCKER @ $DOCKER_MACHINE_NAME » "
fi
DIR_PS1='%K{240} ${vcs_info_msg_0_/\/.\///}'

NL=$'\n'
PS0="%f%k${HOST_PS1}${DIR_PS1}"                     # (base prompt)
PS1="$NL$PS0%k%f "                                 # Normal prompt (left): ssh/docker, dir/vcs
RPS1="%F{234}❰ %T ❱%f%(1j. [%j].)%(!. %B%F{160}%f%K{160}|%n|.%b)%f%k" # Normal prompt (right): time, bg jobs, isroot
PS2="$PS0%K{7}%F{0} %_ %F{7}%k%f "                # Special prompt (for/quote/if/...): re-use the base prompt.
PS3=" "                                            # Special prompt (select): as simple as possible.

echo -en "\e[5 q"                                   # set term cursor: 1/2: "#", 3/4: "_", 5/6: "|" (blink/not)

# -- Version Control System support
zstyle ':vcs_info:*' enable             git svn cvs hg
zstyle ':vcs_info:*' check-for-changes  true
zstyle ':vcs_info:*' use-prompt-escapes true
zstyle ':vcs_info:*' nvcsformats        '%~ %F{240}%K{234}'
zstyle ':vcs_info:*' formats            '(%s:%F{6}%r%F{7})/%S/ %F{240}%K{234}%F{7}%K{234} %u%c%b %F{234}'
zstyle ':vcs_info:*' actionformats      '(%s:%F{6}%r%F{7})/%S/ %F{240}%K{234}%F{7}%K{234} %u%c%b [%a] %F{234} '
zstyle ':vcs_info:*' unstagedstr        $'%F{1}\uE0A0 ✱'
zstyle ':vcs_info:*' stagedstr          $'%F{3}\uE0A0 ✚'

# -- Set hooks (for VCS, title, and printing a newline before the command output)
preexec(){echo; title "Terminal » $1"; _CMDSTARTTIME=$EPOCHSECONDS } # after prompt / before exec cmd
precmd(){vcs_info; title "ZSH"; (( ${EPOCHSECONDS:-0} - ${_CMDSTARTTIME:-0} > $REPORTTIME )) && notify-window } # before prompt / after exec cmd

#---------------------------------------------------------------------------------------------------
# .start
# ======
load /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
load /usr/share/autojump/autojump.zsh
load /usr/share/doc/pkgfile/command-not-found.zsh
load /etc/zsh_command_not_found
load ~/.fzf.zsh
load ~/.zshrc.local
load ~/.zshext
motd


# vim: ft=zsh fileencoding=utf8
