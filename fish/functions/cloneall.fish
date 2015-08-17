function cloneall --description '(work) Clone all the repositories on gitlab'
	for repo in (curl -sH "PRIVATE-TOKEN: $GITLAB_KEY" "https://$GITLAB_HOST/api/v3/"projects | jq -r ".[].ssh_url_to_repo")
    set -l folder (basename -s .git "$repo")
    set -l dest ~/work/$folder
	  if test -d ~/work/$folder
      cd $dest
      #git pull
      cd -
    else
      git clone $repo $dest
    end
  end
end
