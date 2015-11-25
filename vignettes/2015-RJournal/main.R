# To reproduce the manuscript PDF do the following:

# Generate tex file
#Sweave("lahti-huovari-kainu-biecek.Rnw")
#library(rmarkdown)
#render("lahti-huovari-kainu-biecek.Rmd", output_format = "pdf_document")

library(knitr)
knit("lahti-huovari-kainu-biecek.Rmd")

# Convert tex to PDF
tools::texi2pdf("RJwrapper.tex")

# Show PDF
system("evince RJwrapper.pdf")

