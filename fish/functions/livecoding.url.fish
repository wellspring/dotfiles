function livecoding.url
  set -l stream (echo $argv[1] | sed 's_^https\?://\(www\.\)\?livecoding\.tv/__')
  curl -s "https://www.livecoding.tv/$stream" | awk -F'"' '/ file:"/{print $2}' | tail -1
end
