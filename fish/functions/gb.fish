function gb --description 'List branches (using fzf) and switch to one of them.'
  set -l previousbranchfile (current-git-dir)/.git/previous-branch
  set -l branch (current-git-branch)

  if count $argv >/dev/null
    if test $argv[1] = '-'
      # (goto previous branch)
      git checkout (cat $previousbranchfile)
    else if test (echo $argv | head -c1) = '-'
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

  # Has the branch been changed? Save the previous branch name.
  if test $branch != (current-git-branch)
    echo $branch > $previousbranchfile
  end
end
