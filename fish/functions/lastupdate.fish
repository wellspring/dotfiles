function lastupdate
	awk -F '[][]' '/full system upgrade/{date=$2} END{print date}' /var/log/pacman.log
end
