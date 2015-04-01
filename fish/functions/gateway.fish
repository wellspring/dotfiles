function gateway --description 'Get the default gateway (e.g. 192.168.1.1)'
	ip route | awk '/default/ {print $3}'
end
