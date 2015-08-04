function notag --description 'remove html/xml tags'
	perl -pe 's/<[^>]*>//g' $argv;
end
