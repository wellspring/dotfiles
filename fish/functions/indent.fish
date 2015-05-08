function indent --description 'indent the input text and add a grey color'
	sed 's/^/    > /' | colorize 240
end
