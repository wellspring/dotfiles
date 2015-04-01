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
