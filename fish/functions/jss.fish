function jss --description 'Search for a javascript library by name (require jq+moreutils+wget+sed)'
	echo -e "Searching for javascript libraries named '$argv'..."; wget -qO- "http://api.cdnjs.com/libraries?search=$argv&fields=version,description" | jq '.results[] | "> "+.name+" ("+.version+"):"+.description' | sed -e 's/^"\(.*\)"$/\1\x1b[00m/;s/ / \x1b[0;31m/;s/(/\x1b[00m(\x1b[33m/;s/): /\x1b[00m&/' | ifne -n echo "Nothing found."; 
end
