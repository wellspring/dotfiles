function stream
	switch $argv[1]
    case list
      curl -s http://www.solarmovie.is/popular-movies.html | grep -o '/watch-[^"]*' | sort -u | sed 's_^_http://www.solarmovie.is_'
    case get
      for link in (curl -s $argv[2] | grep -o '/link/show[^"]*'| sed 's_^_http://www.solarmovie.is_;s_show_play_')
        echo -n "$link -> "
        curl -s $link | tr -d '\n' | grep -io '<iframe.*</iframe>' | grep -o 'http:[^"]*'
        #curl -s "$url" | grep '\.\(mp4\|flv\)[^.]' | grep -o 'http://[^"\']*' | head -1
      end
    case '*'
      echo "Error: unknown command $argv[1]"
  end
end
