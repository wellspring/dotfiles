function mail-cleanup-branches
	git for-each-ref --sort=-committerdate --format="%(authorname) %(authoremail)|%(refname:short)" (git branch -r --merged origin/master | sed -e 's#^ *#refs/remotes/#') | awk -F '|' '{b[$1]=b[$1]"\\\\n- "$2} END{for(author in b)print "echo -n \"Hej,\\\\n\\\\nSome of your branches seems to be merged in master but still exists.\\\\nPlease remove those remote branches if not using them anymore:"b[author]"\\\\n\\\\nM.v.h\\\\nX\" | mail -s \"branches already merged\" \""author"\"\n"}'
end
