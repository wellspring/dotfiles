function lower --description 'Transform text to lower case'
	if count $argv >/dev/null
    echo $argv | tr '[:upper:]' '[:lower:]'
	else
    tr '[:upper:]' '[:lower:]'
  end
end
