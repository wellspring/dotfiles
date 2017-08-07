function current-timezone --description 'timezone estimated from ip address'
	curl http://ip-api.com/json | jq -r .timezone
end
