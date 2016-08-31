function github-search
  set -l query (echo $argv | tr ' ' '+')
  echo $query > /tmp/last-github-search-$USER.query
	curl -sG https://api.github.com/search/repositories'?page=1&per_page=100' -d "q=$query" | jq -r '.items[] | "%x1b[0m- %x1b[32m"+.name+"%x1b[0m: %x1b[33m"+.description+" %x1b[0m--%x1b[34m "+.html_url'| sed 's/%x1b/\x1b/g' | tee "/tmp/last-github-search-$USER" | less
end
