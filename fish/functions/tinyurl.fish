function tinyurl --description 'Create a short url using tinyurl.com (similar to bit.ly)'
	set -l shorturl (curl -s "http://tinyurl.com/create.php?url=$argv" | awk -F '"' '/id="copyinfo"/ {print $4}')
  echo $shorturl | xclip -in -selection clipboard
  echo " >> generated link: $shorturl "(tput setaf 238)"(copied to the clipboard)"(tput setaf 0)
end
