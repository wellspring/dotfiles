function compress --description 'Compress files (create an archive)'
	if test (count $argv) -lt 2
    echo "Usage: compress <archive.ext> <file1> [file2] [file3] ..."
  else
    echo -e " >>> Compressing \e[34m$argv[1]\e[00m ..."
    switch $argv[1]
      case '*.tar.gz' '*.tgz';    tar czvf $argv
      case '*.tar.bz2' '*.tbz2';  tar cjvf $argv
      case '*.tar.zma' '*.tlz';   tar --lzma -cvf $argv
      case '*.tar.lzop';          tar --lzop -cvf $argv
      case '*.tar.lz';            tar --lzip -cvf $argv
      case '*.tar.xz' '*.txz';    tar cJvf $argv
      case '*.tar.Z' '*.tZ';      tar cZvf $argv
      case '*.tar';               tar cvf $argv
      case '*.bz2';               bzip2 $argv
      case '*.gz';                gzip $argv
      case '*.lzma';              lzma $argv
      case '*.cpio';              echo $argv[2..-1] | cpio -oav > $argv[1]
      case '*.sublime-package';   zip $argv
      case '*.jar' '*.war';       zip $argv
      case '*.apk' '*.APK';       zip $argv
      case '*.zip' '*.ZIP';       zip $argv
      case '*.rar' '*.RAR';       rar a -r -m5 $argv
      case '*.deb';               ar r $argv
      case '*.Z';                 compress $argv
      case '*.7z';                7z a $argv
      case '*'
        echo -e '\e[31m   /!\ Error: unknown extension.\e[00m'
    end
  end
end
