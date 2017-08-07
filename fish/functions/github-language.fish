function github-language --description 'get the programming language of the github repo from url'
	set -l repo (github-name $argv)
  curl https://api.github.com/repos/$repo | jq -r .language
end
