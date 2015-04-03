function slow_print --description 'Print a text slowly (useless but geeky ;p)'
	for c in (echo "$argv" | grep -o .)
    echo -n "$c"
    sleep 0.08
  end
  echo
end
