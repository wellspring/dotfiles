function fixit --description 'git commit (like fix command, but re-use the message of the commit that got removed after a `git reset HEAD~`)'
	git commit --reset-author --reedit-message='HEAD@{1}'
end
