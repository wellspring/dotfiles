function da --description 'Start a Docker container, and attach.'
	docker start $argv[1]; and docker attach $argv[1]
end
