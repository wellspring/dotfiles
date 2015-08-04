function urls --description 'extract URLs'
	grep -ao 'https\?://[^"\']*' $argv;
end
