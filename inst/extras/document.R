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
#library(pkgdown)
#setwd("../../")
#build_site()
# devtools::build_vignettes()


# Submissions:
#
# release() # Submit to CRAN
# devtools::check_win_devel("../../") # Windows check
# submit_cran() # Submit to CRAN without all release() questions
# use_cran_comments()

# Utilities:
#
# revdep_check("../../")
# add_rstudio_project("../../")
# use_build_ignore("../NEWS.md", pkg = "../../") # NEWS.md not supported by CRAN
# use_package("dplyr") # add package to imports
# load_all(".") # Reload the package
# test() # Run tests
# run_examples()

# Add Github actions (Travis replacement)
#usethis::use_github_action_check_standard()
# -> .github/workflows/..
# See https://github.com/r-lib/actions

# Vignettes:
#
# library(knitr)
# knit("../../vignettes/eurostat_tutorial.Rmd", "../../vignettes/eurostat_tutorial.md")
# or run main.R in vignettes
#setwd("vignettes/")
#source("main.R")
# system("cp vignette.html ../inst/doc/")
# tools::compactPDF("./", gs_quality = "ebook")



