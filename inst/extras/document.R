# Package release instructions: http://r-pkgs.had.co.nz/release.html

# Documentation, Build and Check
library(devtools)
document("../../")
#build("../../")
#build(vignettes = FALSE)
# devtools::install(build_vignettes = TRUE)
#check("../../", vignettes = FALSE)
#install()

library(rmarkdown)
render(input = "../../README.Rmd", output_format = "md_document")

# build the ../../docs directory as a pkg website
library(pkgdown)
setwd("../../")
build_site()



# Submissions:
#
# release() # Submit to CRAN
# submit_cran() # Submit to CRAN without all release() questions

# Utilities:
#
# check_win_devel("../../") # Windows check
# revdep_check("../../")
# add_rstudio_project("../../")
# use_build_ignore("../NEWS.md", pkg = "../../") # NEWS.md not supported by CRAN
# use_package("dplyr") # add package to imports
# load_all(".") # Reload the package
# test() # Run tests
# run_examples()

# Vignettes:
#
# library(knitr)
# knit("../../vignettes/eurostat_tutorial.Rmd", "../../vignettes/eurostat_tutorial.md")
# or run main.R in vignettes
setwd("vignettes/")
source("main.R")
# tools::compactPDF("./", gs_quality = "ebook")



