function v
	set -l url (curl -s "$argv" | grep -Po 'http://[^\'"]*\.(mp4|flv|avi)[^\'"]*' | grep -Pv '\.(jpg|png)' -m1)
  set -l title (curl -s "$argv" | grep '<title' | sed 's/<[^>]*>//g;s/^\s*//;s/\s*$//')

  echo Playing (echo $title | colorize 198) ...
  echo "  -> $url" | colorize 240

  vlc --play-and-exit --quiet --no-video-title-show --fullscreen "$url" 2>/dev/null &
end
