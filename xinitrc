# [ Autostart ]

# -- Configure screen...
xset s off -dpms                                & # Disable screen sleep (which turn off black)

# -- Configure keyboard/mouse... (no -option terminate:ctrl_alt_bksp)
setxkbmap -option grp:switch \
          -option grp:alt_shift_toggle \
          -option shift:breaks_caps \
          -option keypad:pointerkeys \
          -option compose:menu \
          us,se,ru,fr                           & # Set keyboard layouts (switch with ALT+Shift, tmp switch by holding RIGHT_ALTGR, enable keypad mouse)
xset r rate 200 40                              & # Set typing speed (delay and repetition rate)
#xset m 2 0                                     & # Set the mouse speed and acceleration.
#syndaemon -t -k -i 1                           & # Disable touchpad for up to 1sec when typing.
unclutter -idle 5                               & # Hide the mouse when idle after 5 seconds

# -- Configure other stuff...
xset -b                                         & # Disable the bell
autocutsel -fork                                & # Unify clipboards (selection and ctrl+c) in the cutbuffer
autocutsel -selection PRIMARY -fork             & # Unify clipboards (selection and ctrl+c) in the cutbuffer

# -- Start daemons...
start-pulseaudio-x11                            & # (audio daemon)
eval $(ssh-agent -s -t 60)                        # (ssh agent, to not have to retype passphrase more than once per minute)
eval $(gpg-agent -s --daemon)                     # (gpg agent, same but for gpg)
#eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)
udiskie                                         & # (auto-mount daemon, to mount usb disks/flashdrives and sdcards when inserted)
compton -b --config ~/.compton.conf             & # (composition manager, to have transparency and desktop switching effects)
xautolock -time 5 -locker lock                  & # (autolock, to lock the screen after 5 min of innactivity)
urxvtd -q -f -o                                 & # (terminal daemon, to have multiple windows but only one process)

# -- Start other programs...
start-scratchpad                                & # notes scratchpad (vim)

# -- Start the window manager... (in a loop, to restart automatically in case of a crash)
while true; do
  xrdb ~/.Xdefaults
  i3
done

