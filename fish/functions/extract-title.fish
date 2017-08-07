function extract-title
	awk '/<title>/,/<\/title>/' | sed 's/<[^>]*>//g'
end
