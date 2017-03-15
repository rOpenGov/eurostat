# To reproduce the manuscript PDF do the following:

#if (Sys.info()[["user"]]) setwd("~/btsync/mk/workspace/ropengov/eurostat/vignettes/2017_RJournal_manuscript")

# Generate the examples, figures and tables
#library(knitr)
#knit("lahti-huovari-kainu-biecek.Rmd")

library(rmarkdown)
render("lahti-huovari-kainu-biecek.Rmd")

# Convert tex to PDF
tools::texi2pdf("RJwrapper.tex")
tools::texi2pdf("RJwrapper.tex")

# Show PDF
system("evince RJwrapper.pdf &")




# OLD: Generate tex file
#Sweave("lahti-huovari-kainu-biecek.Rnw")
#library(rmarkdown)
#render("lahti-huovari-kainu-biecek.Rmd", output_format = "pdf_document")

