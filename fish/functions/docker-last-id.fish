function docker-last-id
	docker ps -l -q $argv; 
end
