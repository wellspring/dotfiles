function ir -d "Install an R package"
  set -l packages (echo $argv | sed 's/ /", "/g')
  set -l repo "http://cran.rstudio.com/"
  echo "install.packages(c(\"$packages\"), repos=\"$repo\")" | sudo R --quiet --vanilla
end
