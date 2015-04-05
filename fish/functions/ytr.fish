function ytr --description 'Play a youtuberss video with vlc (Usage: ytr <#line>)'
	set -l cache_file "/tmp/youtube_rss.cache"
  line $argv[1] "$cache_file" | cut -d^ -f1 | xargs vlc 2>/dev/null
end
