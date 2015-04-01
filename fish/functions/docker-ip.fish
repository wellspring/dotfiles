function docker-ip
	docker inspect --format "{{ .NetworkSettings.IPAddress }}"  $argv; 
end
