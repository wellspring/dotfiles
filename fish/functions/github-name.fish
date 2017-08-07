function github-name --description 'get github repo name from url'
	echo $argv | sed 's_\(https\?:\)\?//\(www.\)\?github.com/__'
end
