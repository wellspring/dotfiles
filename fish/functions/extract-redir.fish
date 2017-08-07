function extract-redir --description extract\ the\ Location\ header\ \(to\ find\ on\ which\ page\ we\'re\ redirrected\ to\)
	curl -i $argv | awk '/^Location:/{print $2}'
end
