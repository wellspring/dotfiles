function upper --description 'Transform text to upper case'
	if count $argv >/dev/null
    echo $argv | tr '[:lower:]' '[:upper:]'
	else
    tr '[:lower:]' '[:upper:]'
  end
end
