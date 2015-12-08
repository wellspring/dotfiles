function update-pentadactryl
	wget http://5digits.org/nightly/pentadactyl-latest.xpi
  unzip pentadactyl-latest.xpi install.rdf
  sed -i 's/\(em:maxVersion\)="[^"]*"/\1="42.*"/' install.rdf
  zip -u pentadactyl-latest.xpi install.rdf
  rm install.rdf
  mv pentadactyl-latest{,.patched}.xpi
end
