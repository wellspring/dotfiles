function interfaces --description 'List network interfaces (except lo, the local)'
	ip addr | awk -F '[ :]+' '/^[0-9]/&&!/: lo:/ { print $2 }'
end
