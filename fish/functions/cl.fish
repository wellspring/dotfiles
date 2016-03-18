function cl
  if type -P grc >/dev/null
    grc -es --colour=auto $argv;
  else
    eval "/usr/bin/$argv";
  end
end
