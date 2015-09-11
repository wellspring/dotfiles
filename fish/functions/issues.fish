function issues --description 'list redmine issues (Usage: issues <subject-filter>'
	set -l search $argv
  curl -sH "X-Redmine-API-Key: $REDMINE_KEY" "$REDMINE_URL/projects/roadmap/issues.json?utf8=%E2%9C%93&set_filter=1&f%5B%5D=status_id&op%5Bstatus_id%5D=o&f%5B%5D=subject&op%5Bsubject%5D=%7E&v%5Bsubject%5D%5B%5D=$search&f%5B%5D=&limit=100" | jq -r '.issues[] | "#"+(.id|tostring)+"\t\t"+.subject'
end
