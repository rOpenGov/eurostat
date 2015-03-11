---
output:
  html_document:
    theme: united
---
<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->


Eurostat R tools
===========

This R package provides tools to access [Eurostat open
data](http://ec.europa.eu/eurostat/portal/page/portal/statistics/themes)
as part of the [rOpenGov](http://ropengov.github.io) project.

For contact information and source code, see the [github page](https://github.com/rOpenGov/eurostat)

## Installation

Release version:


```r
install.packages("eurostat")
```

Development version:


```r
library(devtools)
install_github("ropengov/eurostat")
```

## Finding the data

Function `getEurostatTOC` downloads a table of contents of eurostat datasets. Note that the values in column 'code' should be used to download a selected dataset.


```r
library(eurostat)

# Get Eurostat data listing
toc <- getEurostatTOC()
toc[200:210,]
```

```
##                                                                                                   title
## 200                                   Population by sex, age group, household status and NUTS 3 regions
## 201                                  Population by sex, age group, size of household and NUTS 3 regions
## 202                                          Private households by composition, size and NUTS 3 regions
## 203                         Private households by composition, age group of children and NUTS 3 regions
## 204                                                                                           Dwellings
## 205                                           Dwellings by type of housing, building and NUTS 3 regions
## 206                                                    Dwellings by type of building and NUTS 3 regions
## 207                                                                  Regional economic accounts - ESA95
## 208                                                           Gross domestic product indicators - ESA95
## 209                             Gross domestic product (GDP) at current market prices by NUTS 2 regions
## 210                             Gross domestic product (GDP) at current market prices by NUTS 3 regions
##               code    type last.update.of.data last.table.structure.change
## 200  cens_01rhtype dataset          26.03.2009                  14.01.2014
## 201  cens_01rhsize dataset          09.02.2011                  14.01.2014
## 202   cens_01rheco dataset          26.03.2009                  14.01.2014
## 203 cens_01rhagchi dataset          26.03.2009                  05.11.2014
## 204    cens_01rdws  folder                                                
## 205    cens_01rdhh dataset          10.09.2009                  14.01.2014
## 206 cens_01rdbuild dataset          26.03.2009                  14.01.2014
## 207        reg_eco  folder                                                
## 208     reg_ecogdp  folder                                                
## 209   nama_r_e2gdp dataset          03.03.2014                  03.03.2014
## 210   nama_r_e3gdp dataset          28.02.2014                  28.02.2014
##     data.start data.end values
## 200       2001     2001     NA
## 201       2001     2001     NA
## 202       2001     2001     NA
## 203       2001     2001     NA
## 204                         NA
## 205       2001     2001     NA
## 206       2001     2001     NA
## 207                         NA
## 208                         NA
## 209       2000     2011     NA
## 210       2000     2011     NA
```

With `grepEurostatTOC` you can search through the table of content for particular patterns, e.g. all datasets related to *passenger transport*.


```r
# info about passengers
head(grepEurostatTOC("passenger transport", type = "dataset"))
```

```
##                                                                                                                                         title
## 5164                                                                                            Volume of passenger transport relative to GDP
## 5165                                                                                                       Modal split of passenger transport
## 5204                                                          Railway transport - Total annual passenger transport (1 000 pass., million pkm)
## 5208                 International railway passenger transport from the reporting country to the country of disembarkation (1 000 passengers)
## 5209                    International railway passenger transport from the country of embarkation to the reporting country (1 000 passengers)
## 5560                                                                                             Air passenger transport by reporting country
##                 code    type last.update.of.data
## 5164   tran_hv_pstra dataset          25.06.2014
## 5165   tran_hv_psmod dataset          25.06.2014
## 5204   rail_pa_total dataset          10.03.2015
## 5208 rail_pa_intgong dataset          03.03.2015
## 5209 rail_pa_intcmng dataset          03.03.2015
## 5560       avia_paoc dataset          10.02.2015
##      last.table.structure.change data.start data.end values
## 5164                  25.06.2014       1995     2012     NA
## 5165                  25.06.2014       1990     2012     NA
## 5204                  10.07.2014       2004     2013     NA
## 5208                  26.02.2015       2002     2013     NA
## 5209                  26.02.2015       2002     2013     NA
## 5560                  10.02.2015       1993   2014Q4     NA
```

```r
head(grepEurostatTOC("passenger transport", type = "table"))
```

```
##                                                              title
## 7353                 Volume of passenger transport relative to GDP
## 7354                            Modal split of passenger transport
## 7848                            Modal split of passenger transport
## 7972                            Modal split of passenger transport
## 7975                 Volume of passenger transport relative to GDP
##          code  type last.update.of.data last.table.structure.change
## 7353 tsdtr240 table          04.03.2015                  04.03.2015
## 7354 tsdtr210 table          04.03.2015                  04.03.2015
## 7848 tsdtr210 table          04.03.2015                  04.03.2015
## 7972 tsdtr210 table          04.03.2015                  04.03.2015
## 7975 tsdtr240 table          04.03.2015                  04.03.2015
##      data.start data.end values
## 7353       1995     2012     NA
## 7354       1990     2012     NA
## 7848       1990     2012     NA
## 7972       1990     2012     NA
## 7975       1995     2012     NA
```



## Downloading the data 

Package has two functions for downloading the data. When using `get_eurostat_raw` the data is transformed into the tabular format, whereas `get_eurostat` returns dataset transformed into the molten / row-column-value format (RCV). Let's focus on indicator ([Modal split of passenger transport](http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&language=en&pcode=tsdtr210)) in this document. 

>This indicator is defined as the percentage share of each mode of transport in total inland transport, expressed in passenger-kilometres (pkm). It is based on transport by passenger cars, buses and coaches, and trains. All data should be based on movements on national territory, regardless of the nationality of the vehicle. However, the data collection methodology is not harmonised at the EU level. 




```r
# Pick ID for the table
id <- unique(grepEurostatTOC("Modal split of passenger transport", 
        	             type = "table")$code)
# Get table with the given ID
dat_raw <- get_eurostat_raw(id)
# lets use kable function from knitr for nicer table outputs
library(knitr)
kable(head(dat_raw))
```



|vehicle.geo.time |X1990 |X1991  |X1992  |X1993  |X1994  |X1995  |X1996  |X1997  |X1998  |X1999  |X2000  |X2001  |X2002  |X2003  |X2004  |X2005  |X2006  |X2007  |X2008  |X2009  |X2010  |X2011  |X2012  |
|:----------------|:-----|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|:------|
|BUS_TOT,AT       |NA    |10.6   |10.5   |10.7   |10.6   |10.9   |10.7   |10.9   |10.9   |10.7   |11     |10.9   |10.9   |10.9   |11     |10.5   |10.4   |10.8   |10.2   |9.6    |10.3   |10.1   |10     |
|BUS_TOT,BE       |NA    |10.1 e |10.3 e |10.3 e |10.4 e |11.2   |11.2 e |11.1   |11.1   |10.7 e |10.5   |10.7   |11.4   |12.5   |12.7   |13     |13.2   |13.4   |12.5   |12.5   |12.2   |12.3   |12.4   |
|BUS_TOT,BG       |NA    |NA     |NA     |NA     |NA     |28.0 e |26.3 e |28.5 e |30.3 e |33.5 e |31.4 b |32     |33.4   |28.1   |25     |24.3   |22.7   |21.8   |20.8   |16.8   |16.4   |15.9   |16.9   |
|BUS_TOT,CH       |NA    |NA     |NA     |NA     |NA     |NA     |NA     |NA     |NA     |NA     |5.2    |5.2    |5.1    |5.2    |5.2    |5.3    |5.6    |5.5    |5.1    |5.1    |5.1    |5.1    |5.1    |
|BUS_TOT,CY       |NA    |NA     |NA     |NA     |NA     |NA     |NA     |NA     |NA     |NA     |22.3 e |22.5 e |22.6 e |23.6 e |21.2 e |20.8 e |20.4 e |19.7 e |18.8 e |17.6 e |18.1 e |18.3 e |18.7 e |
|BUS_TOT,CZ       |NA    |NA     |NA     |19.1 e |17.0 e |15.8 e |20.1 e |19.0 e |18.5 e |18.2 e |18.6   |19.9   |18.7   |17.2   |16     |17.2   |17.3   |17     |16.9   |16     |18.9   |17     |16.8   |



```r
dat <- get_eurostat(id)
kable(head(dat))
```



|vehicle |geo |time       | value|
|:-------|:---|:----------|-----:|
|BUS_TOT |AT  |1990-01-01 |    NA|
|BUS_TOT |BE  |1990-01-01 |    NA|
|BUS_TOT |BG  |1990-01-01 |    NA|
|BUS_TOT |CH  |1990-01-01 |    NA|
|BUS_TOT |CY  |1990-01-01 |    NA|
|BUS_TOT |CZ  |1990-01-01 |    NA|


### Labelling the data

Function `label_eurostat`  replaces the eurostat codes with definitions from Eurostat dictionaries for data frames created using `get_eurostat`-function.


```r
datl <- label_eurostat(dat)

kable(head(datl))
```



|vehicle                                |geo            |time       | value|
|:--------------------------------------|:--------------|:----------|-----:|
|Motor coaches, buses and trolley buses |Austria        |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Belgium        |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Bulgaria       |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Switzerland    |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Cyprus         |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Czech Republic |1990-01-01 |    NA|


## Triangle plot for split of passenger transport


```r
library(reshape)
tmp <- get_eurostat("tsdtr210")
bus  <- cast(tmp, geo ~ time , mean, subset= vehicle=="BUS_TOT")
car <- cast(tmp, geo ~ time , mean, subset= vehicle=="CAR")
train   <- cast(tmp, geo ~ time , mean, subset= vehicle=="TRN")

# select 2010 data
allTransports <- data.frame(bus = bus[,"2010"], 
                            car = car[,"2010"],
                            train = train[,"2010"])
```

```
## Error in `[.data.frame`(bus, , "2010"): undefined columns selected
```

```r
# add countrynames
rownames(allTransports) <- levels(bus[,1])
```

```
## Error in rownames(allTransports) <- levels(bus[, 1]): object 'allTransports' not found
```

```r
allTransports <- na.omit(allTransports)
```

```
## Error in na.omit(allTransports): object 'allTransports' not found
```

```r
# triangle plot
library("plotrix")
triax.plot(allTransports, show.grid=TRUE, 
           label.points=TRUE, point.labels=rownames(allTransports), 
           pch=19)
```

```
## Error in is.data.frame(x): object 'allTransports' not found
```


## Working with country codes

Eurostat is using ISO2 format for country names, OECD is using ISO3 for their studies, and Statistics Finland uses full country names. There are (at least) two ways to solve the issue. First one is to apply `label_eurostat`-function to your dataset.


```r
tmp <- get_eurostat("tsdtr210")
tmpl <- label_eurostat(tmp)

kable(head(tmpl))
```



|vehicle                                |geo            |time       | value|
|:--------------------------------------|:--------------|:----------|-----:|
|Motor coaches, buses and trolley buses |Austria        |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Belgium        |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Bulgaria       |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Switzerland    |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Cyprus         |1990-01-01 |    NA|
|Motor coaches, buses and trolley buses |Czech Republic |1990-01-01 |    NA|

A second option is to use [countrycode](http://cran.r-project.org/web/packages/countrycode/index.html) package can be used to convert between these formats.


```r
library("countrycode")

# Use the country codes from previous examples
countries <- rownames(allTransports)
```

```
## Error in rownames(allTransports): object 'allTransports' not found
```

```r
head(countries)
```

```
## Error in head(countries): object 'countries' not found
```

```r
# From ISO2 (used by Eurostat) into ISO3 (used by OECD)
head(countrycode(countries, "iso2c", "iso3c"))
```

```
## Error in countrycode(countries, "iso2c", "iso3c"): object 'countries' not found
```

```r
# From ISO2 (used by Eurostat) into ISO (short country names)
head(countrycode(rownames(allTransports), "iso2c", "country.name"))
```

```
## Error in rownames(allTransports): object 'allTransports' not found
```

## Citing the package

This R package is based on earlier CRAN packages [statfi](http://cran.r-project.org/web/packages/statfi/index.html) and [smarterpoland](http://cran.r-project.org/web/packages/SmarterPoland/index.html). The [datamart](http://cran.r-project.org/web/packages/datamart/index.html) package contains related tools for Eurostat but at the time of writing this tutorial this package seems to be in an experimental stage.

**Citing the Data** Kindly cite [Eurostat](http://ec.europa.eu/eurostat/portal/page/portal/statistics/search_database). 


**Citing the R tools** This work can be freely used, modified and
distributed under the [BSD-2-clause (modified FreeBSD)
license]. Kindly cite the R package as 'Leo Lahti, Przemyslaw Biecek, Janne Huovari and Markus Kainu (C) 2014. eurostat R package. URL: http://ropengov.github.io/eurostat'.


## Session info

This tutorial was created with


```r
sessionInfo()
```

```
## R version 3.1.2 (2014-10-31)
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
## [1] countrycode_0.18 plotrix_3.5-11   reshape_0.8.5    eurostat_0.9.36 
## [5] tidyr_0.2.0.9000 plyr_1.8.1       knitr_1.9       
## 
## loaded via a namespace (and not attached):
## [1] evaluate_0.5.5 formatR_1.0    Rcpp_0.11.4    reshape2_1.4.1
## [5] stringi_0.4-1  stringr_0.6.2  tools_3.1.2
```
