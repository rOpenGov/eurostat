# Package release instructions: http://r-pkgs.had.co.nz/release.html

library(devtools)
document("../../")
use_build_ignore("../NEWS.md", pkg = "../../") # NEWS.md not supported by CRAN
build("../../")
check("../../")

build_win("../../") # Windows check
#revdep_check("../../")
#release() # Submit to CRAN
# submit_cran() # Submit to CRAN without all release() questions

#add_rstudio_project("../../")

#library(knitr)
#knit("../../vignettes/eurostat_tutorial.Rmd", "../../vignettes/eurostat_tutorial.md")



