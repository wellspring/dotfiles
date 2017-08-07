function papers -d "List the research papers (pdf) in the current directory."
  parallel -j8 'basename {.} | sed \'s/\(.*\) (\([0-9]*\)[;,)][^)]*)$/[\2] \1./i\'' ::: **/*.pdf | sort -u
  # Note: they should be named correctly! (format: "{TITLE} ({DATE}; DOI {DOI})")
end
