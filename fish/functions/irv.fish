function irv --description 'Install an R task view (group of packages, see https://cran.r-project.org/web/views/)'
  set -l views (echo $argv | sed 's/ /", "/g')
  set -l repo "http://cran.rstudio.com/"

  echo "library(\"ctv\"); install.views(c(\"$views\"), repos=\"$repo\")" | sudo R --quiet --vanilla
end
