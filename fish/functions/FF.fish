function FF --description 'print 0xff multiple times for pentest/security (syntax: FF x 512)'
	perl -e "print \"\xff\" x $argv[2]"
end
