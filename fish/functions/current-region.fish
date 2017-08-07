function current-region
	curl http://ip-api.com/json | jq -r .regionName
end
