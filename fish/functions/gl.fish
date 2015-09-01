function gl --description Show\ the\ changes\ made\ in\ a\ feature\ branch\ \(\'glb\'\ stands\ for:\ git\ log\ branch\)
	set -l branch (current-git-branch)
  set -l parent_branch (git show-branch -a 2>/dev/null | awk -F[][] '/\*/ && !/'(echo $branch | sed 's/\//\\\\&/')'/ {print $2;exit}')

  if [ $branch != 'master' ]
    echo "Changes made in $branch:"
    git trlog -10000 $argv master..
  else
    git trlog $argv
  end
end

