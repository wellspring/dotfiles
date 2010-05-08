# ********************************************************************* #
#                            * .zshrc file *                            #
#                              ~~~~~~~~~~~                              #
#   Author         : wellspring <wellspring.fr A T gmail.com>           #
#   Description    : BASHrc/ZSHrc mix of configurations (dotfiles...)   #
#   Last modified  : 08/05/2010                                         #
#   Version        : 1.6.0                                              #
# ********************************************************************* #

####
# Variables
########
export WATCHFMT="%w %T ${HOST%%.*} watch: %n %a %(l:tty%l:unknown tty) %(M:from %M:locally)"
export LOGCHECK=5
export WATCH=all

#export CDPATH="~:/disk:/usr/src:/usr:/var"
#export FPATH="~/.zsh_functions"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=1000
export DIRSTACKSIZE=64

export BROWSER="firefox"
export SVN_EDITOR="vi"
export NULLCMD="cat"
export VISUAL="vim"
export PAGER="less"
export EDITOR="vi"

export VMWARE_USE_SHIPPED_GTK="yes"
export RAILS_ENV=development
export LC_COLLATE="C"

export MYNAME="wellspring"
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
# Create hash table to find faster commands and directories, and correct them.
setopt HASH_CMDS
setopt HASH_DIRS
# Log old paths automatically with pushd when using cd.
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
# Display PID and exit value on suspend and report them immediatly or at exit.
setopt PRINT_EXIT_VALUE
setopt LONG_LIST_JOBS
setopt CHECKJOBS
setopt NOTIFY
# Share commands in history between opened terminals.
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
#setopt SHARE_HISTORY
setopt BANG_HIST

####
# Prompt
########

if [ $TERM != "screen" ]; then
    export RPS1="%b <%T"
else
    export RPS1="%b"
fi

case $HOST in
  "Gentoo")
    if [ $UID == 0 ]; then
        prompt adam2 red yellow red blackk
    else
        prompt adam2 cyan green cyan blackk
    fi
    ;;

  "Laptop")
    if [ $UID == 0 ]; then
        export PS1="%b%k%F{white}[%F{red}r00t@%m%F{white}] %F{yellow}%1~ %# %B%f%k"
    else
        export PS1="%b%k%F{yellow}%n@%m%F{white}: %F{red}%1~ \$ %B%f%k"
    fi
    ;;

  "ethics")
    if [ $UID == 0 ]; then
        #export PS1="%b%k%F{white}(%F{red}r00t%F{white}@%F{red}%m%F{white}:%F{red}%1~%F{white}) %F{red}%# %B%f%k"
        export PS1="%b%k%F{white}(%F{cyan}r00t%F{white}@%F{cyan}%m%F{white}:%F{cyan}%1~%F{white}) %F{red}%# %B%f%k"
    else
        #export PS1="%b%k%F{red}(~o~) %F{white}%n%F{red}@%F{white}%m%F{red}:%F{white}%1~ %F{red}(~o~) %B%f%k"
        export PS1="%b%k%F{cyan}(~o~) %F{white}%n%F{cyan}@%F{white}%m%F{cyan}:%F{white}%1~ %F{cyan}(~o~) %B%f%k"
    fi
    ;;

  *)
    if [ $UID == 0 ]; then
        prompt gentoo
    else
        prompt gentoo
    fi
    ;;
esac


####
# Completion
########
# Use cache for commands with big list of results.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
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

if [[ $TERM == "rxvt" || $TERM == "xterm" ]]; then
    bindkey '^?'      backward-delete-char                # Ctrl+Backspace
    bindkey '^H'      backward-delete-word                # Backspace
    bindkey '^[[1;5D' backward-word                       # Ctrl+Left
    bindkey '^[[1;5C' forward-word                        # Ctrl+Right
    bindkey '^[[3;5~' delete-word                         # Ctrl+Del
    bindkey '^[[3~'   delete-char                         # Del
    bindkey '^[[2~'   overwrite-mode                      # Ins
else
    bindkey '^H'      backward-delete-char                # Ctrl+Backspace
    bindkey '^?'      backward-delete-word                # Backspace
    bindkey '^[[23~'  exec-alsamixer                      # F11
    bindkey '^[[24~'  exec-ncmpc                          # F12
fi

