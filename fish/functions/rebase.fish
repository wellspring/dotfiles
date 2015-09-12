function rebase
  if test (current-git-branch) = master
    # On master? Then fetch remote changes on master, merge them, and re-apply the changes on top of it.
    git stash
    git pull --rebase
    git stash pop
  else
    # On another branch? Then save what's done, fetch the changes, and re-apply the changes on top of master.
    git stash
    git fetch
    git rebase origin master
    git stash pop
  end

  # Display logs
  gl
end
