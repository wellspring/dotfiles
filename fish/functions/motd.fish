function motd --description 'Display a nice Message-of-the-day. (at init, or when clearing the screen)'
	set -l MOTD_FILENAME "motd.conf"
  if test $COLUMNS -lt 100
    set MOTD_FILENAME "motd-short.conf"
  end

	if test -e ~/.$MOTD_FILENAME
	  cat ~/.$MOTD_FILENAME
    echo
  else if test -e /etc/$MOTD_FILENAME
	  cat /etc/$MOTD_FILENAME
    echo
  else
    clear
  end

  # Redraw the prompt
  commandline -f repaint
end
