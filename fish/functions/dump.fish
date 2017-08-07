function dump --description 'Rip a website (or folder of a website) using wget.'
	wget --recursive --level=inf --timestamping --convert-links --adjust-extension --page-requisites --no-parent --force-directories $argv;
  #equivalent of: wget -r -l inf -N -E -k -p -np -x $argv;
  #---
  #(--mirror/-m is the equivalent of -r -N -l inf --no-remove-listing)
  #(--span-hosts/-H for getting stuff other than img/css/js on other domains)
  #(--directory-prefix/-P for changing the dir in which stuff are dumped, default is '.')
  #(--ignore-case to use when using -A/-R)
  #(--accept/-A for listing stuff to keep, e.g. -A '*.pdf,*.djvu,*.epub') -- see also: --accept-regex
  #(--reject/-R for listing stuff to remove, e.g. -A '*.html')            -- see also: --reject-regex
end
