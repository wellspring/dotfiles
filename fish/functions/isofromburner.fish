function isofromburner --description 'Make an ISO from /dev/burner (Usage: isofromburner <isopath>)'
	dd if=/dev/burner of=$argv[1] bs=2048
end
