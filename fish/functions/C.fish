function C --description 'print 0x43 multiple times for pentest/security (syntax: C x 512)'
	perl -e "print 'C' x $argv[2]"
end
