function clipboard-paste --description 'Paste text from clipboard.'
	commandline -i (xclip -o -selection clipboard)
end
