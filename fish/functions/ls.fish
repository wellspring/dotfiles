function ls
  command ls --color=auto -v -F -h -X --time-style=long-iso --group-directories-first $argv;
end
