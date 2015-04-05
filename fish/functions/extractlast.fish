function extractlast --description 'Extract the file of the previous command, and delete it.'
	set -l filename (basename $history[1])
  extract "$filename"; and rm "$filename"
end
