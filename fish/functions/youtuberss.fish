function youtuberss --description 'List the last videos of a user on youtube (then play with: ytr <#line>)'
	set -l channel $argv[1]
  set -l cache_file "/tmp/youtube_rss.cache"
  curl -s "https://gdata.youtube.com/feeds/base/users/$channel/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile" | xml sel -t -m '//item' -v "link" -o "^" -v 'title' -o "^" -v "pubDate" -n | sed 's/&amp;[^^ ]*//' | column -t -s '^' -o "^" > $cache_file
  awk -F'^' '{print "\x1b[38;5;198m"$1"  \x1b[38;5;178m"$2"  \x1b[38;5;238m"$3"\x1b[0m"}' $cache_file
end
