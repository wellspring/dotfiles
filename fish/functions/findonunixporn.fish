function findonunixporn
	set -l url $argv[1]
  curl -s https://www.reddit.com/r/unixporn | grep -o $url'" tabindex="1" >[^<]*' | sed 's/^[^>]*>//'
end
