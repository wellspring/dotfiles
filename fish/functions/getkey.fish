function getkey
	gpg --recv-keys --keyserver wwwkeys.pgp.net $argv; 
end
