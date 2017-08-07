function less-onelineontwo --description 'less for long lines (highlight one line on two, for easier reading)'
	awk 'NR%2==0{print "\x1b[48;5;240m"$0} NR%2==1{print "\x1b[48;5;233m"$0} END{print "\x1b[0m"}' | less
end
