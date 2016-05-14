function github-search
	curl -sG https://api.github.com/search/repositories -d "q=$argv" | jq -r '.items[] | "%x1b[0m- %x1b[32m"+.name+"%x1b[0m: %x1b[33m"+.description+" %x1b[0m--%x1b[34m "+.html_url'| sed 's/%x1b/\x1b/g' | tee "/tmp/last-github-search-$USER" | head -15
end
