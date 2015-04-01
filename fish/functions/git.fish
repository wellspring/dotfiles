function git
	if type -P hub >/dev/null
    hub $argv;
  else
    eval (which git) $argv;
  end
end
