function git
	if type -P hub >/dev/null
    hub $argv;
  else
    command git $argv;
  end
end
