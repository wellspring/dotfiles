function gl --description Show\ the\ changes\ made\ in\ a\ feature\ branch\ \(\'glb\'\ stands\ for:\ git\ log\ branch\)
  set -l branch (current-git-branch)

  if [ $branch != 'master' ]
    echo "Changes made in $branch:"
    git trlog -10000 $argv 'master..' | sed -r 's/\x1b\[38;5;198m(fixup|squash)!/\x1b[38;5;207m\1!\x1b[38;5;198m/g'
  else
    git trlog $argv | sed -r 's/\x1b\[38;5;198m(fixup|squash)!/\x1b[38;5;207m\1!\x1b[38;5;198m/g'
  end

  #@TODO: display in different color the ones already in a remote? -- should be straightforward with ack if the info is added in trlog
  #@TODO: list changes since (parent-git-branch)                   -- also try '@{-1}..' or '@{1}..' or alternative?
end

