# Aliases
alias pig='ping -c 3 www.google.com'
alias scan='nmap localhost'
alias route='route -n'
alias ports='lsof -Pn +M -i4 -sTCP:LISTEN'
alias wget-fast='axel -a'
alias wifi='RUN_AS_ROOT wifi-menu'

# Other aliases
function netip -d "Get the Internet IP address (ipv4; through icanhazip.com)"
    curl icanhazip.com
end
function lanip -d "Get the LAN IP address (ipv4)"
    ip addr show dev (ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$3 }"
end
function lanprefix -d "Get the LAN prefix (e.g. 24)"
    ip addr show dev (ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$4 }"
end
function gateway -d "Get the default gateway (e.g. 192.168.1.1)"
    ip route | awk '/default/ {print $3}'
end
function resolve -d "Return all IP Adresses associated with a hostname (using nmap)"
   # resolve <host> [host [host [...]]]
   sudo nmap -Pn -sL -R $argv | grep --color=never -E -o -e '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' -e 'scan report for (\S+)' | sed 's/scan report for \(.*\)/\x1b[41m[\1]\x1b[00m/'
end

