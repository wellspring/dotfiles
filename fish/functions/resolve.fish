function resolve --description 'Return all IP Adresses associated with a hostname (using nmap)'
	
   sudo nmap -Pn -sL -R $argv | grep --color=never -E -o -e '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' -e 'scan report for (\S+)' | sed 's/scan report for \(.*\)/\x1b[41m[\1]\x1b[00m/'
end
