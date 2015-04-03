function wiki --description 'Search for something on wikipedia (en)'
	eval $BROWSER "https://en.wikipedia.org/wiki/$argv"
end
