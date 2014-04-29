# Aliases
alias pig='ping -c 3 www.google.com'
alias scan='nmap localhost'
alias route='route -n'
alias ports='lsof -Pn +M -i4 -sTCP:LISTEN'
alias wget-fast='axel -a'
alias wifi='RUN_AS_ROOT wifi-menu'

# Other aliases
function netip
    curl icanhazip.com
end
function lanip
    ip addr show dev (ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$3 }"
end
function lanprefix
    ip addr show dev (ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$4 }"
end

