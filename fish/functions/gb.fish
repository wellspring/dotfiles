function gb --description 'List branches (using fzf) and switch to one of them.'
  set -l branch (current-git-branch)

  if count $argv >/dev/null
    if test \( ! $argv[1] = '-' \) -a \( (echo $argv | head -c1) = '-' \)
      # (show git branches list menu, with argument; e.g. -r for remotes branches)
      git-branch-menu $argv
    else
      # (goto specified branch)
      git checkout $argv
    end
  else
    # (show local git branches list menu)
    git-branch-menu
  end
end
