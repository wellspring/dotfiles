function ret1_64 --description 'opcodes for "return 1" (in asm x86; 64bits)'
	asm64 'xor eax,eax\ninc eax\nret'
end