bindkey '^U'      undo                                # Ctrl+U
bindkey '^O'      paste-xclip                         # Ctrl+O
bindkey '^B'      start-background                    # Ctrl+B
bindkey '^P'      push-line                           # Ctrl+P
bindkey '^L'      clear-screen                        # Ctrl+L
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
alias -g wd='root@192.168.0.8'
alias -g :l="| $PAGER"
alias -g :g='| grep'
alias -g :h='| head'
alias -g :t='| tail'
alias -g :s='| sed'
alias -g :a='| awk'
alias -g :w='| wc'

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
alias -s {c,cpp,h,com,bat,css,xml,txt,lst,list,rc,conf,.htaccess,.htpasswd}=$EDITOR
# Auto open links
alias -s {com,org,net,fr,htm,html}=$BROWSER
# Auto open documents
alias -s {doc,docx,odt,sdw,xls,xlsx,xlc,sdc,ods,ppt,pptx,pps,sda,sdd,odp}='ooffice'
# Auto open pdf
alias -s {pdf,PDF}='xpdf'
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
alias zshrc=$EDITOR' ~/.zshrc ; source ~/.zshrc'
alias reload='source ~/.zshrc'
alias zs='zshrc'

alias bestof="history | awk '{a[\$2]++ }END{for(i in a){print a[i]" "i}}' | sort -rn | head"
alias sounduse='fuser -v /dev/snd/* /dev/dsp*'

alias xx='extractlast'
alias oo='ooffice'
alias x='extract'
alias p='mplayer'
alias m='ncmpc'

alias cl='/usr/bin/grc -es --colour=auto'
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
alias build="./configure --prefix=/usr && make && su -c 'make install'"
alias nomake='/usr/bin/make -s'
alias vcm='vi **/CMakeLists.txt'

alias ls='ls -vF --color=auto --group-directories-first'
alias ll='ls -l' mm='ll'
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

alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir -p'
alias md='mkdir'
alias rd='rmdir'

alias screenshot='clear && echo "ScreenShot  !" | figlet | cowsay -n -f kitty && scrot -c -d 5 -e "display $f"'

alias grep='grep --color=auto'
alias chmod='chmod -c'
alias chown='chown -v'
alias tree='tree -FC'
alias ps='ps auxfww'
alias hex='od -t x1'
alias cal='cal -m'

alias getkey='gpg --recv-keys --keyserver wwwkeys.pgp.net'
alias killthefox='kill `pidof firefox-bin`'
alias pig='ping -c 3 www.google.fr'
alias scan='nmap localhost'
alias route='route -n'
alias ports='lsof -i'

alias nano='nano -w'
alias vim='vi -S $(pwd)/Session.vim'
alias :e=$EDITOR
alias @=$EDITOR
alias :q='exit'

alias G='grep'
alias J='jobs'
alias S='screen'
alias W='watch'
alias W0='watch -n 0'
alias W1='watch -n 1'

alias bigfiles='BLOCKSIZE=1048576 du -x | sort -nr | head -10'
alias duf='du -sh *(/)'
alias duh='du -sh'
alias dfh='df -ah'

alias xlog="grep --binary-files=without-match --color -nsie '(EE)' -e '(WW)' /var/log/Xorg.0.log"
alias lastkernel='lynx -dump http://kernel.org/kdist/finger_banner' lk='lastkernel'
alias tmsg='tail -f /var/log/messages'

# [Asus laptop alias only]
if [[ $HOST == "Laptop" || $HOST == "ethics" ]]; then
    alias b='battery'
    alias entervm="ssh root@192.168.86.2"
    alias netip='echo Your internet IP address : $(wget -qO- www.whatismyip.com/automation/n09230945.asp)'
    alias lanip='echo -n "Your IP address on the lan is : " && ip addr show dev $(ip route | awk "/^default/ {print \$5}") | awk "/scope global/ { print \$2 }"'
    alias stdioe='lsof -a -p $$ -d0,1,2'
fi

