function col --description 'Return the specified column in the file/pipe (syntax: col <column_no> [file])'
	echo $argv | read -l column filename
	eval awk "{print \$$column}" $filename
end
