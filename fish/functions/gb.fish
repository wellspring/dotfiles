function gb --description 'List branches (using fzf) and switch to one of them.'
	git branch $argv | fzf --prompt "Git branch to switch to: " --tac --cycle --extended -i +s | xargs git checkout;
end
