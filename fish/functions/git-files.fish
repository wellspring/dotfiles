function git-files --description 'List files from a specific commit (Usage: git-files <commit-id>)'
	git show $argv --pretty=format: --name-only | tr '\n' ' '
end