# [Root alias only]
if [ $UID == 0 ]; then
    alias saydone='su '$MYNAME' -c "notify-send -i exclamation Information Done."'
    alias menuconfig='nomake menuconfig'

    alias sysupdate='layman -S && eix-sync && emerge -uavDN world'
    alias perlupdater='emerge -av1 `qfile /usr/lib/perl* -Cq | sort -u`'
    alias x86emerge='ACCEPT_KEYWORDS="~x86" emerge -av'
    alias aemerge='emerge -av'
    alias pemerge='emerge -pf'
    alias femerge='emerge -fv'
    alias unmerge='emerge -C'
    alias umerge='emerge -C'
    alias temerge='time emerge -v'

    alias vmake='vi /etc/make.conf'
    alias vuse='vi /etc/portage/package.use'
    alias vkeyw='vi /etc/portage/package.keywords'

    alias lan='arpdiscover 192.168.0.0 255 $(ip route | grep default | sed "s/.*dev //") | grep received | sort | uniq -c -f 7 -w $((3*6))'

    # [Asus laptop alias only]
    if [ $HOST == "Laptop" ]; then
        alias offline='switchto offline'
        alias s='switchto -s'

        alias bscr='echo 7 > /proc/acpi/asus/brn'
        alias sscr='echo 15 > /proc/acpi/asus/brn'

    alias ephemere='mount -t smbfs -o username=ESI\\67922 //paris2/Ephemere /mnt/ephemere'
    alias ephechat'clear && ls -c /mnt/ephemere/Discussions/ | sed "s/\.[a-zA-Z]\{3\}//" | tail'
    fi

    # [Ethics netbook alias only]
    if [ $HOST == "ethics" ]; then
        alias wifi='ifconfig eth0 down && ifconfig wlan0 up && wpa_supplicant -B -iwlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf && dhclient wlan0'
        alias eth='killall -q wpa_supplicant; ifconfig wlan0 down && ifconfig eth0 up && dhclient eth0'
        alias offline='killall -q wpa_supplicant; killall -q dhclient; ifconfig wlan0 down; ifconfig eth0 down'

	alias powerfull='cpufreq-set -c 0 -g performance && cpufreq-set -c 1 -g performance'
	alias powersave='cpufreq-set -c 0 -g powersave && cpufreq-set -c 1 -g powersave'
	alias powerauto='cpufreq-set -c 0 -g conservative && cpufreq-set -c 1 -g conservative'
	alias poweruser='cpufreq-set -c 0 -g userspace && cpufreq-set -c 1 -g userspace'

        alias ephemere='mount -t cifs -o username=ESI\\67922 //paris2/Ephemere /mnt/ephemere'
        alias ephechat'clear && ls -c /mnt/ephemere/Discussions/ | sed "s/\.[a-zA-Z]\{3\}//" | tail'
    fi

# [User alias only]
else
    alias freq3="mpg123 -v http://stream-hautdebit.frequence3.fr:8000/ 2> ~/.freq3"
    alias title="cat ~/.freq3 | grep --color=never StreamTitle | grep --color=never -vv \"A suivre: \" | tail -n 1 | sed -e \"s/.*e='\(.*\)';S.*/\1/\""

    alias vlcppc="vlc --sout '#transcode{vcodec=mp4v,vb=512,scale=1,acodec=mp3,ab=96,channels=2}:std{access=http,mux=asf,dst=:8080}' -I http [--http-src /disk/ftp/ --http-host :56443]"
    alias lcdd="mplayer /home/wellspring/Telechargements/lachansonsdudimanche/audio/*/*.mp3"
    alias scanner="xsane hpaio:/net/Photosmart_C6100_series?ip=192.168.0.7"
    alias c0de="screen -Am -S c0ding -t 'Programmation with VIM.'"

    alias windows="vmplayer '/disk/win/WindowsXP/actual/WinXP Virtual Machine.vmx'"
    alias winvnc="socat TCP-LISTEN:5649,fork TCP:172.16.243.129:22094"

    alias gunz="wine /home/wellspring/.wine/drive_c/Program\ Files/Gunz/GunzLauncher.exe"
    alias gunzonline="wine /home/wellspring/.wine/drive_c/Program\ Files/Gunz/eurogzz.exe"

    alias fastplay='mplayer -af scaletempo -speed'
    alias webcam='mplayer -vf screenshot tv:// -tv driver=v4l2:device=/dev/video0 -fps 16'

    # [Asus laptop alias only]
    if [ $HOST == "Laptop" ]; then
        alias wp='display -geometry 1440x900+0+0 -window root /home/wellspring/Documents/Images/wallpaper/artdigital/fresh-paper.com-wallpaper-3025-1440x900.jpg'
        alias sscreen="screen -c ~/Documents/SupInfo/Autre/screenrc"
        alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
        alias forwardtetrinet='ssh -L 31457:87.98.131.200:31457 wellspring.is-a-geek.net'
        
        alias fruityloops="wine ~/.wine/drive_c/Program\ Files/Image-Line/FL\ Studio\ 8/FL.exe"
	alias glogs='git log --pretty=format:"%h %an %ar - %s"'
    fi
fi

