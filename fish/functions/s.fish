function s --description 'Search for a package on the system.'
	package search $argv | awk 'function sep(){print "-----"} BEGIN{sep()} /^aur/{if(!x){x=1;if(NR>1){sep()}}} /^\S/{split($1,pkg,"/");version=$2;installed=0} /\[installed\]/{installed=1} /^\s/{desc=$0;sub(/\s*/,"",desc); print "\x1b[0m- \x1b["(31+installed)"m"pkg[2]"\x1b[0m: \x1b[33m"desc" \x1b[0m(\x1b[34mv"version"\x1b[0m, in \x1b[34m"pkg[1]"\x1b[0m)"} END{sep()}' | less
end
