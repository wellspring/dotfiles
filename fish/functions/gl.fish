function gl --description Show\ the\ changes\ made\ in\ a\ feature\ branch\ \(\'glb\'\ stands\ for:\ git\ log\ branch\)
	set -l branch (current-git-branch)

  if [ $branch != 'master' ]
    echo "Changes made in $branch:"
    git trlog -10000 $argv master...
  else
    git trlog $argv
  end
end

