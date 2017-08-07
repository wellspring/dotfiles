function hex2binary --description 'Convert hex to binary (e.g. hex2binary 41424344 -> ABCD)'
	echo -n "$argv" | xxd -r -p
end
