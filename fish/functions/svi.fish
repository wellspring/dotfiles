function svi --description 'Run vi/vim as root (using sudo or su -c)'
	RUN_AS_ROOT vi $argv;
end
