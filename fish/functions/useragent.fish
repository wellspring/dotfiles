function useragent -d "Get an existing fake useragents, to use with curl/wget (Usage: useragent [-v|--verbose] [BROWSER] [OS])"
  # Defaults
  set -l verbose 0
  set -l browser "Chrome"
  set -l os "OS X"

  for arg in (echo $argv | downcase | tr ' ' '\n')
    switch $arg
      case -v --verbose
        set verbose 1
      case -h --help
        echo "Usage: "
        echo ' $ useragent [-v|--verbose] [BROWSER] [OS]'
        return

      # --- OPERATING SYSTEMS SUPPORT --- #
      case '*android*'
        set os Android
        set browser Android+Webkit+Browser
      case '*ios*' '*iphone*' '*ipad*'
        set os CPU
        set browser Safari

      case '*windows*'
        set os Windows
      case '*mac*' '*apple*' '*os*'
        set os OS\ X
      case '*linux*'
        set os Linux
      case '*bsd*'
        set os BSD

      # --- BROWSERS'
      case '*chrome*'
        set browser Chrome
      case '*firefox*'
        set browser Firefox
      case '*opera*'
        set browser Opera
      case '*safari*'
        set browser Safari
      case '*ie*' '*internet*' '*explorer*'
        set browser Internet+Explorer
    end
  end

  # DEBUG
  if test $verbose -eq 1
    echo    "OS ........... $os"
    echo    "Browser ...... $browser"
    echo -n "User Agent ... "
  end

  # Fire the request... :)
  wget -qO- "http://www.useragentstring.com/pages/useragentstring.php?name=$browser" | grep -o 'Mozilla/[^\'">]*'"$os"'[^<\'"]*' | head -1
end
