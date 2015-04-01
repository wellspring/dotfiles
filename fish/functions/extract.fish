function extract --description 'Extract the compressed files'
	for file in $argv
    if test -f $file
      echo -e " >>> Extracting \e[34m$file\e[00m ..."
      switch $file
        case '*.tar.gz' '*.tgz';    tar xzvf $file
        case '*.tar.bz2' '*.tbz2';  tar xjvf $file
        case '*.tar.zma' '*.tlz';   tar --lzma -xvf $file
        case '*.tar.lzop';          tar --lzop -xvf $file
        case '*.tar.lz';            tar --lzip -xvf $file
        case '*.tar.xz' '*.txz';    tar xJvf $file
        case '*.tar.Z' '*.tZ';      tar xZvf $file
        case '*.tar';               tar xvf $file
        case '*.bz2';               bunzip2 $file
        case '*.gz';                gunzip $file
        case '*.lzma';              unlzma $file
        case '*.cpio';              cpio -idv < $file
        case '*.sublime-package';   unzip $file
        case '*.jar' '*.war';       unzip $file
        case '*.apk' '*.APK';       unzip $file
        case '*.zip' '*.ZIP';       unzip $file
        case '*.rar' '*.RAR';       unrar x $file
        case '*.ace' '*.ACE';       unace x $file
        case '*.deb';               ar -x $file
        case '*.Z';                 uncompress $file
        case '*.7z';                7z x $file
        case '*.pax';               pax -r < $file
        case '*'
          echo -e '\e[31m   /!\ Error: unknown extension.\e[00m'
      end
    else
      echo -e "\e[31m/!\ Error: The file '$file' doesn't exist or is not a valid file.\e[00m"
    end
  end
end
