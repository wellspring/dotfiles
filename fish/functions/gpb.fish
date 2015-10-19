function gpb --description 'Git Push Branch'
	git push --set-upstream origin (current-git-branch) $argv
end
