function github-description --description 'get github repo description from url'
	set -l repo (github-name $argv)
  curl https://api.github.com/repos/$repo | jq -r .description
end
