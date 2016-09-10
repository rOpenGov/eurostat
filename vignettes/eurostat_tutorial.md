R Tools for Eurostat Open Data
==============================

This [rOpenGov](http://ropengov.github.io) R package provides tools to
access [Eurostat database](http://ec.europa.eu/eurostat/). For contact
information and source code, see the
[README](https://github.com/rOpenGov/eurostat).

Installation
============

Release version
[(CRAN)](https://cran.r-project.org/web/packages/eurostat/index.html):

    install.packages("eurostat")

Development version [(Github)](https://github.com/rOpenGov/eurostat):

    library(devtools)
    install_github("ropengov/eurostat")

Overall, the eurostat package includes the following functions:

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
                            Downloads Preprocessed Geospatial Data from
                            CISGO
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

Finding data
============

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
<th align="left">last update of data</th>
<th align="left">last table structure change</th>
<th align="left">data start</th>
<th align="left">data end</th>
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
<td align="left">30.08.2016</td>
<td align="left">30.08.2016</td>
<td align="left">1985M01</td>
<td align="left">2016M08</td>
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
<th align="left">title</th>
<th align="left">code</th>
<th align="left">type</th>
<th align="left">last update of data</th>
<th align="left">last table structure change</th>
<th align="left">data start</th>
<th align="left">data end</th>
<th align="left">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Volume of passenger transport relative to GDP</td>
<td align="left">tran_hv_pstra</td>
<td align="left">dataset</td>
<td align="left">03.08.2016</td>
<td align="left">03.08.2016</td>
<td align="left">2000</td>
<td align="left">2014</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Modal split of passenger transport</td>
<td align="left">tran_hv_psmod</td>
<td align="left">dataset</td>
<td align="left">03.08.2016</td>
<td align="left">02.08.2016</td>
<td align="left">1990</td>
<td align="left">2014</td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">Railway transport - Total annual passenger transport (1 000 pass., million pkm)</td>
<td align="left">rail_pa_total</td>
<td align="left">dataset</td>
<td align="left">06.09.2016</td>
<td align="left">26.05.2016</td>
<td align="left">2004</td>
<td align="left">2015</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">International railway passenger transport from the reporting country to the country of disembarkation (1 000 passengers)</td>
<td align="left">rail_pa_intgong</td>
<td align="left">dataset</td>
<td align="left">06.09.2016</td>
<td align="left">26.05.2016</td>
<td align="left">2002</td>
<td align="left">2015</td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">International railway passenger transport from the country of embarkation to the reporting country (1 000 passengers)</td>
<td align="left">rail_pa_intcmng</td>
<td align="left">dataset</td>
<td align="left">06.09.2016</td>
<td align="left">26.05.2016</td>
<td align="left">2002</td>
<td align="left">2015</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Air passenger transport by reporting country</td>
<td align="left">avia_paoc</td>
<td align="left">dataset</td>
<td align="left">15.07.2016</td>
<td align="left">14.07.2016</td>
<td align="left">1993</td>
<td align="left">2016Q1</td>
<td align="left">NA</td>
</tr>
</tbody>
</table>

Codes for the dataset can be searched also from the [Eurostat
database](http://ec.europa.eu/eurostat/data/database). The Eurostat
database gives codes in the Data Navigation Tree after every dataset in
parenthesis.

Downloading data
================

The package supports two of the Eurostats download methods: the bulk
download facility and the Web Services' JSON API. The bulk download
facility is the fastest method to download whole datasets. It is also
often the only way as the JSON API has limitation of maximum 50
sub-indicators at a time and whole datasets usually exceeds that. To
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

\[1\] "tsdtr210"

Get the whole corresponding table. As the table is annual data, it is
more convient to use a numeric time variable than use the default date
format:

    dat <- get_eurostat(id, time_format = "num")

Investigate the structure of the downloaded data set:

    str(dat)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    2326 obs. of  5 variables:
    ##  $ unit   : Factor w/ 1 level "PC": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ vehicle: Factor w/ 3 levels "BUS_TOT","CAR",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ geo    : Factor w/ 35 levels "AT","BE","CH",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ time   : num  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ values : num  11 10.6 3.7 9.1 11.3 32.4 14.9 13.5 6 24.8 ...

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
<td align="right">1990</td>
<td align="right">11.0</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">BE</td>
<td align="right">1990</td>
<td align="right">10.6</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">CH</td>
<td align="right">1990</td>
<td align="right">3.7</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">DE</td>
<td align="right">1990</td>
<td align="right">9.1</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">DK</td>
<td align="right">1990</td>
<td align="right">11.3</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">EL</td>
<td align="right">1990</td>
<td align="right">32.4</td>
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
<td align="right">2014</td>
<td align="right">9.1</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">BUS_TOT</td>
<td align="left">FI</td>
<td align="right">2014</td>
<td align="right">9.8</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">CAR</td>
<td align="left">EU28</td>
<td align="right">2014</td>
<td align="right">83.4</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">CAR</td>
<td align="left">FI</td>
<td align="right">2014</td>
<td align="right">85.2</td>
</tr>
<tr class="odd">
<td align="left">PC</td>
<td align="left">TRN</td>
<td align="left">EU28</td>
<td align="right">2014</td>
<td align="right">7.6</td>
</tr>
<tr class="even">
<td align="left">PC</td>
<td align="left">TRN</td>
<td align="left">FI</td>
<td align="right">2014</td>
<td align="right">5.0</td>
</tr>
</tbody>
</table>

Replacing codes with labels
---------------------------

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
<td align="right">2014</td>
<td align="right">9.1</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Finland</td>
<td align="right">2014</td>
<td align="right">9.8</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Passenger cars</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2014</td>
<td align="right">83.4</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Passenger cars</td>
<td align="left">Finland</td>
<td align="right">2014</td>
<td align="right">85.2</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Trains</td>
<td align="left">European Union (28 countries)</td>
<td align="right">2014</td>
<td align="right">7.6</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Trains</td>
<td align="left">Finland</td>
<td align="right">2014</td>
<td align="right">5.0</td>
</tr>
</tbody>
</table>

Eurostat codes in the downloaded data set can be replaced with
human-readable labels from the Eurostat dictionaries with the
`label_eurostat()` function.

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
<td align="right">1990</td>
<td align="right">11.0</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Belgium</td>
<td align="right">1990</td>
<td align="right">10.6</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Switzerland</td>
<td align="right">1990</td>
<td align="right">3.7</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Germany (until 1990 former territory of the FRG)</td>
<td align="right">1990</td>
<td align="right">9.1</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Denmark</td>
<td align="right">1990</td>
<td align="right">11.3</td>
</tr>
<tr class="even">
<td align="left">Percentage</td>
<td align="left">Motor coaches, buses and trolley buses</td>
<td align="left">Greece</td>
<td align="right">1990</td>
<td align="right">32.4</td>
</tr>
</tbody>
</table>

The `label_eurostat()` allows conversion of individual variable vectors
or variable names as well.

    label_eurostat_vars(names(datl))

Vehicle information has 3 levels. You can check them now with:

    levels(datl$vehicle)

Selecting and modifying data
============================

EFTA, Eurozone, EU and EU candidate countries
---------------------------------------------

To facilitate smooth visualization of standard European geographic
areas, the package provides ready-made lists of the country codes used
in the eurostat database for EFTA (efta\_countries), Euro area
(ea\_countries), EU (eu\_countries) and EU candidate countries
(eu\_candidate\_countries). These can be used to select specific groups
of countries for closer investigation. For conversions with other
standard country coding systems, see the [countrycode](...) R package.
To retrieve the country code list for EFTA, for instance, use:

    data(efta_countries)
    kable(efta_countries)

<table>
<thead>
<tr class="header">
<th align="left">code</th>
<th align="left">name</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">IS</td>
<td align="left">Iceland</td>
</tr>
<tr class="even">
<td align="left">LI</td>
<td align="left">Liechtenstein</td>
</tr>
<tr class="odd">
<td align="left">NO</td>
<td align="left">Norway</td>
</tr>
<tr class="even">
<td align="left">CH</td>
<td align="left">Switzerland</td>
</tr>
</tbody>
</table>

EU data from 2012 in all vehicles:
----------------------------------

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
<td align="right">7.7</td>
</tr>
</tbody>
</table>

EU data from 2000 - 2012 with vehicle types as variables:
---------------------------------------------------------

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
<td align="right">7.7</td>
</tr>
</tbody>
</table>

Train passengers for selected EU countries in 2000 - 2012
---------------------------------------------------------

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
<td align="right">9.7</td>
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
<td align="right">9.4</td>
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
<td align="right">10.0</td>
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
<td align="right">11.3</td>
<td align="right">7.7</td>
<td align="right">5.0</td>
<td align="right">8.8</td>
</tr>
<tr class="odd">
<td align="left">Percentage</td>
<td align="right">2012</td>
<td align="right">11.8</td>
<td align="right">7.8</td>
<td align="right">5.3</td>
<td align="right">9.1</td>
</tr>
</tbody>
</table>

Visualization
=============

Visualizing train passenger data with `ggplot2`:

    library(ggplot2)
    p <- ggplot(dat_trains, aes(x = time, y = values, colour = geo)) 
    p <- p + geom_line()
    print(p)

![](fig/trains_plot-1.png)

<a name="triangle"></a>**Triangle plot**

Triangle plot is handy for visualizing data sets with three variables.
For instance, the passenger transport distributions across three vehicle
types in 2012 for all countries where data is available:

    library(tidyr)

    # Download and modify the transport data
    transports <- spread(subset(dat, time == 2012, select = c(geo, vehicle, values)), vehicle, values)

    # Remove countries with missing data
    transports <- na.omit(transports)

    # Use triangle plot to visualize vehicle distributions:
    library(plotrix)
    triax.plot(transports[, -1], show.grid = TRUE, 
               label.points = TRUE, point.labels = transports$geo, 
               pch = 19)

![](fig/plotGallery-1.png)

Maps
----

**Quick demo1 - whole Europe at country level resolution 1:60mln**

    # Data from Eurostat
    eurostat::get_eurostat(id = "tsdtr420", time_format = "num") %>% 
      # subset to have only a single row per geo
      dplyr::filter(sex == "T", time %in% 2014) %>% 
      # merge with geodata
      merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "60") %>% 
      # plot map
      ggplot(data=., aes(x=long,y=lat,group=group)) +
      geom_polygon(aes(fill=values),color="white")

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/tsdtr420_num_code_TF.rds

    ## Table  tsdtr420  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/tsdtr420_num_code_TF.rds

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

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/df60.RData

    ## data_frame at resolution 1: 60  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/df60.RData

![](fig/maps7-1.png)

**Quick demo2 - Poland at NUTS3 level reso 1:1mln**

    # Data from Eurostat
    eurostat::get_eurostat("tgs00026", time_format = "raw") %>% 
      # subset to have only a single row per geo
      dplyr::filter(time == 2010, grepl("PL",geo), nchar(as.character(geo)) == 4) %>% 
      # merge with geodata
      merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "01") %>% 
      # plot map
      ggplot(data=., aes(x=long,y=lat,group=group)) +
      geom_polygon(aes(fill=values),color="white")

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

    ## Table  tgs00026  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

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

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/df01.RData

    ## data_frame at resolution 1: 01  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/df01.RData

![](fig/maps8-1.png)

**Quick demo3 - whole Europe at country level reso 1:60mln**

    # Data from Eurostat
    eurostat::get_eurostat(id = "tsdtr420", time_format = "num") %>% 
      # subset to have only a single row per geo
      dplyr::filter(sex == "T", time == 2014) %>% 
      # categorise
      dplyr::mutate(cat = cut_to_classes(values)) %>% 
      # merge with geodata
      merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "60") %>% 
      # plot map
      ggplot(data=., aes(x=long,y=lat,group=group)) +
      geom_polygon(aes(fill=cat),color="white") +
      scale_fill_brewer(palette ="Oranges")

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/tsdtr420_num_code_TF.rds

    ## Table  tsdtr420  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/tsdtr420_num_code_TF.rds

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

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/df60.RData

    ## data_frame at resolution 1: 60  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/df60.RData

![](fig/maps1-1.png)

**Quick demo4 - Poland at NUTS3 level reso 1:1mln**

    eurostat::get_eurostat("tgs00026", time_format = "raw") %>% 
      # subset to have only a single row per geo
      dplyr::filter(time == 2010, grepl("PL",geo), nchar(as.character(geo)) == 4) %>% 
      # categorise
      dplyr::mutate(cat = cut_to_classes(values, n = 3)) %>% 
      # merge with geodata
      merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "01") %>% 
      # plot map
      ggplot(data=., aes(x=long,y=lat,group=group)) +
      geom_polygon(aes(fill=cat),color="white") +
      scale_fill_brewer(palette ="Oranges")

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

    ## Table  tgs00026  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

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

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/df01.RData

    ## data_frame at resolution 1: 01  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/df01.RData

![](fig/maps2-1.png)

**Reproducing the map in the journal manuscript**

    library(eurostat)
    library(RColorBrewer)
    # Downloading and manipulating the tabular data
    get_eurostat("tgs00026", time_format = "raw") %>% 
      # subsetting to year 2005 and NUTS-3 level
      dplyr::filter(time == 2005, nchar(as.character(geo)) == 4) %>% 
      # categorise
      dplyr::mutate(cat = cut_to_classes(values)) %>% 
      # merge with geodata
      merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "60") %>% 
      # plot map
      ggplot(data=., aes(long,lat,group=group)) + 
        geom_polygon(aes(fill = cat),colour=alpha("white", 1/2),size=.2) +
        scale_fill_manual(values=c("dim grey",brewer.pal(n = 5, name = "Oranges"))) +
        coord_map(project="orthographic", xlim=c(-22,34), ylim=c(35,70)) +
        labs(title = paste0("Disposable household incomes in 2005")) +
        theme(legend.position = c(0.03,0.40), 
                    legend.justification=c(0,0),
                    legend.key.size=unit(6,'mm'),
                    legend.direction = "vertical",
                    legend.background=element_rect(colour=NA, fill=alpha("white", 2/3)),
                    legend.text=element_text(size=12), 
                    legend.title=element_text(size=12), 
                    title=element_text(size=16), 
                    panel.background = element_blank(), 
                    plot.background = element_blank(),
                    panel.grid.minor = element_line(colour = 'Grey80', size = .5, linetype = 'solid'),
                    panel.grid.major = element_line(colour = 'Grey80', size = .5, linetype = 'solid'),
                    axis.text = element_blank(), 
                    axis.title = element_blank(), 
                    axis.ticks = element_blank(), 
                    plot.margin = unit(c(-3,-1.5, -3, -1.5), "cm")) +
        guides(fill = guide_legend(title = "EUR per Year",title.position = "top", title.hjust=0))

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

    ## Table  tgs00026  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

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

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/df60.RData

    ## data_frame at resolution 1: 60  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/df60.RData

    ## Warning in grid.Call.graphics(L_polygon, x$x, x$y, index): semi-
    ## transparency is not supported on this device: reported only once per page

![](fig/maps4-1.png)

**Poland with labels**

    library(eurostat)
    # Downloading and manipulating the tabular data
    df <- get_eurostat("tgs00026", time_format = "raw") %>% 
      # subsetting to year 2005 and NUTS-3 level
      dplyr::filter(time == 2005, nchar(as.character(geo)) == 4, grepl("PL",geo))

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

    ## Table  tgs00026  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/tgs00026_raw_code_TF.rds

    df_lab <- label_eurostat(df)
    names(df_lab) <- paste0("lab",names(df_lab))

    df2 <- cbind(df,df_lab)

    # categorise
    df2$cat <- cut_to_classes(df2$values)

    # merge with geodata
    plot_map <- merge_eurostat_geodata(data=df2,geocolumn="geo",resolution = "60")

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

    ## Reading cache file /tmp/RtmpIJ2Sv6/eurostat/df60.RData

    ## data_frame at resolution 1: 60  read from cache file:  /tmp/RtmpIJ2Sv6/eurostat/df60.RData

    cnames <- stats:::aggregate.formula(cbind(long, lat) ~ labgeo, data=plot_map, mean) # region names
    cnames <- merge(cnames,df2,by="labgeo")

    # plot map
    p <- ggplot(data=plot_map, aes(long,lat,group=group))
    p <- p + geom_polygon(aes(fill = cat),colour="white",size=.8)
    p <- p + scale_fill_manual(values=brewer.pal(n = 5, name = "Oranges"))
    p <- p + geom_label(data=cnames, aes(long, lat, label = paste(labgeo,"\n",values,"€"), group=labgeo,fill=cat), 
                        size=3.5, color="white", fontface="bold", lineheight=.8, show.legend=FALSE)
    p <- p + coord_map(project="orthographic")
    p <- p + labs(title = paste0("Disposable household incomes in 2005"))
    p <- p +  theme(legend.position = c(0.1,0.03), 
                    legend.justification=c(0,0),
                    legend.key.size=unit(6,'mm'),
                    legend.direction = "vertical",
                    legend.background=element_rect(colour=NA, fill=alpha("white", 2/3)),
                    legend.text=element_text(size=12), 
                    legend.title=element_text(size=12), 
                    title=element_text(size=16), 
                    panel.background = element_blank(), 
                    plot.background = element_blank(),
                    panel.grid.minor = element_line(colour = 'Grey80', size = .5, linetype = 'solid'),
                    panel.grid.major = element_line(colour = 'Grey80', size = .5, linetype = 'solid'),
                    axis.text = element_blank(), 
                    axis.title = element_blank(), 
                    axis.ticks = element_blank(), 
                    plot.margin = unit(c(-3,-1.5, -3, -1.5), "cm"))
    p <- p + guides(fill = guide_legend(title = "EUR per Year",
                                        title.position = "top", 
                                        title.hjust=0))
    p

    ## Warning in grid.Call.graphics(L_rect, x$x, x$y, x$width, x$height,
    ## resolveHJust(x$just, : semi-transparency is not supported on this device:
    ## reported only once per page

![](fig/maps6-1.png)

Further examples
================

For further examples, see:

-   [Blog
    post](http://ropengov.github.io/r/2015/05/01/eurostat-package-examples/)
-   [Journal
    manuscript](https://github.com/rOpenGov/eurostat/blob/master/vignettes/2015-RJournal/lahti-huovari-kainu-biecek.md)

Citations and related work
==========================

### Citing the data sources

Eurostat data: cite [Eurostat](http://ec.europa.eu/eurostat/).

Administrative boundaries: cite EuroGeographics

### Citing the eurostat R package

For main developers and contributors, see the [README](../README.md).

This work can be freely used, modified and distributed under the
BSD-2-clause (modified FreeBSD) license:

    citation("eurostat")

    ## 
    ## Kindly cite the eurostat R package as follows:
    ## 
    ##   (C) Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek
    ##   2014-2016. eurostat R package. R package version 2.0.1 URL:
    ##   https://github.com/rOpenGov/eurostat
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Misc{,
    ##     title = {eurostat R package},
    ##     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
    ##     year = {2014-2016},
    ##     url = {https://github.com/rOpenGov/eurostat},
    ##     note = {R package version 2.0.1},
    ##   }

### Related work

This [rOpenGov](http://ropengov.github.io) R package is based on the
earlier CRAN packages
[statfi](https://cran.r-project.org/package=statfi) and
[smarterpoland](https://cran.r-project.org/package=SmarterPoland).

The independent [reurostat](https://github.com/Tungurahua/reurostat)
package develops related Eurostat tools but seems to be in an
experimental stage at the time of writing this tutorial.

The more generic [quandl](https://cran.r-project.org/package=quandl),
[datamart](https://cran.r-project.org/package=datamart), and
[datamart](https://cran.r-project.org/package=pdfetch) packages may
provide access to some versions of eurostat data but these packages are
more generic and hence, in contrast to the eurostat R package, lack
tools that are specifically customized to facilitate eurostat analysis.

### Contact

For contact information, see the [README](../README.md).

Version info
============

This tutorial was created with

    sessionInfo()

    ## R version 3.3.1 (2016-06-21)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 16.04 LTS
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
    ## [1] RColorBrewer_1.1-2 plotrix_3.6-2      ggplot2_2.1.0     
    ## [4] tidyr_0.5.1        rvest_0.3.2        xml2_1.0.0        
    ## [7] eurostat_2.0.1     rmarkdown_0.9.6.14 knitr_1.13        
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.7      formatR_1.4      highr_0.6        plyr_1.8.4      
    ##  [5] class_7.3-14     tools_3.3.1      digest_0.6.9     jsonlite_1.0    
    ##  [9] evaluate_0.9     tibble_1.1       gtable_0.2.0     lattice_0.20-33 
    ## [13] DBI_0.4-1        mapproj_1.2-4    curl_0.9.7       yaml_2.1.13     
    ## [17] e1071_1.6-7      httr_1.2.1       stringr_1.0.0    dplyr_0.5.0     
    ## [21] maps_3.1.0       classInt_0.1-23  grid_3.3.1       R6_2.1.2        
    ## [25] sp_1.2-3         readr_0.2.2      magrittr_1.5     scales_0.4.0    
    ## [29] htmltools_0.3.5  assertthat_0.1   colorspace_1.2-6 labeling_0.3    
    ## [33] stringi_1.1.1    lazyeval_0.2.0   munsell_0.4.3
