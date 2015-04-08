function livecoding.play --description 'Play a live coding stream on livecoding.tv'
	set -l livecodinguser (lower $argv[1])
  set -l chat_url "https://www.livecoding.tv/chat/$livecodinguser/"
  set -l stream_url (curl -s "https://www.livecoding.tv/$livecodinguser/" -H 'Cookie: sessionid='(cat ~/.livecodingtv.session)';' | grep -Po 'rtmp://[^"]+')

  echo Playing user (echo $livecodinguser | colorize 198) ...
  echo "  -> stream: $stream_url" | colorize 242
  echo "  -> chat: $chat_url" | colorize 242

  vlc $stream_url 2>/dev/null &
  #eval $BROWSER $browser_url
end
