function ssh-proxy --description 'redirrect all connections (and dns requests) through ssh (Usage: ssh-proxy <server>)'
	sshuttle --dns -r $argv 0.0.0.0/0
end
