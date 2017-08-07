function extract-references --description 'Extract the references from a research paper...'
	pdftotext -layout -nopgbrk $argv - | awk '/REFERENCES/,0' | sed 's/^.\{,70\}//;' | sed '/^\s*$/d' | perl -00pe 's/(:\/\/[^ ]+)\n\s+/\1/g; s/\n\s+/ /g; s/\s*Accessed \S+ \d+, \d+\.?//g;'
  #TOFIX: sed 's/^.\{,70\}//;'
end
