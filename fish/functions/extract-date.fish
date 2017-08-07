function extract-date
	cat | tr -d '\r\n' | grep -Po '[-\'"\s](1[987]|2[01])[0-9]{2}[-\'"\s]' | tr -d '\t -\'"' | head -1
end
