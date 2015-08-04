function NOP --description 'print 0x90 multiple times for pentest/security (syntax: NOP x 512)'
	perl -e "print \"\x90\" x $argv[2]"
end
