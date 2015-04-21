function ytr --description 'Play a youtuberss video with vlc (Usage: ytr <#line>)'
	set -l cache_file "/tmp/youtube_rss.cache"
  set -l title (line $argv[1] "$cache_file" | cut -d^ -f2 | sed 's/ *$//')
  set -l url (line $argv[1] "$cache_file" | cut -d^ -f1)

  echo Playing (echo "$title" | colorize 198) ...
  echo " -> youtube url: $url"

  vlc --play-and-exit --quiet --no-video-title-show --fullscreen "$url" 2>/dev/null &
end
