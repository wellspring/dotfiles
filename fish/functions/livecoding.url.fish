function livecoding.url
  set -l stream (echo $argv[1] | awk '!/^http/{print $0"/"}' | sed 's_^https\?://\(www\.\)\?livecoding\.tv/__')
  curl -s "https://www.livecoding.tv/$stream" | awk -F'"' '/ file:"/{print $2}' | grep rtmp
end
