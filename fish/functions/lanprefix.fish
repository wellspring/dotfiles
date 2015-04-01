function lanprefix --description 'Get the LAN prefix (e.g. 24)'
	ip addr show dev (ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$4 }"
end
