function extract-md5
	grep -o '[a-fA-F0-9]\{32\}' $argv;
end
