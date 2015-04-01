function curl_ie11 --description 'Start curl with Internet Explorer 11 user agent'
	curl -H "User-Agent: Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko" $argv;
end
