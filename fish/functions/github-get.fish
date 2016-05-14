function github-get
	git clone --depth=1 (awk 'NR=='$argv[1]' {print $NF}' "/tmp/last-github-search-$USER")
end
