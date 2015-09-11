function rfix --description 'git commit --allow-empty --squash <commit-id>  (to reword a commit in a non-destructive way)'
	git commit --allow-empty --squash $argv;
end
