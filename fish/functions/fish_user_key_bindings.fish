function fish_user_key_bindings -d "My keybindings :)"
  # [CTRL+L] Display a nice motd while clearing the console
  bind \cl motd

  # [CTRL+C] Cancel the current command (comment the line instead of removing it)
  bind \cc 'commandline "#"(commandline -b); commandline -f execute'

  # [CTRL+V] Paste text that has been copied with CTRL+C.
  # [ALT+V] Paste text that has been copied with x11's selection.
  # [CTRL+Y] Copy the text to the yank list (push on the stack)
  # [CTRL+P] Paste the text from the yank list (pop the stack)
  bind \cv clipboard-paste
  bind \ev clipboard-paste2
  bind \cy yank
  bind \cp yank-pop

  # [ALT+R] Run the current command as root (using sudo or su -c)
  # [ALT+B] Run the current command in background
  # [ALT+S] Run the current command silently, without any output.
  bind \er 'commandline "RUN_AS_ROOT "(commandline -b); commandline -f repaint; commandline -f execute'
  bind \eb 'commandline (commandline -b)" &"; commandline -f repaint; commandline -f execute'
  bind \es 'commandline (commandline -b)" >/dev/null 2>/dev/null"; commandline -f repaint; commandline -f execute'

  # [ALT+D] File explorer
  bind \ed 'ranger-cd; commandline -f repaint'
end
fzf_key_bindings
