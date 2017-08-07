function testurl --description 'Download all specified urls for unit test data in ./test/ (Usage: testurl <filelist|url>)'
	mkdir -p test
  echo " [+] Dumping test urls..."
  for url in (test -e $argv[1]; and cat $argv; or echo "$argv")
    set -l filename test/(echo -n "$url" | base64 | tr -d '\n' | tr '/' '.')
    echo "   > Downloading '$url' ..."
    wget -qcO $filename $url
  end
  echo " [+] Done."
end
