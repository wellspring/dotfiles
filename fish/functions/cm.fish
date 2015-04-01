function cm
	cmake -H. -Bbuild; and cd build; and make $argv; 
end
