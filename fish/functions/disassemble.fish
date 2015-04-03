function disassemble --description 'Disassemble a C/C++ code to ASSEMBLY (using gcc+as)'
	gcc -pipe -S -o - -O -g $argv | as -aldh -o /dev/null
end
