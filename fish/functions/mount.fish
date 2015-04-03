function mount --description 'Mount a volume (with arguments) or display mounted volumes (without argument)'
	if count $argv >/dev/null
    eval (which mount) $argv
  else
    eval (which mount) | column -t | sed 's/^\(\S*\s*\)on\s*\(\S*\s*\)type\s*\(\S*\s*\)*\((.*)\)$/\x1b[31m\1\x1b[32m\2\x1b[33m\3\x1b[36m\4\x1b[0m/'
  end
end
