---
title: "Tutorial (vignette) for the eurostat R package"
date: "2017-08-09"
output: 
  rmarkdown::html_vignette:
    toc: true
vignette: >
  %\VignetteIndexEntry{eurostat tutorial}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteDepends{Cairo}
  %\VignetteEncoding{UTF-8}
  \usepackage[utf8]{inputenc}
---

# R Tools for Eurostat Open Data

This [rOpenGov](http://ropengov.github.io) R package provides tools to access [Eurostat database](http://ec.europa.eu/eurostat/data/database), which you can also browse on-line for the data sets and documentation. For contact information and source code, see the [package website](http://ropengov.github.io/eurostat/).




# Installation

Release version [(CRAN)](https://cran.r-project.org/web/packages/eurostat/index.html):


```r
install.packages("eurostat")
```

Development version [(Github)](https://github.com/rOpenGov/eurostat):


```r
library(devtools)
install_github("ropengov/eurostat")
```




Overall, the eurostat package includes the following functions:


```
clean_eurostat_cache    Clean Eurostat Cache
cut_to_classes          Cuts the Values Column into Classes and
                        Polishes the Labels
dic_order               Order of Variable Levels from Eurostat
                        Dictionary.
eu_countries            Countries and Country Codes
eurostat-package        R Tools for Eurostat open data
eurotime2date           Date Conversion from Eurostat Time Format
eurotime2num            Conversion of Eurostat Time Format to Numeric
get_eurostat            Read Eurostat Data
get_eurostat_dic        Download Eurostat Dictionary
get_eurostat_geospatial
                        Download Geospatial Data from CISGO
get_eurostat_json       Get Data from Eurostat API in JSON
get_eurostat_raw        Download Data from Eurostat Database
get_eurostat_toc        Download Table of Contents of Eurostat Data
                        Sets
harmonize_country_code
                        Harmonize Country Code
label_eurostat          Get Eurostat Codes
merge_eurostat_geodata
                        Merge Preprocessed Geospatial Data from CISGO
                        with data_frame from Eurostat
search_eurostat         Grep Datasets Titles from Eurostat
tgs00026                Auxiliary Data
```


# Finding data

Function `get_eurostat_toc()` downloads a table of contents of eurostat datasets. The values in column 'code' should be used to download a selected dataset.


```r
# Load the package
library(eurostat)
library(rvest)

# Get Eurostat data listing
toc <- get_eurostat_toc()

# Check the first items
library(knitr)
kable(head(toc))
```



|title                                                    |code      |type    |last update of data |last table structure change |data start |data end |values |
|:--------------------------------------------------------|:---------|:-------|:-------------------|:---------------------------|:----------|:--------|:------|
|Database by themes                                       |data      |folder  |NA                  |NA                          |NA         |NA       |NA     |
|General and regional statistics                          |general   |folder  |NA                  |NA                          |NA         |NA       |NA     |
|European and national indicators for short-term analysis |euroind   |folder  |NA                  |NA                          |NA         |NA       |NA     |
|Business and consumer surveys (source: DG ECFIN)         |ei_bcs    |folder  |NA                  |NA                          |NA         |NA       |NA     |
|Consumer surveys (source: DG ECFIN)                      |ei_bcs_cs |folder  |NA                  |NA                          |NA         |NA       |NA     |
|Consumers - monthly data                                 |ei_bsco_m |dataset |28.07.2017          |28.07.2017                  |1980M01    |2017M07  |NA     |

With `search_eurostat()` you can search the table of contents for particular patterns, e.g. all datasets related to *passenger transport*. The kable function to produces nice markdown output. Note that with the `type` argument of this function you could restrict the search to for instance datasets or tables.


```r
# info about passengers
kable(head(search_eurostat("passenger transport")))
```



|title                                                                                                                    |code            |type    |last update of data |last table structure change |data start |data end |values |
|:------------------------------------------------------------------------------------------------------------------------|:---------------|:-------|:-------------------|:---------------------------|:----------|:--------|:------|
|Volume of passenger transport relative to GDP                                                                            |tran_hv_pstra   |dataset |03.08.2016          |03.08.2016                  |2000       |2014     |NA     |
|Modal split of passenger transport                                                                                       |tran_hv_psmod   |dataset |03.08.2016          |02.08.2016                  |1990       |2014     |NA     |
|Railway transport - total annual passenger transport (1 000 pass., million pkm)                                          |rail_pa_total   |dataset |25.07.2017          |08.11.2016                  |2004       |2015     |NA     |
|Railway transport - passenger transport by type of transport (detailed reporting only) (1 000 pass.)                     |rail_pa_typepas |dataset |25.07.2017          |26.05.2016                  |2004       |2015     |NA     |
|Railway transport - passenger transport by type of transport (detailed reporting only) (million pkm)                     |rail_pa_typepkm |dataset |25.07.2017          |26.05.2016                  |2004       |2015     |NA     |
|International railway passenger transport from the reporting country to the country of disembarkation (1 000 passengers) |rail_pa_intgong |dataset |25.07.2017          |18.07.2017                  |2002       |2016     |NA     |

Codes for the dataset can be searched also from the [Eurostat
database](http://ec.europa.eu/eurostat/data/database). The Eurostat
database gives codes in the Data Navigation Tree after every dataset
in parenthesis.

# Downloading data 

The package supports two of the Eurostats download methods: the bulk download 
facility and the Web Services' JSON API. The bulk download facility is the 
fastest method to download whole datasets. It is also often the only way as 
the JSON API has limitation of maximum 50 sub-indicators at a time and 
whole datasets usually exceeds that. To download only a small section of the 
dataset the JSON API is faster, as it allows to make a data selection 
before downloading.

A user does not usually have to bother with methods, as both are used via main
function `get_eurostat()`. If only the table id is given, the whole table is 
downloaded from the bulk download facility. If also filters are defined 
the JSON API is used.

Here an example of indicator 'Modal split of passenger transport'. This is the percentage share of each mode of transport in total inland transport, expressed in passenger-kilometres (pkm) based on transport by passenger cars, buses and coaches, and trains. All data should be based on movements on national territory, regardless of the nationality of the vehicle. However, the data collection is not harmonized at the EU level. 

Pick and print the id of the data set to download: 

```r
# For the original data, see
# http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&language=en&pcode=tsdtr210
id <- search_eurostat("Modal split of passenger transport", 
        	             type = "table")$code[1]
print(id)
```

[1] "tsdtr210"

Get the whole corresponding table. As the table is annual data, it is more
convient to use a numeric time variable than use the default date format:


```r
dat <- get_eurostat(id, time_format = "num")
```

Investigate the structure of the downloaded data set:

```r
str(dat)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	2326 obs. of  5 variables:
##  $ unit   : Factor w/ 1 level "PC": 1 1 1 1 1 1 1 1 1 1 ...
##  $ vehicle: Factor w/ 3 levels "BUS_TOT","CAR",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ geo    : Factor w/ 35 levels "AT","BE","CH",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ time   : num  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
##  $ values : num  11 10.6 3.7 9.1 11.3 32.4 14.9 13.5 6 24.8 ...
```


```r
kable(head(dat))
```



|unit |vehicle |geo | time| values|
|:----|:-------|:---|----:|------:|
|PC   |BUS_TOT |AT  | 1990|   11.0|
|PC   |BUS_TOT |BE  | 1990|   10.6|
|PC   |BUS_TOT |CH  | 1990|    3.7|
|PC   |BUS_TOT |DE  | 1990|    9.1|
|PC   |BUS_TOT |DK  | 1990|   11.3|
|PC   |BUS_TOT |EL  | 1990|   32.4|

Or you can get only a part of the dataset by defining `filters` argument. It
should be named list, where names corresponds to variable names (lower case) and
values are vectors of codes corresponding desidered series (upper case). For
time variable, in addition to a `time`, also a `sinceTimePeriod` 
and a `lastTimePeriod` can be used.


```r
dat2 <- get_eurostat(id, filters = list(geo = c("EU28", "FI"), lastTimePeriod=1), time_format = "num")
kable(dat2)
```

## Replacing codes with labels

By default variables are returned as Eurostat codes, but to get human-readable 
labels instead, use a `type = "label"` argument.  


```r
datl2 <- get_eurostat(id, filters = list(geo = c("EU28", "FI"), 
                                         lastTimePeriod = 1), 
                      type = "label", time_format = "num")
kable(head(datl2))
```

Eurostat codes in the downloaded data set can be replaced with
human-readable labels from the Eurostat dictionaries with the
`label_eurostat()` function.


```r
datl <- label_eurostat(dat)
kable(head(datl))
```



|unit       |vehicle                                |geo                                              | time| values|
|:----------|:--------------------------------------|:------------------------------------------------|----:|------:|
|Percentage |Motor coaches, buses and trolley buses |Austria                                          | 1990|   11.0|
|Percentage |Motor coaches, buses and trolley buses |Belgium                                          | 1990|   10.6|
|Percentage |Motor coaches, buses and trolley buses |Switzerland                                      | 1990|    3.7|
|Percentage |Motor coaches, buses and trolley buses |Germany (until 1990 former territory of the FRG) | 1990|    9.1|
|Percentage |Motor coaches, buses and trolley buses |Denmark                                          | 1990|   11.3|
|Percentage |Motor coaches, buses and trolley buses |Greece                                           | 1990|   32.4|

The `label_eurostat()` allows conversion of individual variable
vectors or variable names as well.


```r
label_eurostat_vars(names(datl))
```


Vehicle information has 3 levels. You can check them now with:


```r
levels(datl$vehicle)
```



# Selecting and modifying data

## EFTA, Eurozone, EU and EU candidate countries

To facilitate smooth visualization of standard European geographic areas, the package provides ready-made lists of the country codes used in the eurostat database for EFTA (efta\_countries), Euro area (ea\_countries), EU (eu\_countries) and EU candidate countries (eu\_candidate\_countries). These can be used to select specific groups of countries for closer investigation. For conversions with other standard country coding systems, see the [countrycode](...) R package. To retrieve the country code list for EFTA, for instance, use:


```r
data(efta_countries)
kable(efta_countries)
```



|code |name          |
|:----|:-------------|
|IS   |Iceland       |
|LI   |Liechtenstein |
|NO   |Norway        |
|CH   |Switzerland   |


## EU data from 2012 in all vehicles:


```r
dat_eu12 <- subset(datl, geo == "European Union (28 countries)" & time == 2012)
kable(dat_eu12, row.names = FALSE)
```



|unit       |vehicle                                |geo                           | time| values|
|:----------|:--------------------------------------|:-----------------------------|----:|------:|
|Percentage |Motor coaches, buses and trolley buses |European Union (28 countries) | 2012|    9.3|
|Percentage |Passenger cars                         |European Union (28 countries) | 2012|   83.0|
|Percentage |Trains                                 |European Union (28 countries) | 2012|    7.7|

## EU data from 2000 - 2012 with vehicle types as variables:

Reshaping the data is best done with `spread()` in `tidyr`.

```r
library("tidyr")
dat_eu_0012 <- subset(dat, geo == "EU28" & time %in% 2000:2012)
dat_eu_0012_wide <- spread(dat_eu_0012, vehicle, values)
kable(subset(dat_eu_0012_wide, select = -geo), row.names = FALSE)
```



|unit | time| BUS_TOT|  CAR| TRN|
|:----|----:|-------:|----:|---:|
|PC   | 2000|    10.4| 82.4| 7.2|
|PC   | 2001|    10.2| 82.7| 7.1|
|PC   | 2002|     9.9| 83.3| 6.8|
|PC   | 2003|     9.9| 83.5| 6.7|
|PC   | 2004|     9.8| 83.4| 6.8|
|PC   | 2005|     9.9| 83.2| 6.9|
|PC   | 2006|     9.7| 83.2| 7.1|
|PC   | 2007|     9.8| 83.1| 7.2|
|PC   | 2008|     9.7| 83.1| 7.3|
|PC   | 2009|     9.2| 83.7| 7.1|
|PC   | 2010|     9.2| 83.6| 7.2|
|PC   | 2011|     9.2| 83.4| 7.3|
|PC   | 2012|     9.3| 83.0| 7.7|

## Train passengers for selected EU countries in 2000 - 2012


```r
dat_trains <- subset(datl, geo %in% c("Austria", "Belgium", "Finland", "Sweden")
                     & time %in% 2000:2012 
                     & vehicle == "Trains")

dat_trains_wide <- spread(dat_trains, geo, values) 
kable(subset(dat_trains_wide, select = -vehicle), row.names = FALSE)
```



|unit       | time| Austria| Belgium| Finland| Sweden|
|:----------|----:|-------:|-------:|-------:|------:|
|Percentage | 2000|     9.7|     6.3|     5.1|    7.5|
|Percentage | 2001|     9.7|     6.4|     4.8|    7.9|
|Percentage | 2002|     9.7|     6.5|     4.8|    7.8|
|Percentage | 2003|     9.5|     6.5|     4.7|    7.7|
|Percentage | 2004|     9.4|     7.1|     4.7|    7.5|
|Percentage | 2005|     9.8|     6.6|     4.8|    7.7|
|Percentage | 2006|    10.0|     6.9|     4.8|    8.3|
|Percentage | 2007|    10.0|     7.1|     5.0|    8.7|
|Percentage | 2008|    11.1|     7.5|     5.4|    9.4|
|Percentage | 2009|    11.1|     7.5|     5.1|    9.5|
|Percentage | 2010|    11.0|     7.7|     5.2|    9.4|
|Percentage | 2011|    11.3|     7.7|     5.0|    8.8|
|Percentage | 2012|    11.8|     7.8|     5.3|    9.1|



# Visualization

Visualizing train passenger data with `ggplot2`:


```r
library(ggplot2)
p <- ggplot(dat_trains, aes(x = time, y = values, colour = geo)) 
p <- p + geom_line()
print(p)
```

![plot of chunk trains_plot](fig/trains_plot-1.png)

<a name="triangle"></a>**Triangle plot**

Triangle plot is handy for visualizing data sets with three variables. 


```r
library(tidyr)
library(plotrix)
library(eurostat)
library(dplyr)
library(tidyr)

# All sources of renewable energy are to be grouped into three sets
 dict <- c("Solid biofuels (excluding charcoal)" = "Biofuels",
 "Biogasoline" = "Biofuels",
 "Other liquid biofuels" = "Biofuels",
 "Biodiesels" = "Biofuels",
 "Biogas" = "Biofuels",
 "Hydro power" = "Hydro power",
 "Tide, Wave and Ocean" = "Hydro power",
 "Solar thermal" = "Wind, solar, waste and Other",
 "Geothermal Energy" = "Wind, solar, waste and Other",
 "Solar photovoltaic" = "Wind, solar, waste and Other",
 "Municipal waste (renewable)" = "Wind, solar, waste and Other",
 "Wind power" = "Wind, solar, waste and Other",
 "Bio jet kerosene" = "Wind, solar, waste and Other")
# Some cleaning of the data is required
 energy3 <- get_eurostat("ten00081") %>%
 label_eurostat(dat) %>%
 filter(time == "2013-01-01",
 product != "Renewable energies") %>%
 mutate(nproduct = dict[as.character(product)], # just three categories
 geo = gsub(geo, pattern=" \\(.*", replacement="")) %>%
 select(nproduct, geo, values) %>%
 group_by(nproduct, geo) %>%
 summarise(svalue = sum(values)) %>%
 group_by(geo) %>%
 mutate(tvalue = sum(svalue),
 svalue = svalue/sum(svalue)) %>%
 filter(tvalue > 1000) %>% # only large countries
 spread(nproduct, svalue)
 
# Triangle plot
 par(cex=0.75, mar=c(0,0,0,0))
 positions <- plotrix::triax.plot(as.matrix(energy3[, c(3,5,4)]),
                     show.grid = TRUE,
                     label.points= FALSE, point.labels = energy3$geo,
                     col.axis="gray50", col.grid="gray90",
                     pch = 19, cex.axis=0.8, cex.ticks=0.7, col="grey50")

 # Larger labels
 ind <- which(energy3$geo %in%  c("Norway", "Iceland","Denmark","Estonia", "Turkey", "Italy", "Finland"))
 df <- data.frame(positions$xypos, geo = energy3$geo)
 points(df$x[ind], df$y[ind], cex=2, col="red", pch=19)
 text(df$x[ind], df$y[ind], df$geo[ind], adj = c(0.5,-1), cex=1.5)
```

![plot of chunk plotGallery](fig/plotGallery-1.png)



## Maps 

###  Disposable income of private households by NUTS 2 regions at 1:60mln resolution using tmap

The mapping examples below use [`tmap`](https://github.com/mtennekes/tmap) package.



```r
library(dplyr)
library(eurostat)
library(tmap)

# Load example data set
data("tgs00026")
# Can be retrieved from the eurostat service with:
# tgs00026 <- get_eurostat("tgs00026", time_format = "raw")

# Data from Eurostat
sp_data <- tgs00026 %>% 
  # subset to have only a single row per geo
  dplyr::filter(time == 2010, nchar(as.character(geo)) == 4) %>% 
  # categorise
  dplyr::mutate(income = cut_to_classes(values, n = 5)) %>% 
  # merge with geodata
  merge_eurostat_geodata(data = ., geocolumn = "geo",resolution = "60", 
                         output_class = "spdf", all_regions = TRUE) 
```

```
## Warning in cut_to_classes(values, n = 5): manual_breaks in cut_to_classes
## are not unique. Using unique breaks only.
```

```
## 
##       COPYRIGHT NOTICE
## 
##       When data downloaded from this page 
##       <http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
##       is used in any printed or electronic publication, 
##       in addition to any other provisions 
##       applicable to the whole Eurostat website, 
##       data source will have to be acknowledged 
##       in the legend of the map and 
##       in the introductory page of the publication 
##       with the following copyright notice:
## 
##       - EN: (C) EuroGeographics for the administrative boundaries
##       - FR: (C) EuroGeographics pour les limites administratives
##       - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
## 
##       For publications in languages other than 
##       English, French or German, 
##       the translation of the copyright notice 
##       in the language of the publication shall be used.
## 
##       If you intend to use the data commercially, 
##       please contact EuroGeographics for 
##       information regarding their licence agreements.
## 
```

```
## SpatialPolygonDataFrame at resolution 1: 60  cached at:  /tmp/RtmpwoMlit/eurostat/spdf60.RData
```

Load example data (map)


```r
data(Europe)
```


Construct the map


```r
map1 <- tmap::tm_shape(Europe) +
  tmap::tm_fill("lightgrey") +
  tmap::tm_shape(sp_data) +
  tmap::tm_grid() +
  tmap::tm_polygons("income", title = "Disposable household\nincomes in 2010",  
                    palette = "Oranges") +
  tmap::tm_format_Europe()  
```

Interactive maps can be generated as well


```r
# Interactive
tmap_mode("view")
map1

# Set the mode back to normal plotting
tmap_mode("plot")
print(map1)
```

### Disposable income of private households by NUTS 2 regions in Poland with labels at 1:1mln resolution using tmap


```r
library(eurostat)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Downloading and manipulating the tabular data
sp_data <- tgs00026 %>% 
  # subsetting to year 2014 and NUTS-3 level
  dplyr::filter(time == 2014, nchar(as.character(geo)) == 4, grepl("PL",geo)) %>% 
  # label the single geo column
  mutate(label = paste0(label_eurostat(.)[["geo"]], "\n", values, "€"),
         income = cut_to_classes(values)) %>% 
  # merge with geodata
  merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "01", all_regions = FALSE, output_class="spdf")
```

```
## Warning in cut_to_classes(values): manual_breaks in cut_to_classes are not
## unique. Using unique breaks only.
```

```
## 
##       COPYRIGHT NOTICE
## 
##       When data downloaded from this page 
##       <http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
##       is used in any printed or electronic publication, 
##       in addition to any other provisions 
##       applicable to the whole Eurostat website, 
##       data source will have to be acknowledged 
##       in the legend of the map and 
##       in the introductory page of the publication 
##       with the following copyright notice:
## 
##       - EN: (C) EuroGeographics for the administrative boundaries
##       - FR: (C) EuroGeographics pour les limites administratives
##       - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
## 
##       For publications in languages other than 
##       English, French or German, 
##       the translation of the copyright notice 
##       in the language of the publication shall be used.
## 
##       If you intend to use the data commercially, 
##       please contact EuroGeographics for 
##       information regarding their licence agreements.
## 
```

```
## SpatialPolygonDataFrame at resolution 1: 01  cached at:  /tmp/RtmpwoMlit/eurostat/spdf01.RData
```

```r
# plot map
map2 <- tm_shape(Europe) +
  tm_fill("lightgrey") +
  tm_shape(sp_data, is.master = TRUE) +
  tm_polygons("income", title = "Disposable household incomes in 2014",
              palette = "Oranges", border.col = "white") + 
  tm_text("label", just = "center") + 
  tm_scale_bar() +
  tm_format_Europe(legend.outside = TRUE, attr.outside = TRUE)
map2
```

![plot of chunk maps2](fig/maps2-1.png)

### Disposable income of private households by NUTS 2 regions at 1:60mln resolution using spplot


```r
library(sp)
library(eurostat)
library(dplyr)
dat <- tgs00026 %>% 
  # subsetting to year 2014 and NUTS-3 level
  dplyr::filter(time == 2014, nchar(as.character(geo)) == 4) %>% 
  # classifying the values the variable
  dplyr::mutate(cat = cut_to_classes(values)) %>% 
  # merge Eurostat data with geodata from Cisco
  merge_eurostat_geodata(data = .,geocolumn = "geo",resolution = "10", 
                         output_class = "spdf", all_regions = FALSE) 
```

```
## Warning in cut_to_classes(values): manual_breaks in cut_to_classes are not
## unique. Using unique breaks only.
```

```
## 
##       COPYRIGHT NOTICE
## 
##       When data downloaded from this page 
##       <http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
##       is used in any printed or electronic publication, 
##       in addition to any other provisions 
##       applicable to the whole Eurostat website, 
##       data source will have to be acknowledged 
##       in the legend of the map and 
##       in the introductory page of the publication 
##       with the following copyright notice:
## 
##       - EN: (C) EuroGeographics for the administrative boundaries
##       - FR: (C) EuroGeographics pour les limites administratives
##       - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
## 
##       For publications in languages other than 
##       English, French or German, 
##       the translation of the copyright notice 
##       in the language of the publication shall be used.
## 
##       If you intend to use the data commercially, 
##       please contact EuroGeographics for 
##       information regarding their licence agreements.
## 
```

```
## SpatialPolygonDataFrame at resolution 1: 10  cached at:  /tmp/RtmpwoMlit/eurostat/spdf10.RData
```

```r
# plot map
sp::spplot(obj = dat, "cat", main = "Disposable household income",
	   xlim = c(-22,34), ylim = c(35,70), 
           col.regions = c("dim grey", brewer.pal(n = 5, name = "Oranges")),
	   col = "white", usePolypath = FALSE)
```

![plot of chunk maps3](fig/maps3-1.png)



## SDMX

Eurostat data is available also in the SDMX format. The eurostat R package does not provide custom tools for this but the generic rsdmx R package can be used to access data in that format when necessary:


```r
library(rsdmx)

# Data set URL
url <- "http://ec.europa.eu/eurostat/SDMX/diss-web/rest/data/cdh_e_fos/..PC.FOS1.BE/?startperiod=2005&endPeriod=2011"

# Read the data from eurostat
d <- readSDMX(url)

# Convert to data frame and show the first entries
df <- as.data.frame(d)

kable(head(df))
```




# Further examples

For further examples, see the [package homepage](http://ropengov.github.io/eurostat/articles/index.html).


# Citations and related work

### Citing the data sources

Eurostat data: cite [Eurostat](http://ec.europa.eu/eurostat/).

Administrative boundaries: cite EuroGeographics


### Citing the eurostat R package

For main developers and contributors, see the [package homepage](http://ropengov.github.io/eurostat).

This work can be freely used, modified and distributed under the
BSD-2-clause (modified FreeBSD) license:


```r
citation("eurostat")
```

```
## 
## Kindly cite the eurostat R package as follows:
## 
##   (C) Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek.
##   Retrieval and analysis of Eurostat open data with the eurostat
##   package. R Journal 9(1):385-392, 2017. Version 3.1.3 Package
##   URL: http://ropengov.github.io/eurostat Manuscript URL:
##   https://journal.r-project.org/archive/2017/RJ-2017-019/index.html
## 
## A BibTeX entry for LaTeX users is
## 
##   @Misc{,
##     title = {eurostat R package},
##     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
##     journal = {R Journal},
##     volume = {9},
##     number = {1},
##     pages = {385-392},
##     year = {2017},
##     url = {https://journal.r-project.org/archive/2017/RJ-2017-019/index.html},
##     note = {Version 3.1.3},
##   }
```

### Related work

This [rOpenGov](http://ropengov.github.io) R package is based on the
earlier CRAN packages
[statfi](https://cran.r-project.org/package=statfi) and
[smarterpoland](https://cran.r-project.org/package=SmarterPoland).

The independent [reurostat](https://github.com/Tungurahua/reurostat)
package develops related Eurostat tools but seems to be in an
experimental stage at the time of writing this tutorial.

The more generic [quandl](https://cran.r-project.org/package=quandl),
[datamart](https://cran.r-project.org/package=datamart),
[rsdmx](https://cran.r-project.org/package=rsdmx), and
[pdfetch](https://cran.r-project.org/package=pdfetch) packages may
provide access to some versions of eurostat data but these packages
are more generic and hence, in contrast to the eurostat R package,
lack tools that are specifically customized to facilitate eurostat
analysis.


### Contact

For contact information, see the [package homepage](http://ropengov.github.io/eurostat).


# Version info

This tutorial was created with


```r
sessionInfo()
```

```
## R version 3.4.1 (2017-06-30)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 17.04
## 
## Matrix products: default
## BLAS: /usr/lib/openblas-base/libblas.so.3
## LAPACK: /usr/lib/libopenblasp-r0.2.19.so
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
##  [1] sp_1.2-5           RColorBrewer_1.1-2 tmap_1.10         
##  [4] dplyr_0.7.2        plotrix_3.6-5      ggplot2_2.2.1     
##  [7] tidyr_0.6.3        bindrcpp_0.2       rvest_0.3.2       
## [10] xml2_1.1.1         eurostat_3.1.3     knitr_1.16        
## 
## loaded via a namespace (and not attached):
##  [1] nlme_3.1-131       bitops_1.0-6       sf_0.5-3          
##  [4] satellite_1.0.0    webshot_0.4.1.9000 gmodels_2.16.2    
##  [7] httr_1.2.1         mapview_2.1.4      tools_3.4.1       
## [10] rgdal_1.2-8        R6_2.2.2           KernSmooth_2.23-15
## [13] DBI_0.7            rgeos_0.3-23       lazyeval_0.2.0    
## [16] colorspace_1.3-2   raster_2.5-8       leaflet_1.1.0     
## [19] curl_2.8.1         compiler_3.4.1     Cairo_1.5-9       
## [22] expm_0.999-2       labeling_0.3       scales_0.4.1      
## [25] rmapshaper_0.2.0   classInt_0.1-24    readr_1.1.1       
## [28] stringr_1.2.0      digest_0.6.12      R.utils_2.5.0     
## [31] base64enc_0.1-3    dichromat_2.0-0    pkgconfig_2.0.1   
## [34] htmltools_0.3.6    highr_0.6          jsonvalidate_1.0.0
## [37] htmlwidgets_0.9    rlang_0.1.1.9000   shiny_1.0.3.9002  
## [40] bindr_0.1          jsonlite_1.5       crosstalk_1.0.0   
## [43] gtools_3.5.0       spdep_0.6-13       R.oo_1.21.0       
## [46] RCurl_1.95-4.8     magrittr_1.5       geosphere_1.5-5   
## [49] Matrix_1.2-10      Rcpp_0.12.12       munsell_0.4.3     
## [52] R.methodsS3_1.7.1  stringi_1.1.5      MASS_7.3-47       
## [55] tmaptools_1.2-1    plyr_1.8.4         grid_3.4.1        
## [58] gdata_2.18.0       udunits2_0.13      deldir_0.1-14     
## [61] lattice_0.20-35    splines_3.4.1      hms_0.3           
## [64] boot_1.3-20        gdalUtils_2.0.1.7  geojsonlint_0.2.0 
## [67] codetools_0.2-15   stats4_3.4.1       LearnBayes_2.15   
## [70] osmar_1.1-7        XML_3.98-1.9       glue_1.1.1        
## [73] evaluate_0.10.1    V8_1.5             png_0.1-7         
## [76] httpuv_1.3.5       foreach_1.4.3      gtable_0.2.0      
## [79] assertthat_0.2.0   mime_0.5           xtable_1.8-2      
## [82] e1071_1.6-8        coda_0.19-1        viridisLite_0.2.0 
## [85] class_7.3-14       tibble_1.3.3       iterators_1.0.8   
## [88] units_0.4-5
```
