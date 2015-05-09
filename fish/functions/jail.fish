function jail --description 'Create a chroot folder in /apps (Usage: jail <package>)'
	set -l app (basename $argv[1])
  set -l app_bin (which $argv[1])
  set -l dir /var/tmp/apps/$app

  # Doesn't exists? Install it in a tmp directory.
  #mkdir -p /tmp/jail_$app/.db
  #fakeroot pacman -v --noconfirm --root /tmp/jail_$app/ --dbpath /tmp/jail_$app/.db/ -Sy $app
  #rm -rf /tmp/jail_$app/

  # Create directories
  echo " [+] creating directories..."; echo "$dir" | indent
  mkdir -p $dir/{bin,lib}
  ln -nfs . $dir/usr

  # Copy metadata (service & package description)
  #echo " [+] copying info & service files..."
  #cp -v /tmp/jail_$app/.db/local/$app-*/desc $dir
  #cp -v /tmp/jail_$app/usr/lib/systemd/system/$app.service $dir

  # Copy files (executable & librairies)
  echo " [+] copying the executable and libraries..."
  cpv -f $app_bin $dir/bin/$app
  for lib in (ldd $app_bin | grep -o '/[^ ]\+')
    cpv -f $lib $dir/lib/(basename $lib)
  end

end
