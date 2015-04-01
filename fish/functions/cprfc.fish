function cprfc --description 'Copy a specified RFC to a file or directory'
	cp /disk/doc/rfc/rfc$argv[1].txt $argv[2]; 
end