####
# Small functions
########
cx () { chmod +x $* }
calc() { echo "$*" | bc }
sdate() { date +%d-%m-%Y }
.grep() { grep "$*" -R . }
getline() { sed $1'!d' $2 }
arg() { awk "{print \$$1}" }
shrar() { unrar l $1 | $PAGER }
shzip() { unzip -l $1 | $PAGER }
shtgz() { tar -tvzf $1 | $PAGER }
spell() { echo "$@" | aspell -a }
shtbz2() { tar -tvjf $1 | $PAGER }
mdc() { mkdir -p "$1" && cd "$1" }
plap() { ls -l ${^path}/*$1*(*N) }
suidfind() { ls -latg $path/*(sN) }
psg() { ps auxww | grep $1 | grep -vv grep }
isocdrom() { dd if=/dev/cdrom of=$1 bs=2048 }
isoburner() { dd if=/dev/burner of=$1 bs=2048 }
hgrep() { grep $1 ~/.zsh_history | sed s"/[^;]*;//" }
remindme() { sleep $1 && zenity --info --text "$2" & }
rot13() { tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" }
wikien() { ${=BROWSER} http://en.wikipedia.org/wiki/"${(C)*}" }
wikifr() { ${=BROWSER} http://fr.wikipedia.org/wiki/"${(C)*}" }
disassemble() { gcc -pipe -S -o - -O -g $* | as -aldh -o /dev/null }
google() { ${=BROWSER} "http://www.google.com/search?&num=100&q=$*" }
gethrefs() { perl -ne 'while ( m/href="([^"]*)"/gc ) { print $1, "\n"; }' $* }
backup() { tar jcvf $HOME/Backups/`basename $1`-`date +%Y%m%d%H%M`.tar.bz2 $1 }
getlinks() { perl -ne 'while ( m/"((www|ftp|http):\/\/.*?)"/gc ) { print $1, "\n"; }' $* }
timezone() { ruby -e "require 'tzinfo'; puts Time.parse('$*').strftime('=> %Hh%M - %d/%m/%Y (%Z)');" }

exec-ncmpc() { BUFFER="ncmpc" ; zle accept-line }
exec-alsamixer() { BUFFER="alsamixer" ; zle accept-line }
comment-line() { BUFFER="#"$BUFFER ; zle accept-line }
start-background() { BUFFER=$BUFFER" &" ; zle accept-line }
start-root() { BUFFER='su -c "'$BUFFER'"' ; zle accept-line }
paste-xclip() { BUFFER=$BUFFER"`xclip -o`" ; zle end-of-line }
start-silent() { BUFFER=$BUFFER" &>/dev/null" ; zle accept-line }
repeat-second-last() { zle up-history ; zle up-history ; zle accept-line ; }
zle -N repeat-second-last
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
# Display ANSI colors (by grml-team)
ansi-colors () {
    typeset esc="\033[" line1 line2
    echo " _ _ _40 _ _ _41_ _ _ _42 _ _ 43_ _ _ 44_ _ _45 _ _ _ 46_ _ _ 47_ _ _ 49_ _"
    for fore in 30 31 32 33 34 35 36 37; do
        line1="$fore "
        line2="   "
        for back in 40 41 42 43 44 45 46 47 49; do
            line1="${line1}${esc}${back};${fore}m Normal ${esc}0m"
            line2="${line2}${esc}${back};${fore};1m Bold   ${esc}0m"
        done
        echo -e "$line1\n$line2"
    done
}

# Uncompress any kind of known archive. (by an unknown guy)
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjvf $1     ;;
            *.tar.gz)    tar xzvf $1     ;;
            *.tgz)       tar xzvf $1     ;;
            *.tbz2)      tar xjvf $1     ;;
            *.tar)       tar xvf $1      ;;
            *.gz)        gunzip $1       ;;
            *.bz2)       bunzip2 $1      ;;
            *.lzma)      extractlzma $1  ;;
            *.rar)       unrar x $1      ;;
            *.ace)       unace x $1      ;;
            *.zip)       unzip $1        ;;
            *.deb)       ar -x $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "Error: '$1' cannot be extracted via extract()." ;;
        esac
    else
        echo "Error: '$1' is not a valid file."
    fi
}

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

# Create small urls via tinyurl.com (by wellspring)
tinyurl () {
    [[ -z $1 ]] && print "Usage: tinyurl <url>" && return 1

    local url="http://tinyurl.com/create.php?url=$(urlencode $1)"

    print -n "Tiny URL : "
    wget -O - -o /dev/null "$url" | grep '^copy' | sed "s/.*'\([^']\+\)'.*/\1/"
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

# Print :( if the last command failed or :) otherwise. (by an unknown guy)
smiley () {
    if [ $? == 0 ]; then
        echo ':)'
    else
        echo ":( $?"
    fi
}

# Format titles for screen and rxvt. (by an unknown guy)
function settitle () {
  # Escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
    screen)
      print -Pn "\ek$a:$3\e\\"      # screen title (in ^H")
      ;;
    xterm*|rxvt)
      print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
      ;;
  esac
}

