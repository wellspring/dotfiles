function motd --description 'Display a nice Message-of-the-day. (at init, or when clearing the screen)'
  if test -e ~/.motd.conf
	  cat ~/.motd.conf
    echo
  else if test -e /etc/motd.conf
	  cat /etc/motd.conf
    echo
  else
    clear
  end

  # Redraw the prompt
  commandline -f repaint
end
