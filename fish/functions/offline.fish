function offline --description 'Put all network interfaces down'
	for iface in (interfaces)
    RUN_AS_ROOT ifconfig $iface down
  end
end
