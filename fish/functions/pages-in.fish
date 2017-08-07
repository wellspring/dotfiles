function pages-in -d "Show the number of pages in a PDF or DJVU document."
	for file in $argv
    if test -f $file
      switch (downcase $file)
        case '*.pdf';   echo (pdfinfo "$file" | awk '/^Pages:/{print $2}') pages in $file
        case '*.djvu';  echo (djvused -e n "$file")                        pages in $file
        #case '*.epub';
        #case '*.doc';
        #case '*.docx';
        #case '*.odt';
        #http://askubuntu.com/questions/305633/how-can-i-determine-the-page-count-of-odt-doc-docx-and-other-office-documents
        case '*'
          echo -e "\e[31m   /!\ Error: unknown extension for file '$file'.\e[00m"
      end
    else
      echo -e "\e[31m/!\ Error: The file '$file' doesn't exist or is not a valid file.\e[00m"
    end
  end
end