# The function precmd is called just before the prompt is printed. (by an unknown guy)
function precmd () {
  settitle "zsh" "$USER@%m" "%55<...<%~"
}

# The function preexec is called just before any command line is executed. (by an unknown guy)
function preexec () {
  settitle "$1" "$USER@%m" "%35<...<%~"
}

# Replacement for command cp with a progress bar. (by wellspring)
function ccp () {
    ! [[ $# -ge 2 ]] && echo "Usage : $0 <src> <dest>" && return 1
    rsync --progress -av $*
}

# [Root functions only]
if [ $UID == 0 ]; then
    # Say if the package is unmasked or not. (by wellspring)
    ismasked () {
        [[ -z "$1" ]] && echo "Usage : $0 <package>" && return 1

        local package=$(eix --only-names -e "$1")
        [[ -z $package ]] && echo "Error: Unknown package $1" && return 1

        if [[ -n $(grep "$package" /etc/portage/package.keywords) ]]; then
            echo "The package $package has been masked."
        else
            echo "This package isn't masked."
        fi
    }

    # Unmask a package. (by wellspring)
    unmask () {
        [[ -z "$1" ]] && echo "Usage : $0 <package> [package [...]]" && return 1

        for package in $*
        do
            local fullname=$(eix --only-names -e "$package")

            [[ -z $fullname ]] && echo "Warning: Unknown package $package" && continue
            package=$fullname

            if [[ -n $(grep "$package" /etc/portage/package.keywords) ]]; then
                echo "The package $package is already unmasked."
            else
                echo "$package ~x86" >> /etc/portage/package.keywords &&
                echo "The package $package has been unmasked."
            fi
        done
    }

    # Add useflags to a package. (by wellspring)
    use () {
        [[ -z "$1" ]] && echo "Usage : $0 <package> <useflag> [useflag [...]]" && return 1

        local package=$(eix --only-names -e "$1")
        [[ -z $package ]] && echo "Error: Unknown package $1" && return 1
        
        shift
        flags=$*

        if [[ -n $(grep "$package" /etc/portage/package.keywords) ]]; then
            sed -i "s/^\(${package//\//\\\/}\) .*/\1 $flags/" package.use
        else
            echo "$package $flags" >> /etc/portage/package.use
        fi

    }

    # Install kernel correctly. (by wellspring)
    install-kernel () {
        if ![ -f .config ]; then
            echo "Error: Please run menuconfig command first"
            exit
        fi

        if [ $PWD == "/usr/src/linux" ]; then
            KERNEL_VERSION=$(readlink /usr/src/linux | sed "s/^linux-//;s/\/$//")
        else
            if [ -n "$(echo $PWD | grep '/usr/src')" ]; then
                echo "Warning: Current kernel directory is not /usr/src/linux."
                KERNEL_VERSION=$(basename $PWD)
            else
                echo "Error: $PWD is an unknown path to install a kernel."
                exit
            fi
        fi

        mount /boot/
        cp .config /boot/config-$KERNEL_VERSION
        cp System.map /boot/system-$KERNEL_VERSION
        cp arch/x86/boot/bzImage /boot/kernel-$KERNEL_VERSION
        umount /boot/

        echo "The new kernel $KERNEL_VERSION is ready. Please reboot."
    }
    alias ikernel='install-kernel' ik='install-kernel'

    # Start the service.
    sstart()   { /etc/init.d/$1 start     }
    # Stop the service.
    sstop()    { /etc/init.d/$1 stop      }
    # Restart the service.
    srestart() { /etc/init.d/$1 restart   }
    # Add service at boot.
    rcadd()    { rc-update add $1 default }
    # Del service at boot.
    rcdel()    { rc-update del $1 default }
    # Show the changelog of the package.
    changelog(){ $PAGER "/usr/portage/$(eix --only-names -e $1)/ChangeLog" }
fi

# Clear screen on logout
trap clear 0

# Print the MOTD (not after "su" / "tmux" or in a TTY)
if [[ -e /etc/motd.conf && -z $(egrep "^(su|tmux|/bin/login)" /proc/$PPID/cmdline) ]]; then
    clear
    cat /etc/motd.conf
else
    echo ""
fi

# Go to home. (not after "tmux")
if [[ -z $(egrep "^(tmux)" /proc/$PPID/cmdline) ]]; then
    cd
fi

# Load additional file
if [ -e .zshext ]; then
    source .zshext
fi

