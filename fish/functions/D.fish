function D --description 'print 0x44 multiple times for pentest/security (syntax: D x 512)'
	perl -e "print 'D' x $argv[2]"
end
