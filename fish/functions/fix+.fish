function fix+ --description 'automatically find which file introduced a file change recently, and then fix it'
  set -l file $argv[1]

  # If no file is specified, try to find the last one that has been edited.
  if test (count $argv) -eq 0
    set file (last-edited-file)
    git add $file
  end

  # Try to find the commit, and fix it.
	set -l commit_id (git log -1000 --pretty="format:[%H]" --name-status | grep -B1000 $file -m1 | tac | grep -m1 '^\[' | tr -d '][')
  if test -n $commit_id
    fix $commit_id
  else
    echo "Error: Can't find commit for file $file"
  end
end
