<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->

Eurostat R tools
===========

This R package provides tools to access open data from [Eurostat](http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/themes). 

This R package is part of the [rOpenGov](http://ropengov.github.io)
project.


## Installation

Release version for general use:


```r
install.packages("eurostat")
library(eurostat)
```


Development version (potentially unstable):


```r
install.packages("devtools")
library(devtools)
install_github("eurostat", "ropengov")
library(eurostat)
```



## Accessing Eurostat data from Eurostat database


```r
library(eurostat)

# info about passagers
grepEurostatTOC("split of passenger transport")
```

```
##                                                   title          code
## 4829                 Modal split of passenger transport tran_hv_psmod
##         type last.update.of.data last.table.structure.change data.start
## 4829 dataset          04.09.2013                  03.09.2013       1990
##      data.end values
## 4829     2011     NA
```

```r

## get table
tmp <- getEurostatRCV("tsdtr210")
summary(tmp)
```

```
##     vehicle         geo            time          value     
##  BUS_TOT:748   AT     :  66   1990   : 102   Min.   : 0.0  
##  CAR    :748   BE     :  66   1991   : 102   1st Qu.: 6.8  
##  TRN    :748   BG     :  66   1992   : 102   Median :13.0  
##                CH     :  66   1993   : 102   Mean   :33.6  
##                CY     :  66   1994   : 102   3rd Qu.:77.3  
##                CZ     :  66   1995   : 102   Max.   :93.4  
##                (Other):1848   (Other):1632   NA's   :363
```



## Triangle plot for split of passenger transport


```r
if (!require(plotrix)) {
    install.packages("plotrix")
    library("plotrix")
}


tmp <- getEurostatRCV("tsdtr210")

library(reshape)
bus <- cast(tmp, geo ~ time, mean, subset = vehicle == "BUS_TOT")
car <- cast(tmp, geo ~ time, mean, subset = vehicle == "CAR")
train <- cast(tmp, geo ~ time, mean, subset = vehicle == "TRN")

# select the 2010 data
allTransports <- data.frame(bus = bus[, "2010 "], car = car[, "2010 "], train = train[, 
    "2010 "])
# add countrynames
rownames(allTransports) <- levels(bus[, 1])
allTransports <- na.omit(allTransports)

# triangle plot
triax.plot(allTransports, show.grid = TRUE, label.points = TRUE, point.labels = rownames(allTransports), 
    pch = 19)
```

![plot of chunk plotGallery](figure/plotGallery.png) 



## Working with various country code standards

Eurostat is using ISO2 format for country names, OECD is using ISO3 for their studies, and Statistics Finland uses full country names. The [countrycode](http://cran.r-project.org/web/packages/countrycode/index.html) package can be used to convert between these formats.


```r
if (!require(countrycode)) {
    install.packages("countrycode")
    library("countrycode")
}

# Use the country codes from previous examples
countries <- rownames(allTransports)
head(countries)
```

```
## [1] "AT" "BE" "BG" "CH" "CZ" "DE"
```

```r

# From ISO2 (used by Eurostat) into ISO3 (used by OECD)
head(countrycode(countries, "iso2c", "iso3c"))
```

```
## [1] "AUT" "BEL" "BGR" "CHE" "CZE" "DEU"
```

```r

# From ISO2 (used by Eurostat) into ISO (short country names)
head(countrycode(rownames(allTransports), "iso2c", "country.name"))
```

```
## [1] "AUSTRIA"        "BELGIUM"        "BULGARIA"       "SWITZERLAND"   
## [5] "CZECH REPUBLIC" "GERMANY"
```


## Accessing Eurostat data via Statistics Finland data portal

Eurostat data is also available through the [Statistics
Finland](http://www.stat.fi/tup/tilastotietokannat/index_fi.html) data
portal, where the listings of
[Eurostat](http://www.stat.fi/org/lainsaadanto/avoin_data.html) data
sets are available for browsing in
[PCAxis](http://pxweb2.stat.fi/Database/Eurostat/databasetree_fi.asp)
and [CSV](http://pxweb2.stat.fi/database/Eurostatn/Eurostatn_rap.csv)
formats. You can retrieve Eurostat data from Statfi by defining the
URL of the selected data set:


```r
# Define URL (browse the statfi site for URL listing; see above)
url <- "http://pxweb2.stat.fi/Database/Eurostat/ymp/t2020_30.px"

# Download the data
df <- get_eurostat(url)

# Inspect the first entries..
df[1:3, ]
```

```
##   time     geo   dat
## 1 1990 Austria 100.0
## 2 1991 Austria 105.2
## 3 1992 Austria  96.8
```



## Related tools

This R package is based on two earlier CRAN packages: [statfi](http://cran.r-project.org/web/packages/statfi/index.html) and [smarterpoland](http://cran.r-project.org/web/packages/SmarterPoland/index.html). The [datamart](http://cran.r-project.org/web/packages/datamart/index.html) package contains additional related tools for Eurostat data but at the time of writing this tutorial this package seems to be in an experimental stage.


## Licensing and Citations

### Citing the Data

Regarding the data, kindly cite [Eurostat](http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database). 


### Citing the R tools

This work can be freely used, modified and distributed under the
[GPL-3 license](https://www.gnu.org/copyleft/gpl.html). Kindly cite
the R package as 'Leo Lahti and Przemyslaw Biecek (C) 2014. eurostat R
package. URL: http://ropengov.github.io/eurostat'.


### Session info

This tutorial was created with


```r
sessionInfo()
```

```
## R version 3.0.2 (2013-09-25)
## Platform: x86_64-pc-linux-gnu (64-bit)
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] countrycode_0.16 plotrix_3.5-5    knitr_1.5        eurostat_0.9.3  
## [5] statfi_0.9.06    pxR_0.29         stringr_0.6.2    reshape_0.8.5   
## [9] devtools_1.5    
## 
## loaded via a namespace (and not attached):
##  [1] brew_1.0-6      codetools_0.2-8 digest_0.6.4    evaluate_0.5.3 
##  [5] formatR_0.10    httr_0.3        memoise_0.2.1   parallel_3.0.2 
##  [9] plyr_1.8.1      Rcpp_0.11.1     RCurl_1.95-4.1  roxygen2_3.1.0 
## [13] tools_3.0.2     whisker_0.4
```

