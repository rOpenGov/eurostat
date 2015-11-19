<!--
%\VignetteEngine{knitr::rmarkdown}
%\VignetteIndexEntry{eurostat Markdown Vignette}
%\usepackage[utf8]{inputenc}
-->
    ## Warning in ReadBib(file, .Encoding = .Encoding, header = NULL, footer = NULL, : 
    ## bibliography.bib:32:0
    ##  syntax error, unexpected TOKEN_ABBREV, expecting TOKEN_COMMA or TOKEN_RBRACE
    ##  Dropping the entry `Lahti13icml` (starting at line 24)

R package eurostat
==================

Introduction
------------

This R package provides open source tools to access [open data from Eurostat](http://ec.europa.eu/eurostat/) in [R statistical programming language](http://www.r-project.org) (R Core Team, 2013).

-   reshape2 (Wickham, 2007)
-   ggplot2 (Wickham, 2009)
-   dplyr (Wickham and Francois, 2015)
-   tidyr (Wickham, 2015)
-   knitr (Xie, 2015a; Xie, 2015b; Xie, 2014)
-   mapproj (Brownrigg, Minka, and Bivand., 2015)
-   plotrix (J, 2006)
-   rmarkdown (Allaire, Cheng, Xie, et al., 2015)
-   testthat (Wickham, 2011)
-   stringi (Gagolewski and Tartanus, 2015)
-   devtools (Wickham and Chang, 2015)

The eurostat package is based on the earlier CRAN packages [statfi](http://cran.r-project.org/web/packages/statfi/index.html) and [smarterpoland](http://cran.r-project.org/web/packages/SmarterPoland/index.html). The package has reached maturity, and has been actively developed based on the community feedback in Github. The package is part of the [rOpenGov](http://ropengov.github.io) collection `r citep(bib[["Lahti13icml"]])`, which provides reproducible research tools (Gandrud, 2013) for computational social science and digital humanities. The source code can be freely used, modified and distributed under the BSD-2-clause (modified FreeBSD) license.

The [datamart](http://cran.r-project.org/web/packages/datamart/index.html) and the [quandl](http://cran.r-project.org/web/packages/Quandl/index.html) `r citep(citation("quandl"))` R packages provide also access to certain versions of eurostat data. In contrast to these generic database packages, our work is fully focused on the Eurostat open data portal and provides specific functionality suited for this data collection. There is a development version for R package [reurostat](https://github.com/Tungurahua/reurostat) but it does not seem to be actively maintained at the moment (last commits at ...).

Available tools
---------------

Complete detailed and reproducible installation instructions and usage examples of the eurostat R package are provided in the [package vignette](https://github.com/rOpenGov/eurostat/vignette/eurostat_tutorial.Rmd). The package includes tools to search and retrieve specific data sets from the Eurostat open data portal, converting identifiers in human-readable formats, selecting, modifying and visualizing the data.

Here we describe the functionality of the current CRAN release version (1.2.1). To install this, simply use

``` r
install.packages("eurostat")
```

The development version is available via Github, see instructions at the package [github page](https://github.com/rOpenGov/eurostat).

-   **Finding data** You can download the list of available data sets with the `get_eurostat_toc()` function
-   With `search_eurostat()` you can search the table of contents for particular patterns, e.g. all datasets related to *passenger transport*.

``` r
# Load the package
library(eurostat)
# info about passengers
library(knitr)
kable(head(search_eurostat("passenger transport")))
```

Codes for the dataset can be searched also from the Eurostat database . The Eurostat database gives codes in the Data Navigation Tree after every dataset in parenthesis.

-   **Downloading data** Here an example of indicator [Modal split of passenger transport](http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&language=en&pcode=tsdtr210). This is the percentage share of each mode of transport in total inland transport, expressed in passenger-kilometres (pkm) based on transport by passenger cars, buses and coaches, and trains. All data should be based on movements on national territory, regardless of the nationality of the vehicle. However, the data collection is not harmonized at the EU level.

Pick and print the id of the data set to download:

``` r
id <- search_eurostat("Modal split of passenger transport", 
                         type = "table")$code[1]
print(id)
```

Get the corresponding table. As the table is annual data, it is more convient to use a numeric time variable than use the default date format:

``` r
dat <- get_eurostat(id, time_format = "num")
```

Eurostat variable IDs can be replaced with human-readable labels with the `label_eurostat()` function. This replaces the eurostat IDs based on definitions from Eurostat dictionaries. For examples, see the package vignette.

Selecting and modifying data
----------------------------

``` r
datl <- label_eurostat(dat)
label_eurostat_vars(names(datl))
```

EU data from 2012 in all vehicles:

``` r
dat_eu12 <- subset(datl, geo == "European Union (28 countries)" & time == 2012)
kable(dat_eu12, row.names = FALSE)
```

EU data from 2000 - 2012 with vehicle types as variables:

Reshaping the data is best done with `spread()` in `tidyr`.

``` r
library("tidyr")
dat_eu_0012 <- subset(dat, geo == "EU28" & time %in% 2000:2012)
dat_eu_0012_wide <- spread(dat_eu_0012, vehicle, values)
kable(subset(dat_eu_0012_wide, select = -geo), row.names = FALSE)
```

Train passengers for selected EU countries in 2000 - 2012

``` r
dat_trains <- subset(datl, geo %in% c("Austria", "Belgium", "Finland", "Sweden")
                     & time %in% 2000:2012
                     & vehicle == "Trains")
dat_trains_wide <- spread(dat_trains, geo, values) 
kable(subset(dat_trains_wide, select = -vehicle), row.names = FALSE)
```

Finally, by combining the data with available map information we can visualize train passenger data with `ggplot2`:

``` r
library(ggplot2)
p <- ggplot(dat_trains, aes(x = time, y = values, colour = geo)) 
p <- p + geom_line()
print(p)
```

Triangle plot on passenger transport distributions with 2012 data for all countries with data.

``` r
library(tidyr)

transports <- spread(subset(dat, time == 2012, select = c(geo, vehicle, values)), vehicle, values)

transports <- na.omit(transports)

# triangle plot
library(plotrix)
triax.plot(transports[, -1], show.grid = TRUE, 
           label.points = TRUE, point.labels = transports$geo, 
           pch = 19)
```

Acknowledgements
----------------

We are grateful to [Eurostat](http://ec.europa.eu/eurostat/) for maintaining the open data portal and the [rOpenGov](https://github.ropengov.io) collection for supporting the package development. This work has been partially funded by Academy of Finland (decision ...).

### References

[1] J. Allaire, J. Cheng, Y. Xie, et al. *rmarkdown: Dynamic Documents for R*. R package version 0.8.1. 2015. <URL:
http://rmarkdown.rstudio.com>.

[2] D. M. P. f. R. b. R. Brownrigg, T. P. Minka and t. t. P. 9. c. b. R. Bivand. *mapproj: Map Projections*. R package version 1.2-4. 2015. <URL: http://CRAN.R-project.org/package=mapproj>.

[3] M. Gagolewski and B. Tartanus. *R package stringi: Character string processing facilities*. 2015. DOI: 10.5281/zenodo.19071. <URL: http://stringi.rexamine.com/>.

[4] C. Gandrud. *Reproducible Research with R and R Studio*. Chapman & Hall/CRC, Jul. 2013.

[5] L. J. "Plotrix: a package in the red light district of R". In: *R-News* 6.4 (2006), pp. 8-12.

[6] R Core Team. *R: A language and environment for statistical computing*. Vienna, Austria: R Foundation for Statistical Computing, 2013. ISBN: ISBN 3-900051-07-0. <URL:
http://www.R-project.org/>.

[7] H. Wickham. *ggplot2: elegant graphics for data analysis*. Springer New York, 2009. ISBN: 978-0-387-98140-6. <URL:
http://had.co.nz/ggplot2/book>.

[8] H. Wickham. "Reshaping Data with the reshape Package". In: *Journal of Statistical Software* 21.12 (2007), pp. 1-20. <URL:
http://www.jstatsoft.org/v21/i12/>.

[9] H. Wickham. "testthat: Get Started with Testing". In: *The R Journal* 3 (2011), pp. 5-10. <URL:
http://journal.r-project.org/archive/2011-1/RJournal_2011-1_Wickham.pdf>.

[10] H. Wickham. *tidyr: Easily Tidy Data with `spread()` and `gather()` Functions*. R package version 0.3.1. 2015. <URL:
http://CRAN.R-project.org/package=tidyr>.

[11] H. Wickham and W. Chang. *devtools: Tools to Make Developing R Packages Easier*. R package version 1.9.1. 2015. <URL:
http://CRAN.R-project.org/package=devtools>.

[12] H. Wickham and R. Francois. *dplyr: A Grammar of Data Manipulation*. R package version 0.4.3. 2015. <URL:
http://CRAN.R-project.org/package=dplyr>.

[13] Y. Xie. *Dynamic Documents with R and knitr*. 2nd. ISBN 978-1498716963. Boca Raton, Florida: Chapman and Hall/CRC, 2015. <URL: http://yihui.name/knitr/>.

[14] Y. Xie. "knitr: A Comprehensive Tool for Reproducible Research in R". In: *Implementing Reproducible Computational Research*. Ed. by V. Stodden, F. Leisch and R. D. Peng. ISBN 978-1466561595. Chapman and Hall/CRC, 2014. <URL:
http://www.crcpress.com/product/isbn/9781466561595>.

[15] Y. Xie. *knitr: A General-Purpose Package for Dynamic Report Generation in R*. R package version 1.11. 2015. <URL:
http://yihui.name/knitr/>.
