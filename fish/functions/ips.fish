function ips --description 'list ip addresses (with interfaces, mac addr, and ipv4/ipv6)'
	ip addr show up | awk '/^[0-9]/{iface=$2} /link\/ether/{net[iface]["mac"]=$2} /inet /{net[iface]["ip"]=$2} /inet6 /{net[iface]["ipv6"]=$2} END{for(iface in net) print iface" ("net[iface]["mac"]") -> ",net[iface]["ip"],net[iface]["ipv6"]}' | sed 's/://;s/\/[0-9]\+//g' | column -t
end
