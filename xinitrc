# [ Autostart ]

# -- Configure screen...
xset s off -dpms                                & # Disable screen sleep (which turn off black)

# -- Configure keyboard/mouse...
setxkbmap -option grp:switch \
          -option grp:alt_shift_toggle \
          -option keypad:pointerkeys \
          us,se,ru,fr                           & # Set keyboard layouts (and enable switching with ALT+Shift + keypad mouse)
xset r rate 200 40                              & # Set typing speed (delay and repetition rate)
unclutter                                       & # Hide the mouse when not in use

# -- Start daemons...
start-pulseaudio-x11                            & # (audio daemon)
udiskie                                         & # (auto-mount daemon, to mount usb disks/flashdrives and sdcards when inserted)
compton -b --config ~/.compton.conf             & # (composition manager, to have transparency and desktop switching effects)
xautolock -time 5 -locker lock                  & # (autolock, to lock the screen after 5 min of innactivity)
urxvtd -q -f -o                                 & # (terminal daemon, to have multiple windows but only one process)

# -- Start other programs...
start-scratchpad                                & # notes scratchpad (vim)

# -- Start the window manager...
exec ssh-agent i3

