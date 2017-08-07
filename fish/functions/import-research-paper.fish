function import-research-paper --description 'Import Research paper article (Usage: ir <file.pdf>)'
	set -l filename $argv

  set -l TMP   (mktemp); pdftotext -htmlmeta "$filename" - > $TMP
  set -l title (cat $TMP | extract-title)
  set -l date  (cat $TMP | extract-date)
  set -l doi   (cat $TMP | extract-doi | tr '/' '@')
  test -n "$doi"; or set -l doi (find-doi $title | tr '/' '@')
  rm $TMP

  mv $filename "$title ($date; DOI $doi).pdf"
end
