function current-isp
	curl http://ip-api.com/json | jq -r .isp
end
