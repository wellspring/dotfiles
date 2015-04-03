function google --description 'Search for something on google'
	eval $BROWSER "https://www.google.com/search?num=100&q=$argv"
end
