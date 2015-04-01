function clipboard-paste2 --description 'Paste text from the x11 selection.'
	commandline -i (xclip -o -selection primary)
end
