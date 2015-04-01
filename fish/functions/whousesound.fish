function whousesound
	fuser -v /dev/snd/* /dev/dsp* $argv; 
end
