function :tr -d "Translate to swedish,russian,french"
  echo "en: $argv"
  for lang in sv ru fr
    echo -n "$lang: "; translate-shell -b en:$lang "$argv"
  end
end
