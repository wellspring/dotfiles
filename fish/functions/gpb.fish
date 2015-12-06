function gpb --description 'Git Push Branch'
	git push --set-upstream origin (current-git-branch) $argv
  firefox https://gitlab.egops.net/dev/sparkle/commits/(current-git-branch)
end
