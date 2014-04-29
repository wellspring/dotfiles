function extractlast -d 'Extract the file of the previous command, and delete it.'
    set filename (basename (history | head -n 1 | awk -F'[\t ]' '{print $(NF)}'))
    extract "$filename"; and rm "$filename"
end

