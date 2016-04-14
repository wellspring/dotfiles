function addr -d '(TMP - DO NOT USE)'
	ruby -e 'puts ('$argv[1]' + 0x8047000).to_s(16)'
end
