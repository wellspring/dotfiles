function screenshot
	which archey3; and clear; and archey3
  scrot -e "echo Saved to: \$f" -c -d 3 $argv
  xnotify -l '[screenshot taken]' >/dev/null
end
