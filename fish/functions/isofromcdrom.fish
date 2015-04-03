function isofromcdrom --description 'Make an ISO from /dev/cdrom (Usage: isofromcdrom <isopath>)'
	dd if=/dev/cdrom of=$argv[1] bs=2048
end
