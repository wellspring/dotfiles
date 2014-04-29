# Aliases
alias md='mkdir'
alias rd='rmdir'
alias cx='chmod +x'
alias grepr='.grep'
alias ps='ps auxwwf' #'f' not working on OS-X
alias h20='head -n 20'
alias t20='tail -n 20'
alias tmsg='tail -f /var/log/messages'
alias hex='od -t x1'

# Small functions for dev
function rfc -d 'Display the specified RFC'; eval $EDITOR /disk/doc/rfc/rfc$argv[1].txt; end
function cprfc -d 'Copy a specified RFC to a file or directory'; cp /disk/doc/rfc/rfc$argv[1].txt $argv[2]; end
function grfc -d 'Search for RFC by title (using a pre-generated file)'; grep --color=always -i "$argv" /disk/doc/rfc/index.lst; end
function gorfc -d 'Search for only obsoleted RFC by title (using a pre-generated file)'; grfc $argv | grep -e 'Obsoleted[^)]\+'; end
function js -d 'Download a javascript library by name (require jq+wget+xargs)'; wget -qO- "http://api.cdnjs.com/libraries?search=$argv" | jq ".results[] | select(.name == \"$argv\") | .latest" | xargs wget; end
function jss -d 'Search for a javascript library by name (require jq+moreutils+wget+sed)'; echo -e "Searching for javascript libraries named '$argv'..."; wget -qO- "http://api.cdnjs.com/libraries?search=$argv&fields=version,description" | jq '.results[] | "> "+.name+" ("+.version+"):"+.description' | sed -e 's/^"\(.*\)"$/\1\x1b[00m/;s/ / \x1b[0;31m/;s/(/\x1b[00m(\x1b[33m/;s/): /\x1b[00m&/' | ifne -n echo "Nothing found."; end

