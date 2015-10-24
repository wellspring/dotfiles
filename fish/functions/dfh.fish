function dfh
	df -lPH -x tmpfs -x devtmpfs $argv;
end
