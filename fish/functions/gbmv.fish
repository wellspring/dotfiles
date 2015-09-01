function gbmv --description 'git move/rename current branch to another name'
  if count $argv >/dev/null
    git branch -m $argv
  else
    set -l tmpfile (mktemp)
    dialog --title "-= git =-" --inputbox "Rename the current git branch to:" 8 60 (current-git-branch) > $tmpfile
    echo git branch -m (cat $tmpfile)
    rm $tmpfile
  end
end
