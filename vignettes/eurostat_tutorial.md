R Tools for Eurostat Open Data
==============================

This [rOpenGov](http://ropengov.github.io) R package provides tools to
access [Eurostat database](http://ec.europa.eu/eurostat/data/database),
which you can also browse on-line for the data sets and documentation.
For contact information and source code, see the [package
website](http://ropengov.github.io/eurostat/).

Installation
============

Release version [(CRAN)](https://CRAN.R-project.org/package=eurostat):

    install.packages("eurostat")

Development version [(Github)](https://github.com/rOpenGov/eurostat):

    library(devtools)
    install_github("ropengov/eurostat")

Overall, the eurostat package includes the following functions:

    evaluate <- curl::has_internet()

Finding data
============

Function `get_eurostat_toc()` downloads a table of contents of eurostat
datasets. The values in column ‘code’ should be used to download a
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
<th style="text-align: left;">title</th>
<th style="text-align: left;">code</th>
<th style="text-align: left;">type</th>
<th style="text-align: left;">last update of data</th>
<th style="text-align: left;">last table structure change</th>
<th style="text-align: left;">data start</th>
<th style="text-align: left;">data end</th>
<th style="text-align: left;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Database by themes</td>
<td style="text-align: left;">data</td>
<td style="text-align: left;">folder</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">General and regional statistics</td>
<td style="text-align: left;">general</td>
<td style="text-align: left;">folder</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">European and national indicators for short-term analysis</td>
<td style="text-align: left;">euroind</td>
<td style="text-align: left;">folder</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Business and consumer surveys (source: DG ECFIN)</td>
<td style="text-align: left;">ei_bcs</td>
<td style="text-align: left;">folder</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Consumer surveys (source: DG ECFIN)</td>
<td style="text-align: left;">ei_bcs_cs</td>
<td style="text-align: left;">folder</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Consumers - monthly data</td>
<td style="text-align: left;">ei_bsco_m</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">28.11.2019</td>
<td style="text-align: left;">28.11.2019</td>
<td style="text-align: left;">1980M01</td>
<td style="text-align: left;">2019M11</td>
<td style="text-align: left;">NA</td>
</tr>
</tbody>
</table>

With `search_eurostat()` you can search the table of contents for
particular patterns, e.g. all datasets related to *passenger transport*.
The kable function to produces nice markdown output. Note that with the
`type` argument of this function you could restrict the search to for
instance datasets or tables.

    # info about passengers
    kable(head(search_eurostat("passenger transport")))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">title</th>
<th style="text-align: left;">code</th>
<th style="text-align: left;">type</th>
<th style="text-align: left;">last update of data</th>
<th style="text-align: left;">last table structure change</th>
<th style="text-align: left;">data start</th>
<th style="text-align: left;">data end</th>
<th style="text-align: left;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Volume of passenger transport relative to GDP</td>
<td style="text-align: left;">tran_hv_pstra</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">12.09.2019</td>
<td style="text-align: left;">12.09.2019</td>
<td style="text-align: left;">2000</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Modal split of passenger transport</td>
<td style="text-align: left;">tran_hv_psmod</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">09.09.2019</td>
<td style="text-align: left;">09.09.2019</td>
<td style="text-align: left;">1990</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Air passenger transport by reporting country</td>
<td style="text-align: left;">avia_paoc</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">05.12.2019</td>
<td style="text-align: left;">07.11.2019</td>
<td style="text-align: left;">1993</td>
<td style="text-align: left;">2019Q3</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Air passenger transport by main airports in each reporting country</td>
<td style="text-align: left;">avia_paoa</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">04.12.2019</td>
<td style="text-align: left;">04.12.2019</td>
<td style="text-align: left;">1993</td>
<td style="text-align: left;">2019Q3</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Air passenger transport between reporting countries</td>
<td style="text-align: left;">avia_paocc</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">05.12.2019</td>
<td style="text-align: left;">07.11.2019</td>
<td style="text-align: left;">1993</td>
<td style="text-align: left;">2019Q3</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Air passenger transport between main airports in each reporting country and partner reporting countries</td>
<td style="text-align: left;">avia_paoac</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">07.11.2019</td>
<td style="text-align: left;">07.11.2019</td>
<td style="text-align: left;">1993</td>
<td style="text-align: left;">2019Q3</td>
<td style="text-align: left;">NA</td>
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
download facility and the Web Services’ JSON API. The bulk download
facility is the fastest method to download whole datasets. It is also
often the only way as the JSON API has limitation of maximum 50
sub-indicators at a time and whole datasets usually exceeds that. To
download only a small section of the dataset the JSON API is faster, as
it allows to make a data selection before downloading.

A user does not usually have to bother with methods, as both are used
via main function `get_eurostat()`. If only the table id is given, the
whole table is downloaded from the bulk download facility. If also
filters are defined the JSON API is used.

Here an example of indicator ‘Modal split of passenger transport’. This
is the percentage share of each mode of transport in total inland
transport, expressed in passenger-kilometres (pkm) based on transport by
passenger cars, buses and coaches, and trains. All data should be based
on movements on national territory, regardless of the nationality of the
vehicle. However, the data collection is not harmonized at the EU level.

Pick and print the id of the data set to download:

    # For the original data, see
    # http://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&language=en&pcode=tsdtr210
    id <- search_eurostat("Modal split of passenger transport", 
                             type = "table")$code[1]
    print(id)

\[1\] “t2020\_rk310”

Get the whole corresponding table. As the table is annual data, it is
more convient to use a numeric time variable than use the default date
format:

    dat <- get_eurostat(id, time_format = "num")

Investigate the structure of the downloaded data set:

    str(dat)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    2587 obs. of  5 variables:
    ##  $ unit   : Factor w/ 1 level "PC": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ vehicle: Factor w/ 3 levels "BUS_TOT","CAR",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ geo    : Factor w/ 34 levels "AT","BE","CH",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ time   : num  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ values : num  11 10.6 3.7 9.1 11.3 32.4 14.9 13.5 6 24.8 ...

    kable(head(dat))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">unit</th>
<th style="text-align: left;">vehicle</th>
<th style="text-align: left;">geo</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">AT</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">11.0</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">BE</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">10.6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">CH</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">3.7</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">DE</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">9.1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">DK</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">11.3</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">EL</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">32.4</td>
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
<th style="text-align: left;">unit</th>
<th style="text-align: left;">vehicle</th>
<th style="text-align: left;">geo</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">EU28</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">8.8</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">BUS_TOT</td>
<td style="text-align: left;">FI</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">10.4</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">CAR</td>
<td style="text-align: left;">EU28</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">83.3</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">CAR</td>
<td style="text-align: left;">FI</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">84.2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">TRN</td>
<td style="text-align: left;">EU28</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">7.9</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: left;">TRN</td>
<td style="text-align: left;">FI</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">5.4</td>
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
<th style="text-align: left;">unit</th>
<th style="text-align: left;">vehicle</th>
<th style="text-align: left;">geo</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">European Union - 28 countries</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">8.8</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Finland</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">10.4</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Passenger cars</td>
<td style="text-align: left;">European Union - 28 countries</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">83.3</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Passenger cars</td>
<td style="text-align: left;">Finland</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">84.2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Trains</td>
<td style="text-align: left;">European Union - 28 countries</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">7.9</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Trains</td>
<td style="text-align: left;">Finland</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">5.4</td>
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
<th style="text-align: left;">unit</th>
<th style="text-align: left;">vehicle</th>
<th style="text-align: left;">geo</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Austria</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">11.0</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Belgium</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">10.6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Switzerland</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">3.7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Germany (until 1990 former territory of the FRG)</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">9.1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Denmark</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">11.3</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">Greece</td>
<td style="text-align: right;">1990</td>
<td style="text-align: right;">32.4</td>
</tr>
</tbody>
</table>

The `label_eurostat()` allows conversion of individual variable vectors
or variable names as well.

    label_eurostat_vars(names(datl))

    ## [1] "Unit of measure"                                                                     
    ## [2] "Vehicles"                                                                            
    ## [3] "Geopolitical entity (reporting)"                                                     
    ## [4] "Period of time (a=annual, q=quarterly, m=monthly, d=daily, c=cumulated from January)"

Vehicle information has 3 levels. You can check them now with:

    levels(datl$vehicle)

    ## [1] "Motor coaches, buses and trolley buses"
    ## [2] "Passenger cars"                        
    ## [3] "Trains"

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
standard country coding systems, see the
[countrycode](https://CRAN.R-project.org/package=countrycode) R package.
To retrieve the country code list for EFTA, for instance, use:

    data(efta_countries)
    kable(efta_countries)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">code</th>
<th style="text-align: left;">name</th>
<th style="text-align: left;">label</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">IS</td>
<td style="text-align: left;">Iceland</td>
<td style="text-align: left;">Iceland</td>
</tr>
<tr class="even">
<td style="text-align: left;">LI</td>
<td style="text-align: left;">Liechtenstein</td>
<td style="text-align: left;">Liechtenstein</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NO</td>
<td style="text-align: left;">Norway</td>
<td style="text-align: left;">Norway</td>
</tr>
<tr class="even">
<td style="text-align: left;">CH</td>
<td style="text-align: left;">Switzerland</td>
<td style="text-align: left;">Switzerland</td>
</tr>
</tbody>
</table>

EU data from 2012 in all vehicles:
----------------------------------

    dat_eu12 <- subset(datl, geo == "European Union - 28 countries" & time == 2012)
    kable(dat_eu12, row.names = FALSE)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">unit</th>
<th style="text-align: left;">vehicle</th>
<th style="text-align: left;">geo</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Motor coaches, buses and trolley buses</td>
<td style="text-align: left;">European Union - 28 countries</td>
<td style="text-align: right;">2012</td>
<td style="text-align: right;">9.5</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Passenger cars</td>
<td style="text-align: left;">European Union - 28 countries</td>
<td style="text-align: right;">2012</td>
<td style="text-align: right;">82.8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: left;">Trains</td>
<td style="text-align: left;">European Union - 28 countries</td>
<td style="text-align: right;">2012</td>
<td style="text-align: right;">7.7</td>
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
<th style="text-align: left;">unit</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">BUS_TOT</th>
<th style="text-align: right;">CAR</th>
<th style="text-align: right;">TRN</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2000</td>
<td style="text-align: right;">10.4</td>
<td style="text-align: right;">82.5</td>
<td style="text-align: right;">7.1</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2001</td>
<td style="text-align: right;">10.2</td>
<td style="text-align: right;">82.8</td>
<td style="text-align: right;">7.0</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2002</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">83.4</td>
<td style="text-align: right;">6.8</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2003</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">83.6</td>
<td style="text-align: right;">6.6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2004</td>
<td style="text-align: right;">9.7</td>
<td style="text-align: right;">83.5</td>
<td style="text-align: right;">6.7</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2005</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">83.4</td>
<td style="text-align: right;">6.9</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2006</td>
<td style="text-align: right;">9.6</td>
<td style="text-align: right;">83.4</td>
<td style="text-align: right;">7.0</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2007</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">83.1</td>
<td style="text-align: right;">7.1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2008</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">82.9</td>
<td style="text-align: right;">7.4</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2009</td>
<td style="text-align: right;">9.2</td>
<td style="text-align: right;">83.7</td>
<td style="text-align: right;">7.1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2010</td>
<td style="text-align: right;">9.4</td>
<td style="text-align: right;">83.5</td>
<td style="text-align: right;">7.2</td>
</tr>
<tr class="even">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2011</td>
<td style="text-align: right;">9.4</td>
<td style="text-align: right;">83.2</td>
<td style="text-align: right;">7.4</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PC</td>
<td style="text-align: right;">2012</td>
<td style="text-align: right;">9.5</td>
<td style="text-align: right;">82.8</td>
<td style="text-align: right;">7.7</td>
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
<th style="text-align: left;">unit</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">Austria</th>
<th style="text-align: right;">Belgium</th>
<th style="text-align: right;">Finland</th>
<th style="text-align: right;">Sweden</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2000</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">6.3</td>
<td style="text-align: right;">5.1</td>
<td style="text-align: right;">6.9</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2001</td>
<td style="text-align: right;">9.7</td>
<td style="text-align: right;">6.4</td>
<td style="text-align: right;">4.8</td>
<td style="text-align: right;">7.3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2002</td>
<td style="text-align: right;">9.7</td>
<td style="text-align: right;">6.5</td>
<td style="text-align: right;">4.8</td>
<td style="text-align: right;">7.2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2003</td>
<td style="text-align: right;">9.5</td>
<td style="text-align: right;">6.5</td>
<td style="text-align: right;">4.7</td>
<td style="text-align: right;">7.1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2004</td>
<td style="text-align: right;">9.5</td>
<td style="text-align: right;">7.1</td>
<td style="text-align: right;">4.7</td>
<td style="text-align: right;">6.9</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2005</td>
<td style="text-align: right;">9.8</td>
<td style="text-align: right;">6.6</td>
<td style="text-align: right;">4.8</td>
<td style="text-align: right;">7.1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2006</td>
<td style="text-align: right;">10.0</td>
<td style="text-align: right;">6.9</td>
<td style="text-align: right;">4.8</td>
<td style="text-align: right;">7.7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2007</td>
<td style="text-align: right;">10.0</td>
<td style="text-align: right;">7.1</td>
<td style="text-align: right;">5.0</td>
<td style="text-align: right;">8.0</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2008</td>
<td style="text-align: right;">11.1</td>
<td style="text-align: right;">7.5</td>
<td style="text-align: right;">5.4</td>
<td style="text-align: right;">8.7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2009</td>
<td style="text-align: right;">11.1</td>
<td style="text-align: right;">7.5</td>
<td style="text-align: right;">5.1</td>
<td style="text-align: right;">8.8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2010</td>
<td style="text-align: right;">11.0</td>
<td style="text-align: right;">7.7</td>
<td style="text-align: right;">5.2</td>
<td style="text-align: right;">8.7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2011</td>
<td style="text-align: right;">11.3</td>
<td style="text-align: right;">7.7</td>
<td style="text-align: right;">5.0</td>
<td style="text-align: right;">8.7</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Percentage</td>
<td style="text-align: right;">2012</td>
<td style="text-align: right;">11.8</td>
<td style="text-align: right;">7.8</td>
<td style="text-align: right;">5.3</td>
<td style="text-align: right;">9.1</td>
</tr>
</tbody>
</table>

SDMX
----

Eurostat data is available also in the SDMX format. The eurostat R
package does not provide custom tools for this but the generic
[rsdmx](https://CRAN.R-project.org/package=rsdmx) and
[rjsdmx](https://github.com/amattioc/SDMX/wiki) R packages can be used
to access data in that format when necessary.

Further examples
================

For further examples, see the [package
homepage](http://ropengov.github.io/eurostat/articles/index.html).

Citations and related work
==========================

### Citing the data sources

Eurostat data: cite [Eurostat](http://ec.europa.eu/eurostat/).

Administrative boundaries: cite EuroGeographics

### Citing the eurostat R package

For main developers and contributors, see the [package
homepage](http://ropengov.github.io/eurostat).

This work can be freely used, modified and distributed under the
BSD-2-clause (modified FreeBSD) license:

    citation("eurostat")

    ## 
    ## Kindly cite the eurostat R package as follows:
    ## 
    ##   (C) Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek.
    ##   Retrieval and analysis of Eurostat open data with the eurostat
    ##   package. R Journal 9(1):385-392, 2017. Version 3.4.10002 Package URL:
    ##   http://ropengov.github.io/eurostat Manuscript URL:
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
    ##     note = {Version 3.4.10002},
    ##   }

### Contact

For contact information, see the [package
homepage](http://ropengov.github.io/eurostat).

Version info
============

This tutorial was created with

    sessionInfo()

    ## R version 3.5.2 (2018-12-20)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 19.04
    ## 
    ## Matrix products: default
    ## BLAS: /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.8.0
    ## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.8.0
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
    ## [1] tidyr_1.0.0        rvest_0.3.5        xml2_1.2.2         rmarkdown_2.0     
    ## [5] pkgdown_1.4.1      knitr_1.26         eurostat_3.4.10002 devtools_2.2.1    
    ## [9] usethis_1.5.1     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.3         lubridate_1.7.4    countrycode_1.1.0  lattice_0.20-38   
    ##  [5] prettyunits_1.0.2  class_7.3-15       ps_1.3.0           assertthat_0.2.1  
    ##  [9] zeallot_0.1.0      rprojroot_1.3-2    digest_0.6.23      R6_2.4.1          
    ## [13] plyr_1.8.5         backports_1.1.5    evaluate_0.14      e1071_1.7-3       
    ## [17] highr_0.8          httr_1.4.1         pillar_1.4.2       rlang_0.4.2       
    ## [21] curl_4.3           rstudioapi_0.10    callr_3.4.0        desc_1.2.0        
    ## [25] RefManageR_1.2.12  readr_1.3.1        stringr_1.4.0      broom_0.5.3       
    ## [29] compiler_3.5.2     xfun_0.11          pkgconfig_2.0.3    pkgbuild_1.0.6    
    ## [33] htmltools_0.4.0    tidyselect_0.2.5   tibble_2.1.3       roxygen2_7.0.2    
    ## [37] fansi_0.4.0        crayon_1.3.4       dplyr_0.8.3        withr_2.1.2       
    ## [41] sf_0.8-0           MASS_7.3-51.4      grid_3.5.2         nlme_3.1-143      
    ## [45] jsonlite_1.6       lifecycle_0.1.0    DBI_1.1.0          magrittr_1.5      
    ## [49] units_0.6-5        bibtex_0.4.2       KernSmooth_2.23-15 cli_2.0.0         
    ## [53] stringi_1.4.3      fs_1.3.1           remotes_2.1.0      sp_1.3-2          
    ## [57] testthat_2.3.1     ellipsis_0.3.0     vctrs_0.2.1        generics_0.0.2    
    ## [61] RColorBrewer_1.1-2 tools_3.5.2        glue_1.3.1         purrr_0.3.3       
    ## [65] hms_0.5.2          yaml_2.2.0.9999    processx_3.4.1     pkgload_1.0.2     
    ## [69] sessioninfo_1.1.1  classInt_0.4-2     memoise_1.1.0
