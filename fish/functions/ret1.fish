function ret1 --description 'opcodes for "return 1" (in asm x86; 32bits)'
	asm 'xor eax,eax\ninc eax\nret'
end
