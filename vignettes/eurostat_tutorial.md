<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->

Eurostat R tools
===========

This R package provides tools to access [Eurostat open
data](http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/themes)
as part of the [rOpenGov](http://ropengov.github.io) project.


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



## Accessing Eurostat data 


```r
library(eurostat)

# Get Eurostat data listing
toc <- getEurostatTOC()
head(toc)
```

```
##                                                              title
## 1                                               Database by themes
## 2                                  General and regional statistics
## 3         European and national indicators for short-term analysis
## 4                 Business and consumer surveys (source: DG ECFIN)
## 5                              Consumer surveys (source: DG ECFIN)
## 6                                         Consumers - monthly data
##        code    type last.update.of.data last.table.structure.change
## 1      data  folder                                                
## 2   general  folder                                                
## 3   euroind  folder                                                
## 4    ei_bcs  folder                                                
## 5 ei_bcs_cs  folder                                                
## 6 ei_bsco_m dataset          29.04.2014                  29.04.2014
##   data.start data.end values
## 1                         NA
## 2                         NA
## 3                         NA
## 4                         NA
## 5                         NA
## 6    1985M01  2014M04     NA
```

```r

# info about passagers
grepEurostatTOC("split of passenger transport", type = "dataset")
```

```
## Error: unused argument (type = "dataset")
```

```r
grepEurostatTOC("split of passenger transport", type = "table")
```

```
## Error: unused argument (type = "table")
```

```r

# Pick ID for the table
id <- unique(grepEurostatTOC("split of passenger transport", type = "table")$code)
```

```
## Error: unused argument (type = "table")
```

```r
id
```

```
## Error: object 'id' not found
```

```r

# Get table with the given ID
tmp <- getEurostatRCV(id)
```

```
## Error: object 'id' not found
```

```r
summary(tmp)
```

```
## Error: object 'tmp' not found
```



## Triangle plot for split of passenger transport


```r
library(reshape)
tmp <- getEurostatRCV("tsdtr210")
bus <- cast(tmp, geo ~ time, mean, subset = vehicle == "BUS_TOT")
car <- cast(tmp, geo ~ time, mean, subset = vehicle == "CAR")
train <- cast(tmp, geo ~ time, mean, subset = vehicle == "TRN")

# select 2010 data
allTransports <- data.frame(bus = bus[, "2010 "], car = car[, "2010 "], train = train[, 
    "2010 "])
# add countrynames
rownames(allTransports) <- levels(bus[, 1])
allTransports <- na.omit(allTransports)

# triangle plot
library("plotrix")
triax.plot(allTransports, show.grid = TRUE, label.points = TRUE, point.labels = rownames(allTransports), 
    pch = 19)
```

![plot of chunk plotGallery](figure/plotGallery.png) 



## Working with country codes

Eurostat is using ISO2 format for country names, OECD is using ISO3 for their studies, and Statistics Finland uses full country names. The [countrycode](http://cran.r-project.org/web/packages/countrycode/index.html) package can be used to convert between these formats.


```r
library("countrycode")

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



## Mapping the household incomes at NUTS2 level

In the following exercise we are plotting household income data from Eurostat on map from three different years. In addition to downloading and manipulating data from EUROSTAT, you will learn how to access and use spatial shapefiles of Europe published by EUROSTAT at [Administrative units / Statistical units](http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco_Geographical_information_maps/popups/references/administrative_units_statistical_units_1). 

### Retrieving and manipulating the data tabular data from Eurostat

First, we shall retrieve the nuts2-level figures of variable `tgs00026` (Disposable income of private households by NUTS 2 regions) and manipulate the extract the information for creating `unit` and `geo` variables.



```r
library(eurostat)
df <- getEurostatRaw(kod = "tgs00026")
names(df) <- c("xx", 2011:2000)
df$unit <- lapply(strsplit(as.character(df$xx), ","), "[", 2)
df$geo <- lapply(strsplit(as.character(df$xx), ","), "[", 3)
```


### Retrieving and manipulating the spatial data from GISCO

Second, we will download the zipped shapefile in 1:60 million scale from year 2010 and subset it at the level of NUTS2.



```r
# Load the GISCO shapefile
download.file("http://epp.eurostat.ec.europa.eu/cache/GISCO/geodatafiles/NUTS_2010_60M_SH.zip", 
    destfile = "NUTS_2010_60M_SH.zip")
# unzip
unzip("NUTS_2010_60M_SH.zip")
library(rgdal)
# read into SpatialPolygonsDataFrame
map <- readOGR(dsn = "./NUTS_2010_60M_SH/data", layer = "NUTS_RG_60M_2010")
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "./NUTS_2010_60M_SH/data", layer: "NUTS_RG_60M_2010"
## with 1920 features and 4 fields
## Feature type: wkbPolygon with 2 dimensions
```

```r
# subset the spatialpolygondataframe at NUTS2-level
map_nuts2 <- subset(map, STAT_LEVL_ == 2)
```


### Merge the tabular data with spatial data into single SpatialPolygonDataFrame

Third, we will make the both datas of same lenght, give then identical rownames and then merge the tabular data with the spatial data.



```r
# dim show how many regions are in the spatialpolygondataframe
dim(map_nuts2)
```

```
## [1] 316   4
```

```r
# dim show how many regions are in the data.frame
dim(df)
```

```
## [1] 275  15
```

```r
# Spatial dataframe has 467 rows and attribute data 275.  We need to make
# attribute data to have similar number of rows
NUTS_ID <- as.character(map_nuts2$NUTS_ID)
VarX <- rep(NA, 316)
dat <- data.frame(NUTS_ID, VarX)
# then we shall merge this with Eurostat data.frame
dat2 <- merge(dat, df, by.x = "NUTS_ID", by.y = "geo", all.x = TRUE)
## merge this manipulated attribute data with the spatialpolygondataframe
## rownames
row.names(dat2) <- dat2$NUTS_ID
row.names(map_nuts2) <- as.character(map_nuts2$NUTS_ID)
## order data
dat2 <- dat2[order(row.names(dat2)), ]
map_nuts2 <- map_nuts2[order(row.names(map_nuts2)), ]
## join
library(maptools)
dat2$NUTS_ID <- NULL
shape <- spCbind(map_nuts2, dat2)
```



### Fortify the shapefile into data.frame and ready for ggplot-plotting

As we are using ggplot2-package for plotting, we have to fortify the `SpatialPolygonDataFrame` into regular `data.frame`-class. As we have income data from several years, we have to also melt the data into long format for plotting.



```r
## fortify spatialpolygondataframe into data.frame
library(ggplot2)
library(rgeos)
shape$id <- rownames(shape@data)
map.points <- fortify(shape, region = "id")
map.df <- merge(map.points, shape, by = "id")
# As we want to plot map faceted by years from 2003 to 2011 we have to melt
# it into long format (variable with numerical names got X-prefix during the
# spCbind-merge, therefore the X-prefix in variable names)

library(reshape2)
map.df.l <- melt(data = map.df, id.vars = c("id", "long", "lat", "group", "NUTS_ID"), 
    measure.vars = c("X2000", "X2001", "X2002", "X2003", "X2004", "X2005", "X2006", 
        "X2007", "X2008", "X2009", "X2010", "X2011"))
# year variable (variable) is class string and type X20xx.  Lets remove the
# X and convert it to numerical
library(stringr)
map.df.l$variable <- str_replace_all(map.df.l$variable, "X", "")
map.df.l$variable <- factor(map.df.l$variable)
map.df.l$variable <- as.numeric(levels(map.df.l$variable))[map.df.l$variable]
```


### And finally the plot using ggplot2

Map shows the distribution of *disposable income of private households* at NUTS2 level and the color coding is done so that middle of the scale (white color) is the median count from that particular year. **It is important to note that it is not the median income of European households, but the median of the NUTS2-level aggregates**


```r
library(ggplot2)
library(scales)
# lets choose only three years
map.df.l <- map.df.l[map.df.l$variable == c(2000, 2005, 2011), ]
# years for for loop
years <- unique(map.df.l$variable)
for (year in years) {
    median_in_data <- median(map.df.l[map.df.l$variable == year, ]$value, na.rm = TRUE)
    print(ggplot(data = map.df.l[map.df.l$variable == year, ], aes(long, lat, 
        group = group)) + geom_polygon(aes(fill = value), colour = "white", 
        size = 0.2) + geom_polygon(data = map.df.l, aes(long, lat), fill = NA, 
        colour = "white", size = 0.1) + scale_fill_gradient2(low = "#d8b365", 
        high = "#5ab4ac", midpoint = median_in_data) + coord_map(project = "orthographic", 
        xlim = c(-22, 34), ylim = c(35, 70)) + labs(title = paste0("Year ", 
        year, ". Median of \n regional incomes (tgs00026)  is ", median_in_data)))
}
```

![plot of chunk eurostat_map4](figure/eurostat_map41.png) ![plot of chunk eurostat_map4](figure/eurostat_map42.png) ![plot of chunk eurostat_map4](figure/eurostat_map43.png) 




### Citing the package

This R package is based on earlier CRAN packages [statfi](http://cran.r-project.org/web/packages/statfi/index.html) and [smarterpoland](http://cran.r-project.org/web/packages/SmarterPoland/index.html). The [datamart](http://cran.r-project.org/web/packages/datamart/index.html) package contains related tools for Eurostat but at the time of writing this tutorial this package seems to be in an experimental stage.

**Citing the Data** Kindly cite [Eurostat](http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database). 


**Citing the R tools** This work can be freely used, modified and
distributed under the [BSD-2-clause (modified FreeBSD)
license]. Kindly cite the R package as 'Leo Lahti, Przemyslaw Biecek
and Markus Kainu (C) 2014. eurostat R package. URL:
http://ropengov.github.io/eurostat'.


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
##  [1] mapproj_1.2-2    maps_2.3-6       scales_0.2.4     reshape2_1.2.2  
##  [5] rgeos_0.3-4      ggplot2_0.9.3.1  maptools_0.8-29  rgdal_0.8-16    
##  [9] sp_1.0-15        countrycode_0.16 plotrix_3.5-5    eurostat_0.9.3  
## [13] statfi_0.9.06    pxR_0.29         stringr_0.6.2    reshape_0.8.5   
## [17] knitr_1.5       
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 digest_0.6.4     evaluate_0.5.3   foreign_0.8-61  
##  [5] formatR_0.10     grid_3.0.2       gtable_0.1.2     labeling_0.2    
##  [9] lattice_0.20-29  MASS_7.3-31      munsell_0.4.2    plyr_1.8.1      
## [13] proto_0.3-10     Rcpp_0.11.1      tools_3.0.2
```

