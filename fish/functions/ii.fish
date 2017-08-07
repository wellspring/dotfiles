function ii --description Interractively\ Install\ package\ \(using\ dialog\'s\ ncurses\ checklist\ to\ choose\ which\ one\;\ Usage:\ ii\ \<searchregexp\>\)
  set -l tmp (mktemp --suffix=.lst /tmp/interractive_pacman.XXXXXXXXXX)

  # Show available packages...
  package search $argv | awk '/^aur/{if(!x){x=1;print "\"-\" \"  -----  \" off"}} /^\S/{split($1,pkg,"/");version=$2;installed=0} /\[installed\]/{installed=1} /^\s/{desc=$0;sub(/\s*/,"",desc); print "\""(installed?">> "pkg[2]" <<":pkg[2])"\" \"(v"version", in "pkg[1]") "desc"\" "(installed?"on":"off")}' | xargs dialog --separate-output --checklist "Packages to install:" (echo $LINES - 3 | bc) (echo $COLUMNS - 6 | bc) $LINES -- ^ $tmp

  # Install them...
  set -l pkgs (grep '^[^>-]' $tmp)
  if test -n "$pkgs"
    package install $pkgs
  else
    echo "Nothing to do."
  end

  #rm $tmp
end
