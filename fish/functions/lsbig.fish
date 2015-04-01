function lsbig --description 'List the 10 biggest files/folders in the specified directory.'
	du -sh $argv/* | sort -rh | head
end
