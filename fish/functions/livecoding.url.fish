function livecoding.url
	set -l livecodinguser (lower $argv[1])
  curl -s "https://www.livecoding.tv/$livecodinguser/" | awk -F'"' '/ file:"/{print $2}' | grep rtmp
end
