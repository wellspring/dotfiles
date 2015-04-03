function line --description 'Return the specified line in the file/pipe (syntax: line <line_no> [file])'
	echo $argv | read -l line filename
	eval sed $line'!d' $filename
end
