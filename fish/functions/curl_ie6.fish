function curl_ie6 --description 'Start curl with Internet Explorer 6 user agent'
	curl -H "User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)" $argv;
end
