function apkget --description 'Download  (usage: apkget <name> [name ...])'
	for pkg in $argv
    echo " [+] Searching for '$pkg' ..."
    set -l search     (gplaycli -s $pkg | awk 'NR==2')
    set -l appname    (echo "$search" | awk -F ' {2,}' '{print $1}')
    set -l lastupdate (echo "$search" | awk -F ' {2,}' '{print $5}')
    set -l appid      (echo "$search" | awk -F ' {2,}' '{print $6}')
    set -l appversion (echo "$search" | awk -F ' {2,}' '{print $7}')
    echo "    > Downloading '$appid' ($appname v$appversion -- last release: $lastupdate) ..."
    gplaycli -p -d $appid
  end
end
