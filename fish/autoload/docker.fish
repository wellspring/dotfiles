# Aliases
alias docker-pid 'docker inspect --format "{{ .State.Pid }}" '
alias docker-ip 'docker inspect --format "{{ .NetworkSettings.IPAddress }}" '
alias docker-last-id 'docker ps -l -q'
alias dps 'docker ps'
alias dpsa 'docker ps -a'
alias drm 'docker rm'
alias drmi 'docker rmi'
#docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'

# Other aliases
function enter --description 'Enter/attach to a docker container, using nsenter (pkg:util-linux).'
  nsenter --target (docker inspect --format "{{ .State.Pid }}" "$argv[1]") --mount --uts --ipc --net --pid
end

function da --description 'Start a Docker container, and attach.'
  docker start $argv[1]; and docker attach $argv[1]
end

function newbox --description 'Create a new Docker container with the specified hostname'
  if set -q argv[1]
    switch "$argv[1]"
      case -a --archlinux --arch
        set template archlinux
      case -b --busybox
        set template busybox
      case -d --debian
        set template debian #sugi/debian-i386
      case '*'
        set template archlinux #DEFAULT
        set name "$argv[1]"
    end

    if set -q -- $name
      set name "$argv[2]"
    end

    docker run -it --rm -v /var/run/docker.sock:/var/run/docker.soc -e BOX_NAME="$name" --name "$name" -h "$name" -t "$template" /bin/sh
  else
    echo "newbox [--debian|--archlinux|--busybox] <hostname>"
  end
end

