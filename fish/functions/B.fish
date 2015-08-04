function B --description 'print 0x42 multiple times for pentest/security (syntax: B x 512)'
	perl -e "print 'B' x $argv[2]"
end
