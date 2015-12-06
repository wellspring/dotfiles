function git-branch-menu -d "Show a menu to select a git branch"
  git branch $argv | fzf --prompt "Git branch to switch to: " --cycle --extended -i +s | xargs git checkout;
end
