function bitly --description 'Create shorten urls via bit.ly service'
	set -l login spirius
  set -l apikey R_d200bcf0a0ed464096b6206e7dc1f42d

  set -l shorturl (curl -s --data "login=$login&apiKey=$apikey&format=txt&longUrl=$argv" http://api.bitly.com/v3/shorten)
  echo $shorturl | xclip -in -selection clipboard

  echo " >> generated link: $shorturl "(tput setaf 238)"(copied to the clipboard)"(tput setaf 0)
end
