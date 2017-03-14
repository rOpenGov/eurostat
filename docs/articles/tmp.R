#in case you want to install rsdmx from Github
#(otherwise you can install it from CRAN)
require(devtools)
install_github("opensdmx/rsdmx")
require(rsdmx)

#read EUROSTAT dataset
dataURL <- "http://ec.europa.eu/eurostat/SDMX/diss-web/rest/data/cdh_e_fos/..PC.FOS1.BE/?startperiod=2005&endPeriod=2011 "
sdmx <- readSDMX(dataURL)
stats <- as.data.frame(sdmx)
head(stats)

