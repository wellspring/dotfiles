function bpatch --description Patch\ file\ \(usage:\ bpatch\ \<filename\>\ \<offset\>\ \<bytes\>\;\ e.g.\ bpatch\ crackme\ 0x255f\ \'33\ c0\ 40\ c3\'\)
	echo (printf '%06x' $argv[2]): "$argv[3]" | xxd -r - $argv[1]
end
