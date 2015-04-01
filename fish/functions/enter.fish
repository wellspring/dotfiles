function enter --description 'Enter/attach to a docker container, using nsenter (pkg:util-linux).'
	nsenter --target (docker inspect --format "{{ .State.Pid }}" "$argv[1]") --mount --uts --ipc --net --pid
end
