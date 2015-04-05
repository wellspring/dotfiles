function center --description 'Center a text in the terminal (can be multiline, e.g. ascii drawing)'
	awk 'function space(){for(i=0;i<('$COLUMNS'/2-length($0)/2)-0.5;i++)printf " "} {space();printf $0;space();print ""}' $argv;
end
