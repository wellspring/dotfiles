# Turn colorisation on
alias ls='ls -vFG --color=auto'
alias grep='grep --color=auto'
alias tree='tree -FC'

# Is there any grc app installed (to colorize output)?
if type -P grc >/dev/null
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
end

