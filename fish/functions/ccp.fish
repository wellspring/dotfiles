function ccp --description 'cp with progress bar'
	rsync --progress -av $argv
end
