function cl
	if type -P grc >/dev/null
    grc -es --colour=auto $argv;
  else
    eval $argv;
  end
end
