function livecoding.ls --description 'List livecoding.tv channels'
	echo "List of livecoding.tv channels:"
  curl -s https://www.livecoding.tv/livestreams/ | grep itemprop=\"name | sed 's/.*\?href="\//\x1b[0m- \x1b[32m/; s/\/".*\?><span itemprop="name">/\x1b[0m: \x1b[33m/; s/<\/span><\/a>/\x1b[0m/'
end
