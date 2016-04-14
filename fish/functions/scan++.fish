function scan++ --description 'Tell which ports are open, on which interface, and by who.'
	netstat -neopol $argv;
end
