function A --description 'print 0x41 multiple times for pentest/security (syntax: A x 512)'
	perl -e "print 'A' x $argv[2]"
end
