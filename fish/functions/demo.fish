function demo --description 'Run a shell using the demo user'
  # Start transparency manager & screenkey (to see key pressed)
  compton --config ~/.compton.conf &
  screenkey --opacity 0.5

  # Create a terminal (X)
	urxvt -title 'demo::tty' \
        -g 80x25 \
        -fn "xft:Anonymous Pro for Powerline:pixelsize=18,style=regular" \
        -fb "xft:Anonymous Pro for Powerline:pixelsize=18,style=Bold" \
        -e sudo -Hiu demo

  # Cleanup.
  killall compton
  killall screenkey
end
