function ports
	lsof -Pn +M -i4 -sTCP:LISTEN $argv; 
end
