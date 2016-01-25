<!--
%\VignetteIndexEntry{eurostat tutorial}
%\VignetteEngine{knitr::knitr}
%\usepackage[utf8]{inputenc}
-->
Eurostat R tools
================

This R package provides tools to access [Eurostat
database](http://ec.europa.eu/eurostat/) as part of the
[rOpenGov](http://ropengov.github.io) project.

For contact information and source code, see the [github
page](https://github.com/rOpenGov/eurostat)

Available tools
---------------

-   [Installation](#installation)
-   [Finding data](#search)
-   [Downloading data](#download)  
-   [Replacing codes with labels](#labeling)  
-   [Selecting and modifying data](#select)  
-   [Visualization](#visualization)  
-   [Triangle plot](#triangle)  
-   [Citing the package](#citing)  
-   [Acknowledgements](#acknowledgements)  
-   [Session info](#session)

<a name="installation"></a>Installation
---------------------------------------

Release version:

    install.packages("eurostat")

Development version:

    library(devtools)
    install_github("ropengov/eurostat")

Overall, the eurostat package includes the following functions:

    library(eurostat)
    kable(as.data.frame(ls("package:eurostat")))

ls("package:eurostat")
----------------------

candidate\_countries  
clean\_eurostat\_cache  
dic\_order  
ea\_countries  
efta\_countries  
eu\_countries  
eurotime2date  
eurotime2num  
get\_eurostat  
get\_eurostat\_dic  
getEurostatDictionary  
get\_eurostat\_json  
get\_eurostat\_toc  
getEurostatTOC  
grepEurostatTOC  
label\_eurostat  
label\_eurostat\_tables  
label\_eurostat\_vars  
search\_eurostat

<a name="search"></a>Finding data
---------------------------------

Function `get_eurostat_toc()` downloads a table of contents of eurostat
datasets. The values in column 'code' should be used to download a
selected dataset.

    # Load the package
    library(eurostat)
    library(rvest)

    # Get Eurostat data listing
    toc <- get_eurostat_toc()

    # Check the first items
    library(knitr)
    kable(head(toc))

<table>
<thead>
<tr class="header">
<th align="left">title</th>
<th align="left">code</th>
<th align="left">type</th>
<th align="left">last.update.of.data</th>
<th align="left">last.table.structure.change</th>
<th align="left">data.start</th>
<th align="left">data.end</th>
<th align="left">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Database by themes</td>
<td align="left">data</td>
<td align="left">folder</td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">General and regional statistics</td>
<td align="left">general</td>
<td align="left">folder</td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">European and national indicators for short-term analysis</td>
<td align="left">euroind</td>
<td align="left">folder</td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Business and consumer surveys (source: DG ECFIN)</td>
<td align="left">ei_bcs</td>
<td align="left">folder</td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">Consumer surveys (source: DG ECFIN)</td>
<td align="left">ei_bcs_cs</td>
<td align="left">folder</td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Consumers - monthly data</td>
<td align="left">ei_bsco_m</td>
<td align="left">dataset</td>
<td align="left">07.01.2016</td>
<td align="left">07.01.2016</td>
<td align="left">1985M01</td>
<td align="left">2015M12</td>
<td align="left">NA</td>
</tr>
</tbody>
</table>

With `search_eurostat()` you can search the table of contents for
particular patterns, e.g. all datasets related to *passenger transport*.
The kable function to produces nice markdown output. Note that with the
`type` argument of this function you could restrict the search to for
instance datasets or tables.

    # info about passengers
    kable(head(search_eurostat("passenger transport")))

<table>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">title</th>
<th align="left">code</th>
<th align="left">type</th>
<th align="left">last.update.of.data</th>
<th align="left">last.table.structure.change</th>
<th align="left">data.start</th>
<th align="left">data.end</th>
<th align="left">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">5562</td>
<td align="left">Volume of passenger transport relative to GDP</td>
<td align="left">tran_hv_pstra</td>
<td align="left">dataset</td>
<td align="left">05.06.2015</td>
<td align="left">04.06.2015</td>
<td align="left">1995</td>
<td align="left">2013</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">5563</td>
<td align="left">Modal split of passenger transport</td>
<td align="left">tran_hv_psmod</td>
<td align="left">dataset</td>
<td align="left">05.06.2015</td>
<td align="left">05.06.2015</td>
<td align="left">1990</td>
<td align="left">2013</td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">5602</td>
<td align="left">Railway transport - Total annual passenger transport (1 000 pass., million pkm)</td>
<td align="left">rail_pa_total</td>
<td align="left">dataset</td>
<td align="left">12.01.2016</td>
<td align="left">29.10.2015</td>
<td align="left">2004</td>
<td align="left">2014</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">5606</td>
<td align="left">International railway passenger transport from the reporting country to the country of disembarkation (1 000 passengers)</td>
<td align="left">rail_pa_intgong</td>
<td align="left">dataset</td>
<td align="left">17.12.2015</td>
<td align="left">17.12.2015</td>
<td align="left">2002</td>
<td align="left">2014</td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">5607</td>
<td align="left">International railway passenger transport from the country of embarkation to the reporting country (1 000 passengers)</td>
<td align="left">rail_pa_intcmng</td>
<td align="left">dataset</td>
<td align="left">17.12.2015</td>
<td align="left">17.12.2015</td>
<td align="left">2002</td>
<td align="left">2014</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">5956</td>
<td align="left">Air passenger transport by reporting country</td>
<td align="left">avia_paoc</td>
<td align="left">dataset</td>
<td align="left">13.01.2016</td>
<td align="left">13.01.2016</td>
<td align="left">1993</td>
<td align="left">2015Q3</td>
<td align="left">NA</td>
</tr>
</tbody>
</table>

Codes for the dataset can be searched also from the [Eurostat
database](http://ec.europa.eu/eurostat/data/database). The Eurostat
database gives codes in the Data Navigation Tree after every dataset in
parenthesis.

<a name="download"></a>Downloading data
---------------------------------------

The packeage supports two of the Eurostats download methods: the bulk
download facility and the Web Services' JSON API. The bulk download
facility is the fastest method to download whole datasets. It is also
often the only way as the JSON API has limitation of maximum 50
sub-indicators at time and whole datasets usually exceeds that. To
download only a small section of the dataset the JSON API is faster, as
it allows to make a data selection before downloading.

A user does not usually have to bother with methods, as both are used
via main function `get_eurostat()`. If only the table id is given, the
whole table is downloaded from the bulk download facility. If also
filters are defined the JSON API is used.

Here an example of indicator [Modal split of passenger
transport](http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&language=en&pcode=tsdtr210).
This is the percentage share of each mode of transport in total inland
transport, expressed in passenger-kilometres (pkm) based on transport by
passenger cars, buses and coaches, and trains. All data should be based
on movements on national territory, regardless of the nationality of the
vehicle. However, the data collection is not harmonized at the EU level.

Pick and print the id of the data set to download:

    id <- search_eurostat("Modal split of passenger transport", 
                             type = "table")$code[1]
    print(id)

[1] "tsdtr210"

Get the whole corresponding table. As the table is annual data, it is
more convient to use a numeric time variable than use the default date
format:

    dat <- get_eurostat(id, time_format = "num")

Investigate the structure of the downloaded data set:

    str(dat)

    ## 'data.frame':    2520 obs. of  5 variables:
    ##  $ unit   : Factor w/ 1 level "PC": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ vehicle: Factor w/ 3 levels "BUS_TOT","CAR",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ geo    : Factor w/ 35 levels "AT","BE","BG",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ time   : num  2013 2013 2013 2013 2013 ...
    ##  $ values : num  9.8 15.2 16.2 5.1 18.5 17.9 5.8 9.8 14.4 17.8 ...

    kable(head(dat))

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="left">vehicle</th>
<th align="left">geo</th>
<th align="right">time</th>
<th align="right">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">AT</td>
<td align="right">2013</td>
<td align="right">9.8</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">BE</td>
<td align="right">2013</td>
<td align="right">15.2</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">BG</td>
<td align="right">2013</td>
<td align="right">16.2</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">CH</td>
<td align="right">2013</td>
<td align="right">5.1</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">CY</td>
<td align="right">2013</td>
<td align="right">18.5</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">CZ</td>
<td align="right">2013</td>
<td align="right">17.9</td>
</tr>
</tbody>
</table>

Or you can get only a part of the dataset by defining `filters`
argument. It should be named list, where names corresponds to variable
names (lower case) and values are vectors of codes corresponding
desidered series (upper case). For time variable, in addition to a
`time`, also a `sinceTimePeriod` and a `lastTimePeriod` can be used.

    dat2 <- get_eurostat(id, filters = list(geo = c("EU28", "FI"), lastTimePeriod=1), time_format = "num")
    kable(dat2)

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="left">vehicle</th>
<th align="left">geo</th>
<th align="right">time</th>
<th align="right">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">EU28</td>
<td align="right">2013</td>
<td align="right">9.2</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">FI</td>
<td align="right">2013</td>
<td align="right">9.8</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">CAR</td>
<td align="left">EU28</td>
<td align="right">2013</td>
<td align="right">83.2</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">CAR</td>
<td align="left">FI</td>
<td align="right">2013</td>
<td align="right">84.9</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">TRN</td>
<td align="left">EU28</td>
<td align="right">2013</td>
<td align="right">7.6</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">TRN</td>
<td align="left">FI</td>
<td align="right">2013</td>
<td align="right">5.3</td>
</tr>
</tbody>
</table>

### <a name="labeling"></a>Replacing codes with labels

By default variables are returned as Eurostat codes, but to get
human-readable labels instead, use a `type = "label"` argument.

    datl2 <- get_eurostat(id, filters = list(geo = c("EU28", "FI"), 
                                             lastTimePeriod = 1), 
                          type = "label", time_format = "num")
    kable(head(datl2))

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="left">vehicle</th>
<th align="left">geo</th>
<th align="right">time</th>
<th align="right">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2013</td>
<td align="right">9.2</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Finland</td>
<td align="right">2013</td>
<td align="right">9.8</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Passenger cars</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2013</td>
<td align="right">83.2</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Passenger cars</td>
<td align="left">Finland</td>
<td align="right">2013</td>
<td align="right">84.9</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Trains</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2013</td>
<td align="right">7.6</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Trains</td>
<td align="left">Finland</td>
<td align="right">2013</td>
<td align="right">5.3</td>
</tr>
</tbody>
</table>

Eurostat codes can be replaced also after downloadind with
human-readable labels using a function `label_eurostat()`. It replaces
the eurostat codes based on definitions from Eurostat dictionaries.

    datl <- label_eurostat(dat)
    kable(head(datl))

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="left">vehicle</th>
<th align="left">geo</th>
<th align="right">time</th>
<th align="right">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Austria</td>
<td align="right">2013</td>
<td align="right">9.8</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Belgium</td>
<td align="right">2013</td>
<td align="right">15.2</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Bulgaria</td>
<td align="right">2013</td>
<td align="right">16.2</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Switzerland</td>
<td align="right">2013</td>
<td align="right">5.1</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Cyprus</td>
<td align="right">2013</td>
<td align="right">18.5</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Czech Republic</td>
<td align="right">2013</td>
<td align="right">17.9</td>
</tr>
</tbody>
</table>

The `label_eurostat()` allows also conversion of individual variable
vectors or variable names.

    label_eurostat_vars(names(datl))

    ## [1] "Unit of measure"                                                                     
    ## [2] "Vehicles"                                                                            
    ## [3] "Geopolitical entity (reporting)"                                                     
    ## [4] "Period of time (a=annual, q=quarterly, m=monthly, d=daily, c=cumulated from January)"

Vehicle information has 3 levels. They are:

    levels(datl$vehicle)

    ## [1] "Motor coaches, buses and trolley buses"
    ## [2] "Passenger cars"                        
    ## [3] "Trains"

<a name="select"></a>Selecting and modifying data
-------------------------------------------------

### EFTA, Eurozone, EU and EU candidate countries

To facilititate fast plotting of standard European geographic areas, the
package provides ready-made lists of the country codes used in the
eurostat database for EFTA (efta\_countries), Euro area (ea\_countries),
EU (eu\_countries) and EU candidate countries (candidate\_countries).
This helps to select specific groups of countries for closer
investigation. For conversions with other standard country coding
systems, see the [countrycode](...) R package. To retrieve the country
code list for EFTA, for instance, use:

    data(efta_countries)
    print(efta_countries)

    ##   code          name
    ## 1   IS       Iceland
    ## 2   LI Liechtenstein
    ## 3   NO        Norway
    ## 4   CH   Switzerland

### EU data from 2012 in all vehicles:

    dat_eu12 <- subset(datl, geo == "European Union (28 countries)" & time == 2012)
    kable(dat_eu12, row.names = FALSE)

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="left">vehicle</th>
<th align="left">geo</th>
<th align="right">time</th>
<th align="right">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2012</td>
<td align="right">9.3</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Passenger cars</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2012</td>
<td align="right">83.0</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Trains</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2012</td>
<td align="right">7.6</td>
</tr>
</tbody>
</table>

### EU data from 2000 - 2012 with vehicle types as variables:

Reshaping the data is best done with `spread()` in `tidyr`.

    library("tidyr")
    dat_eu_0012 <- subset(dat, geo == "EU28" & time %in% 2000:2012)
    dat_eu_0012_wide <- spread(dat_eu_0012, vehicle, values)
    kable(subset(dat_eu_0012_wide, select = -geo), row.names = FALSE)

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="right">time</th>
<th align="right">BUS_TOT</th>
<th align="right">CAR</th>
<th align="right">TRN</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2000</td>
<td align="right">10.4</td>
<td align="right">82.4</td>
<td align="right">7.2</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="right">2001</td>
<td align="right">10.2</td>
<td align="right">82.7</td>
<td align="right">7.1</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2002</td>
<td align="right">9.9</td>
<td align="right">83.3</td>
<td align="right">6.8</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="right">2003</td>
<td align="right">9.9</td>
<td align="right">83.5</td>
<td align="right">6.7</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2004</td>
<td align="right">9.8</td>
<td align="right">83.4</td>
<td align="right">6.8</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="right">2005</td>
<td align="right">9.9</td>
<td align="right">83.2</td>
<td align="right">6.9</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2006</td>
<td align="right">9.7</td>
<td align="right">83.2</td>
<td align="right">7.1</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="right">2007</td>
<td align="right">9.8</td>
<td align="right">83.1</td>
<td align="right">7.2</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2008</td>
<td align="right">9.7</td>
<td align="right">83.1</td>
<td align="right">7.3</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="right">2009</td>
<td align="right">9.2</td>
<td align="right">83.7</td>
<td align="right">7.1</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2010</td>
<td align="right">9.2</td>
<td align="right">83.6</td>
<td align="right">7.2</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="right">2011</td>
<td align="right">9.2</td>
<td align="right">83.4</td>
<td align="right">7.3</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="right">2012</td>
<td align="right">9.3</td>
<td align="right">83.0</td>
<td align="right">7.6</td>
</tr>
</tbody>
</table>

### Train passengers for selected EU countries in 2000 - 2012

    dat_trains <- subset(datl, geo %in% c("Austria", "Belgium", "Finland", "Sweden")
                         & time %in% 2000:2012 
                         & vehicle == "Trains")

    dat_trains_wide <- spread(dat_trains, geo, values) 
    kable(subset(dat_trains_wide, select = -vehicle), row.names = FALSE)

<table>
<thead>
<tr class="header">
<th align="left">unit</th>
<th align="right">time</th>
<th align="right">Austria</th>
<th align="right">Belgium</th>
<th align="right">Finland</th>
<th align="right">Sweden</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2000</td>
<td align="right">9.8</td>
<td align="right">6.3</td>
<td align="right">5.1</td>
<td align="right">7.5</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="right">2001</td>
<td align="right">9.7</td>
<td align="right">6.4</td>
<td align="right">4.8</td>
<td align="right">7.9</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2002</td>
<td align="right">9.7</td>
<td align="right">6.5</td>
<td align="right">4.8</td>
<td align="right">7.8</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="right">2003</td>
<td align="right">9.5</td>
<td align="right">6.5</td>
<td align="right">4.7</td>
<td align="right">7.7</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2004</td>
<td align="right">9.5</td>
<td align="right">7.1</td>
<td align="right">4.7</td>
<td align="right">7.5</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="right">2005</td>
<td align="right">9.8</td>
<td align="right">6.6</td>
<td align="right">4.8</td>
<td align="right">7.7</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2006</td>
<td align="right">10.0</td>
<td align="right">6.9</td>
<td align="right">4.8</td>
<td align="right">8.3</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="right">2007</td>
<td align="right">10.1</td>
<td align="right">7.1</td>
<td align="right">5.0</td>
<td align="right">8.7</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2008</td>
<td align="right">11.1</td>
<td align="right">7.5</td>
<td align="right">5.4</td>
<td align="right">9.4</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="right">2009</td>
<td align="right">11.1</td>
<td align="right">7.5</td>
<td align="right">5.1</td>
<td align="right">9.5</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2010</td>
<td align="right">11.0</td>
<td align="right">7.7</td>
<td align="right">5.2</td>
<td align="right">9.4</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="right">2011</td>
<td align="right">11.0</td>
<td align="right">7.7</td>
<td align="right">5.0</td>
<td align="right">8.8</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2012</td>
<td align="right">11.5</td>
<td align="right">7.4</td>
<td align="right">5.3</td>
<td align="right">9.1</td>
</tr>
</tbody>
</table>

<a name="visualization"></a>Visualization
-----------------------------------------

Visualizing train passenger data with `ggplot2`:

    library(ggplot2)
    p <- ggplot(dat_trains, aes(x = time, y = values, colour = geo)) 
    p <- p + geom_line()
    print(p)

![](fig/trains_plot-1.png)  
 \#\#\# <a name="triangle"></a>Triangle plot

Triangle plot on passenger transport distributions with 2012 data for
all countries with data.

    library(tidyr)

    transports <- spread(subset(dat, time == 2012, select = c(geo, vehicle, values)), vehicle, values)

    transports <- na.omit(transports)

    # triangle plot
    library(plotrix)
    triax.plot(transports[, -1], show.grid = TRUE, 
               label.points = TRUE, point.labels = transports$geo, 
               pch = 19)

![](fig/plotGallery-1.png)  
 For further examples, see also the [blog post on the eurostat R
package](...).

<a name="citing"></a>Citing the package
---------------------------------------

**Citing the Data** Kindly cite
[Eurostat](http://ec.europa.eu/eurostat/).

**Citing the R tools** This work can be freely used, modified and
distributed under the BSD-2-clause (modified FreeBSD) license:

    citation("eurostat")

    ## 
    ## Kindly cite the eurostat R package as follows:
    ## 
    ##   (C) Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek
    ##   2014-2016. eurostat R package URL:
    ##   https://github.com/rOpenGov/eurostat
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Misc{,
    ##     title = {eurostat R package},
    ##     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
    ##     year = {2014},
    ##     url = {https://github.com/rOpenGov/eurostat},
    ##   }

<a name="acknowledgements"></a>Acknowledgements
-----------------------------------------------

We are grateful to all
[contributors](https://github.com/rOpenGov/eurostat/graphs/contributors)
and [Eurostat](http://ec.europa.eu/eurostat/) open data portal! This
[rOpenGov](http://ropengov.github.io) R package is based on earlier CRAN
packages [statfi](https://cran.r-project.org/package=statfi) and
[smarterpoland](https://cran.r-project.org/package=SmarterPoland). The
[datamart](https://cran.r-project.org/package=datamart) and
[reurostat](https://github.com/Tungurahua/reurostat) packages seem to
develop related Eurostat tools but at the time of writing this tutorial
this package seems to be in an experimental stage. The
[quandl](https://cran.r-project.org/package=quandl) package may also
provides access to some versions of eurostat data sets.

<a name="session"></a>Session info
----------------------------------

This tutorial was created with

    sessionInfo()

    ## R version 3.2.2 (2015-08-14)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 15.10
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
    ## [1] plotrix_3.6-1        ggplot2_2.0.0        tidyr_0.3.1         
    ## [4] rvest_0.3.1          xml2_0.1.2           eurostat_1.2.13.9000
    ## [7] rmarkdown_0.9.4      knitr_1.12          
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.3      magrittr_1.5     munsell_0.4.2    colorspace_1.2-6
    ##  [5] R6_2.1.1         plyr_1.8.3       stringr_1.0.0    httr_1.0.0      
    ##  [9] highr_0.5.1      dplyr_0.4.3      tools_3.2.2      parallel_3.2.2  
    ## [13] grid_3.2.2       gtable_0.1.2     DBI_0.3.1        htmltools_0.3   
    ## [17] digest_0.6.9     assertthat_0.1   formatR_1.2.1    curl_0.9.4      
    ## [21] evaluate_0.8     labeling_0.3     stringi_1.0-1    scales_0.3.0    
    ## [25] jsonlite_0.9.19
