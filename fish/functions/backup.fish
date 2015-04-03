function backup --description 'Backup the specified file or folder (Usage: backup <filename>)'
	mkdir -p $HOME/Backups/
  tar jcvf "$HOME/Backups/"(basename $argv[1])"_"(date +%Y-%m-%d_%Hh%M)".tar.bz2" $argv[1]
end
