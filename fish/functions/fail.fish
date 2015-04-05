function fail --description Display\ a\ red\ \'FAIL\'\ in\ ascii\ art
	figlet -w $COLUMNS -f blocks fail | center | colorize 1
end
