function p --description 'mplayer (with remote control)'
	set -l sock /tmp/mplayer-ctrl.sock
  rm -f $sock
  mkfifo $sock
	mplayer -really-quiet -input file=$sock -subcp utf8 $argv
  #echo pause > $sock
end
