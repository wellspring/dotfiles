function iftop --description 'display bandwidth usage on an interface by host (alias with sudo)'
	RUN_AS_ROOT iftop -B
end
