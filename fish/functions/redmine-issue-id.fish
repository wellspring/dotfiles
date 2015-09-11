function redmine-issue-id -d "Strip out redmine issue id (from #id or url)"
  echo $argv | sed 's_.*/__g;s/\..*//g;s/[^0-9]//g'
end
