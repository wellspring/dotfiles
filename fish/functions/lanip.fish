function lanip --description 'Get the LAN IP address (ipv4)'
	ip addr show dev (ip route | awk "/^default/ {print \$5}") | awk -F"[ /]*" "/scope global/ { print \$3 }"
end
