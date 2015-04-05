function ok --description Display\ a\ green\ \'OK\'\ in\ ascii\ art
	figlet -w $COLUMNS -f blocks ok | center | colorize 2
end
