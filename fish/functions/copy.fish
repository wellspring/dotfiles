function copy --description 'Copy the last command into the clipboard'
	echo $history[1] | clipboard-copy
end
