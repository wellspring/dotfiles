function js --description 'Download a javascript library by name (require jq+wget+xargs)'
	wget -qO- "http://api.cdnjs.com/libraries?search=$argv" | jq ".results[] | select(.name == \"$argv\") | .latest" | xargs wget; 
end
