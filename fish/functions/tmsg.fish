function tmsg
	tail -f /var/log/messages $argv; 
end
