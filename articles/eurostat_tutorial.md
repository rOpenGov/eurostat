# Tutorial for the eurostat R package

## R Tools for Eurostat Open Data

This [rOpenGov](http://ropengov.github.io) R package provides tools to
access [Eurostat database](http://ec.europa.eu/eurostat/data/database),
which you can also browse on-line for the data sets and documentation.
For contact information and source code, see the [package
website](http://ropengov.github.io/eurostat/).

## Installation

Release version [(CRAN)](https://CRAN.R-project.org/package=eurostat):

``` r
install.packages("eurostat")
```

Development version [(Github)](https://github.com/rOpenGov/eurostat):

``` r
library(remotes)
remotes::install_github("ropengov/eurostat")
```

Alternatively, development versions (more specifically: development
versions in the master branch of eurostat GitHub repository) can be
installed with the help of R-universe:

``` r
# Enable this universe
options(repos = c(
  ropengov = "https://ropengov.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))

install.packages("eurostat")
```

The package is loaded with the library function.

Overall, the eurostat package includes the following user-facing
functions:

    check_access_to_data    Check access to ec.europe.eu
    clean_eurostat_cache    Clean Eurostat Cache
    cut_to_classes          Cuts the Values Column into Classes and
                            Polishes the Labels
    dic_order               Order of Variable Levels from Eurostat
                            Dictionary.
    eu_countries            Countries and Country Codes
    eurostat-defunct        Defunct functions in eurostat
    eurostat-package        R Tools for Eurostat open data
    eurostat_geodata_60_2016
                            Geospatial data of Europe from GISCO in 1:60
                            million scale from year 2016
    eurotime2date           Date Conversion from New Eurostat Time Format
    eurotime2num            Conversion of Eurostat Time Format to Numeric
    get_bibentry            Create A Data Bibliography
    get_eurostat            Get Eurostat Data
    get_eurostat_dic        Download Eurostat Dictionary
    get_eurostat_folder     Get all datasets in a folder
    get_eurostat_geospatial
                            Download Geospatial Data from GISCO
    get_eurostat_interactive
                            Get Eurostat data interactive
    get_eurostat_json       Get Data from Eurostat API in JSON
    get_eurostat_raw        Download Data from Eurostat Dissemination API
    get_eurostat_toc        Download Table of Contents of Eurostat Data
                            Sets
    harmonize_country_code
                            Harmonize Country Code
    label_eurostat          Get Eurostat Codes for data downloaded from new
                            dissemination API
    list_eurostat_cache_items
                            Output cache information as data.frame
    search_eurostat         Grep Datasets Titles from Eurostat
    set_eurostat_cache_dir
                            Set Eurostat Cache
    tgs00026                Auxiliary Data

``` r
evaluate <- curl::has_internet()
```

## Finding data

First stop for most researchers would be to browse the [Eurostat Data
Browser
website](https://ec.europa.eu/eurostat/databrowser/explore/all/all_themes)
or other thematically arranged sections in the Eurostat website.
However, the eurostat R package offers some ways to search for datasets
without leaving the R interface.

Function
[`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md)
downloads a table of contents (TOC) of eurostat datasets.

``` r
# Load the package
library(eurostat)

# Get Eurostat data listing
toc <- get_eurostat_toc()

# Check the first items
library(knitr)
kable(tail(toc))
```

| title                                                                               | code        | type    | last.update.of.data | last.table.structure.change | data.start | data.end |  values | hierarchy |
|:------------------------------------------------------------------------------------|:------------|:--------|:--------------------|:----------------------------|:-----------|:---------|--------:|----------:|
| Generation of waste by waste category, hazardousness and NACE Rev. 2 activity       | env_wasgen  | dataset | 22.09.2025          | 30.09.2024                  | 2004       | 2022     | 1457402 |         4 |
| Food waste and food waste prevention by NACE Rev. 2 activity - tonnes of fresh mass | env_wasfw   | dataset | 15.10.2025          | 15.10.2025                  | 2020       | 2023     |    1356 |         4 |
| Water use by supply category and economical sector                                  | env_wat_cat | dataset | 31.07.2025          | 31.07.2025                  | 1970       | 2023     |    9213 |         4 |
| Population connected to wastewater treatment plants                                 | env_ww_con  | dataset | 03.11.2025          | 31.07.2025                  | 1970       | 2023     |   16466 |         4 |
| Population connected to public water supply                                         | env_wat_pop | dataset | 31.07.2025          | 31.07.2025                  | 1990       | 2023     |     569 |         4 |
| Generation and discharge of wastewater in volume                                    | env_ww_genv | dataset | 31.07.2025          | 31.07.2025                  | 1975       | 2023     |   12625 |         4 |

The values in column ‘code’ are unique identifiers for each dataset that
have to be used when downloading specific datasets. In the
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
function the dataset code is put into the first argument of the
function, `id`.

From eurostat version 4.0.0 onwards the returned TOC object has had an
additional column, `hierarchy`. It is used to determine which dataset
belongs to which folder. This is helpful for example when downloading
datasets in a single folder all at once.

From eurostat version 4.0.0 onwards it is possible to download TOC
objects in French and German as well, in addition to English, which
remains the default option. This enables new functionalities in other
eurostat functions that have used the TOC object internally but retains
backwards-compatibility with old code as the `lang` argument is not
mandatory and queries without it continue to deliver the English version
of the TOC object.

``` r
kable(head(get_eurostat_toc(lang = "fr")))
```

| title                                                           | code        | type   | last.update.of.data | last.table.structure.change | data.start | data.end | values | hierarchy |
|:----------------------------------------------------------------|:------------|:-------|:--------------------|:----------------------------|:-----------|:---------|-------:|----------:|
| Base de données par thèmes                                      | data        | folder |                     |                             |            |          |     NA |         0 |
| Statistiques générales et régionales                            | general     | folder |                     |                             |            |          |     NA |         1 |
| Indicateurs européens et nationaux pour l’analyse à court terme | euroind     | folder |                     |                             |            |          |     NA |         2 |
| Balance des paiements                                           | ei_bp       | folder |                     |                             |            |          |     NA |         3 |
| Compte courant - données trimestrielles                         | ei_bpm6ca_q | table  | 13.01.2026          | 13.01.2026                  | 1991-Q1    | 2025-Q3  | 298336 |         4 |
| Compte financier - données trimestrielles                       | ei_bpm6fa_q | table  | 13.01.2026          | 12.01.2026                  | 1991-Q1    | 2025-Q3  |  52732 |         4 |

With
[`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
you can search the table of contents for particular patterns, e.g. all
datasets related to *passenger transport*. With the `type` argument the
user can choose which types of datasets the search should return:
datasets, tables, folders or all types (the default).

According to [Eurostat database basic
terminology](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Glossary:Eurostat_database_-_basic_terminology)
“tables (predefined tables) are used to provide easy access to the main
statistical indicators. They are based in general on datasets and are
derived from them. They are predefined, non-modifiable and presented as
two or three dimensional tables.” The more general purpose datasets are,
on the other hand, described to be “multi-dimensional tables” that have
“up to 8 dimensions” and are used “store the base data, more appropriate
for use by statistical and other experts via special applications”.

``` r
# info about passengers
kable(head(search_eurostat("passenger transport")))
```

| title                                                                               | code         | type    | last.update.of.data | last.table.structure.change | data.start | data.end |   values | hierarchy |
|:------------------------------------------------------------------------------------|:-------------|:--------|:--------------------|:----------------------------|:-----------|:---------|---------:|----------:|
| Air passenger transport - ENP-South countries                                       | enps_avia_pa | dataset | 12.05.2025          | 12.05.2025                  | 2005       | 2023     |      480 |         6 |
| Air passenger transport by type of schedule, transport coverage and country         | avia_paoc    | dataset | 17.02.2026          | 28.01.2026                  | 1993       | 2025-Q4  |  2609977 |         5 |
| Air passenger transport by type of schedule, transport coverage and main airports   | avia_paoa    | dataset | 17.02.2026          | 28.01.2026                  | 1993       | 2025-Q4  | 21761446 |         5 |
| Air passenger transport between reporting and partner countries by type of schedule | avia_paocc   | dataset | 17.02.2026          | 28.01.2026                  | 1993       | 2025-Q4  | 11271094 |         5 |
| Air passenger transport between main airports and partner reporting countries       | avia_paoac   | dataset | 17.02.2026          | 28.01.2026                  | 1993       | 2025-Q4  | 21346408 |         5 |
| Air passenger transport by aircraft model, distance bands and transport coverage    | avia_paodis  | dataset | 03.12.2025          | 29.10.2025                  | 2008       | 2024     |   907536 |         5 |

From eurostat version 4.0.0 onwards it possible to perform searches also
from dataset codes. This is done by specifying the search column by
setting the `column` attribute to `"code"`. Searching for codes can be
useful in finding datasets that belong to the same folder or are part of
a larger theme that shares similar dataset code patterns, such as “migr”
for migration related statistics and “tran” in the case of (multimodal)
transport statistics.

``` r
kable(head(search_eurostat("migr", column = "code")))
```

| title                                                                                                                | code          | type    | last.update.of.data | last.table.structure.change | data.start | data.end |  values | hierarchy |
|:---------------------------------------------------------------------------------------------------------------------|:--------------|:--------|:--------------------|:----------------------------|:-----------|:---------|--------:|----------:|
| Total and active population by sex, age, employment status, residence one year prior to the census and NUTS 3 region | cens_01ramigr | dataset | 27.03.2009          | 03.01.2024                  | 2001       | 2001     | 1482371 |         6 |
| Total and active population by sex, age, employment status, residence one year prior to the census and NUTS 3 region | cens_01ramigr | dataset | 27.03.2009          | 03.01.2024                  | 2001       | 2001     | 1482371 |         6 |
| Population on 1 January by age, sex and broad group of citizenship                                                   | migr_pop2ctz  | dataset | 13.02.2026          | 20.01.2026                  | 1998       | 2025     |  707342 |         4 |
| Population on 1 January by age group, sex and citizenship                                                            | migr_pop1ctz  | dataset | 13.02.2026          | 20.01.2026                  | 1998       | 2025     | 8773048 |         4 |
| Population on 1 January by age group, sex and country of birth                                                       | migr_pop3ctb  | dataset | 13.02.2026          | 20.01.2026                  | 1998       | 2025     | 7057298 |         4 |
| Population on 1 January by age, sex and group of country of birth                                                    | migr_pop4ctb  | dataset | 13.02.2026          | 20.01.2026                  | 1998       | 2025     |  684541 |         4 |

Another new addition in version 4.0.0 is the option to perform searches
from French and German language TOC versions as well by setting the
`lang` argument to `"fr"` or `"de"`. Naturally, dataset codes are shared
between language versions so French and German language searches should
be conducted only on the title column.

``` r
kable(head(search_eurostat("flughafen", column = "title", lang = "de")))
```

| title                                                                                     | code          | type    | last.update.of.data | last.table.structure.change | data.start | data.end | values | hierarchy |
|:------------------------------------------------------------------------------------------|:--------------|:--------|:--------------------|:----------------------------|:-----------|:---------|-------:|----------:|
| Kommerzieller Luftverkehr nach Berichtsflughafen und Typ des Fahrplans - monatliche Daten | avia_tf_airpm | dataset | 09.02.2026          | 09.02.2026                  | 2019-01    | 2026-01  | 665788 |         4 |

As mentioned in the beginning, codes for different dataset can be found
also from the [Eurostat
database](http://ec.europa.eu/eurostat/data/database). The Eurostat
database gives codes in the Data Navigation Tree in parenthesis after
the full name of the dataset, folder, or table.

## Downloading data

The package supports two of the Eurostats download methods: the SDMX 2.1
REST API and the API Statistics (“JSON API”). The bulk download facility
is the fastest method to download whole datasets. To download only a
small section of the dataset the JSON API is faster, as it allows to
make a data selection before downloading.

The end user does not usually have to bother where original data is
downloaded, as both data sources are accessed via the main download
function
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).
If only the table id is given, the whole table is downloaded from the
SDMX 2.1 REST API. If any filters are given the JSON API is used
instead. However, the
[`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
function used internally is also a user-facing function so that can be
used as well.

We will use the dataset ‘Modal split of air, sea and inland passenger
transport’ as an example dataset in this vignette. This is the
percentage share of each mode of transport in total inland transport,
expressed in passenger-kilometres (pkm) based on transport by passenger
cars, buses and coaches, trains, aircraft, and seagoing vessels. All
data should be based on movements on national territory, regardless of
the nationality of the vehicle. However, the data collection is not
harmonized at the EU level. For more detailed information about the
dataset, see [Reference
Metadata](https://ec.europa.eu/eurostat/cache/metadata/en/tran_hv_ms_esms.htm).

Pick and print the id of the data set to download:

``` r
# Perform search, the output is a table of search results
search_results <- search_eurostat("Modal split of air, sea and inland passenger transport",
  type = "dataset"
)

# Since our search term was so detailed, we should have only 1 result / 1 row
kable(head(search_results))
```

| title                                                  | code             | type    | last.update.of.data | last.table.structure.change | data.start | data.end | values | hierarchy |
|:-------------------------------------------------------|:-----------------|:--------|:--------------------|:----------------------------|:-----------|:---------|-------:|----------:|
| Modal split of air, sea and inland passenger transport | tran_hv_ms_psmod | dataset | 05.06.2025          | 05.06.2025                  | 2008       | 2023     |   2272 |         4 |

``` r
# Get the id from the table
id <- search_results$code[1]

# Check the id
print(id)
```

\[1\] “tran_hv_ms_psmod”

Get the whole corresponding table. As the table is annual data, it is
more convenient to use a numeric time variable than use the default date
format, where yearly data would be coerced to be on the first day of the
year (e.g. 2000-01-01).

``` r
dat <- get_eurostat(id, time_format = "num", stringsAsFactors = TRUE)
```

The structure of the downloaded data set can be investigated by using
the base R [`str()`](https://rdrr.io/r/utils/str.html) function:

``` r
str(dat)
```

    ## tibble [2,400 × 6] (S3: tbl_df/tbl/data.frame)
    ##  $ freq       : Factor w/ 1 level "A": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ vehicle    : Factor w/ 5 levels "AC","BUS_TOT",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ unit       : Factor w/ 1 level "PC": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ geo        : Factor w/ 30 levels "AT","BE","BG",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ TIME_PERIOD: num [1:2400] 2008 2009 2010 2011 2012 ...
    ##  $ values     : num [1:2400] 16.3 15.9 16.9 17.7 18.2 18.5 18.9 19.2 19 20.1 ...

``` r
kable(head(dat))
```

| freq | vehicle | unit | geo | TIME_PERIOD | values |
|:-----|:--------|:-----|:----|------------:|-------:|
| A    | AC      | PC   | AT  |        2008 |   16.3 |
| A    | AC      | PC   | AT  |        2009 |   15.9 |
| A    | AC      | PC   | AT  |        2010 |   16.9 |
| A    | AC      | PC   | AT  |        2011 |   17.7 |
| A    | AC      | PC   | AT  |        2012 |   18.2 |
| A    | AC      | PC   | AT  |        2013 |   18.5 |

You can get only a part of the dataset by defining `filters` argument.
It should be named list, where names corresponds to variable names
(lower case) and values are vectors of codes corresponding desired
series (upper case). For time variable, in addition to a `time` or
`TIME_PERIOD` , also `sinceTimePeriod`, `untilTimePeriod` and a
`lastTimePeriod` can be used.

More information about filtering can be found in
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
and
[`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
function documentation.

``` r
dat2 <- get_eurostat(id, filters = list(geo = c("EU27_2020", "FI"), lastTimePeriod = 1), time_format = "num")
kable(dat2)
```

| freq | vehicle | unit | geo       | time | values |
|:-----|:--------|:-----|:----------|-----:|-------:|
| A    | TRN     | PC   | EU27_2020 | 2023 |    7.1 |
| A    | TRN     | PC   | FI        | 2023 |    6.5 |
| A    | CAR     | PC   | EU27_2020 | 2023 |   70.6 |
| A    | CAR     | PC   | FI        | 2023 |   76.4 |
| A    | BUS_TOT | PC   | EU27_2020 | 2023 |    7.2 |
| A    | BUS_TOT | PC   | FI        | 2023 |    9.1 |
| A    | SEAV    | PC   | EU27_2020 | 2023 |    0.4 |
| A    | SEAV    | PC   | FI        | 2023 |    2.1 |
| A    | AC      | PC   | EU27_2020 | 2023 |   14.7 |
| A    | AC      | PC   | FI        | 2023 |    5.9 |

### Replacing codes with labels

By default variables are returned as Eurostat codes, but to get
human-readable labels instead, use a `type = "label"` argument in
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).

``` r
dat_labeled2 <- get_eurostat(id,
  filters = list(
    geo = c("EU27_2020", "FI"),
    lastTimePeriod = 1
  ),
  type = "label", time_format = "num"
)
kable(head(dat_labeled2))
```

| freq   | vehicle                                | unit       | geo                                       | time | values |
|:-------|:---------------------------------------|:-----------|:------------------------------------------|-----:|-------:|
| Annual | Trains                                 | Percentage | European Union - 27 countries (from 2020) | 2023 |    7.1 |
| Annual | Trains                                 | Percentage | Finland                                   | 2023 |    6.5 |
| Annual | Passenger cars                         | Percentage | European Union - 27 countries (from 2020) | 2023 |   70.6 |
| Annual | Passenger cars                         | Percentage | Finland                                   | 2023 |   76.4 |
| Annual | Motor coaches, buses and trolley buses | Percentage | European Union - 27 countries (from 2020) | 2023 |    7.2 |
| Annual | Motor coaches, buses and trolley buses | Percentage | Finland                                   | 2023 |    9.1 |

Eurostat codes in the downloaded data set can be replaced with
human-readable labels from the Eurostat dictionaries with the
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
function.

``` r
dat_labeled <- label_eurostat(dat)
kable(head(dat_labeled))
```

| freq   | vehicle  | unit       | geo     | TIME_PERIOD | values |
|:-------|:---------|:-----------|:--------|------------:|-------:|
| Annual | Aircraft | Percentage | Austria |        2008 |   16.3 |
| Annual | Aircraft | Percentage | Austria |        2009 |   15.9 |
| Annual | Aircraft | Percentage | Austria |        2010 |   16.9 |
| Annual | Aircraft | Percentage | Austria |        2011 |   17.7 |
| Annual | Aircraft | Percentage | Austria |        2012 |   18.2 |
| Annual | Aircraft | Percentage | Austria |        2013 |   18.5 |

The
[`label_eurostat_vars()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
allows conversion of variable names as well.

``` r
print(label_eurostat_vars(id = "tran_hv_ms_psmod", names(dat_labeled)))
```

    ## [1] "Time frequency"                  "Vehicles"                       
    ## [3] "Unit of measure"                 "Geopolitical entity (reporting)"
    ## [5] "Time"

Vehicle information has 5 levels. You can check them now with:

``` r
levels(dat_labeled$vehicle)
```

    ## [1] "Aircraft"                              
    ## [2] "Motor coaches, buses and trolley buses"
    ## [3] "Passenger cars"                        
    ## [4] "Seagoing vessels"                      
    ## [5] "Trains"

### Downloading data interactively

New function in the eurostat package version 4.0.0 is the
[`get_eurostat_interactive()`](https://ropengov.github.io/eurostat/reference/get_eurostat_interactive.md)
function that allows users to search and download datasets with the help
of interactive menus. If the user already knows which dataset they want
to download, the
[`get_eurostat_interactive()`](https://ropengov.github.io/eurostat/reference/get_eurostat_interactive.md)
function can also take a dataset code as a parameter, skipping the
search part of the interactive menu. Below we will demonstrate the whole
process from search to download to printing a citation for the dataset,
utilizing several different eurostat package functions at once.

``` text
> get_eurostat_interactive()
Select language 

1: English
2: French
3: German

Selection: 1
Enter search term for data: aviation
Which dataset would you like to download?                                                             

1: [tran_sf_aviagah] Air accident victims in general aviation, by country of occurrence and country of registration of aircraft - maximum take-off mass above 2250 kg (source: EASA)
2: [tran_sf_aviagal] Air accident victims in general aviation by country of occurrence and country of registration of aircraft - maximum take-off mass under 2250 kg (source: EASA)
3: [avia_ec_enterp] Number of aviation and airport enterprises
4: [avia_ec_emp_ent] Employment in aviation and airport enterprises by sex


Selection: 4
Download the dataset? 

1: Yes
2: No

Selection: 1
Would you like to use default download arguments or set them manually? 

1: Default
2: Manually selected

Selection: 1
trying URL 'https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/avia_ec_emp_ent?format=TSV&compressed=true'
Content type 'text/tab-separated-values; charset=UTF-8' length 1354 bytes
==================================================
downloaded 1354 bytes

Table avia_ec_emp_ent cached at /var/folders/f4/h_r3y60n0nn0qm6qx5hnx1s00000gn/T//RtmpDJ1gUA/eurostat/60ee371bcdcc9b130a20514d1e0d574d.rds
Print dataset citation? 

1: Yes
2: No

Selection: 1
Print code for downloading dataset? 

1: Yes
2: No

Selection: 1
Print dataset fixity checksum? 

1: Yes
2: No

Selection: 1
##### DATASET CITATION:

@Misc{avia-ec-emp-ent-2016-4-20,
  title = {Employment in aviation and airport enterprises by sex (avia\_ec\_emp\_ent)},
  url = {https://ec.europa.eu/eurostat/web/products-datasets/product?code=avia_ec_emp_ent},
  language = {english},
  year = {2016},
  author = {{Eurostat}},
  urldate = {2023-12-19},
  type = {Dataset},
  note = {Accessed 2023-12-19, dataset last updated 2016-04-20},
}

##### DOWNLOAD PARAMETERS:

get_eurostat(id = 'avia_ec_emp_ent')

##### FIXITY CHECKSUM:

Fixity checksum (md5) for dataset avia_ec_emp_ent: 36975282eaaea50a6e5f0e6cd64ef4d2

# A tibble: 450 × 6
   freq  enterpr sex   geo   TIME_PERIOD values
   <chr> <chr>   <chr> <chr> <date>       <dbl>
 1 A     AIRP    F     CY    2006-01-01     192
 2 A     AIRP    F     CY    2007-01-01     240
 3 A     AIRP    F     CY    2008-01-01     514
 4 A     AIRP    F     CY    2009-01-01    3278
 5 A     AIRP    F     CY    2010-01-01    2587
 6 A     AIRP    F     CY    2011-01-01    2255
 7 A     AIRP    F     CY    2012-01-01    2954
 8 A     AIRP    F     CZ    2001-01-01       0
 9 A     AIRP    F     CZ    2002-01-01       0
10 A     AIRP    F     CZ    2003-01-01       0
# ℹ 440 more rows
# ℹ Use `print(n = ...)` to see more rows
```

## Selecting and modifying data

### EFTA, Eurozone, EU and EU candidate countries

To facilitate smooth visualization of standard European geographic
areas, the package provides ready-made lists of the country codes used
in the eurostat database for EFTA (efta_countries), Euro area
(ea_countries), EU (eu_countries) and EU candidate countries
(eu_candidate_countries). These can be used to select specific groups of
countries for closer investigation. For conversions with other standard
country coding systems, see the
[countrycode](https://CRAN.R-project.org/package=countrycode) R package.
To retrieve the country code list for EFTA, for instance, use:

``` r
data(efta_countries)
kable(efta_countries)
```

| code | name          | label         |
|:-----|:--------------|:--------------|
| IS   | Iceland       | Iceland       |
| LI   | Liechtenstein | Liechtenstein |
| NO   | Norway        | Norway        |
| CH   | Switzerland   | Switzerland   |

### EU data from 2012 in all vehicles:

``` r
dat_eu12 <- subset(dat_labeled, geo == "European Union - 27 countries (from 2020)" & TIME_PERIOD == 2012)
kable(dat_eu12, row.names = FALSE)
```

| freq   | vehicle                                | unit       | geo                                       | TIME_PERIOD | values |
|:-------|:---------------------------------------|:-----------|:------------------------------------------|------------:|-------:|
| Annual | Aircraft                               | Percentage | European Union - 27 countries (from 2020) |        2012 |   11.6 |
| Annual | Motor coaches, buses and trolley buses | Percentage | European Union - 27 countries (from 2020) |        2012 |    9.1 |
| Annual | Passenger cars                         | Percentage | European Union - 27 countries (from 2020) |        2012 |   72.3 |
| Annual | Seagoing vessels                       | Percentage | European Union - 27 countries (from 2020) |        2012 |    0.4 |
| Annual | Trains                                 | Percentage | European Union - 27 countries (from 2020) |        2012 |    6.7 |

### EU data from 2008 - 2020 with vehicle types as variables:

Reshaping the data is best done with
[`spread()`](https://tidyr.tidyverse.org/reference/spread.html) in
`tidyr`.

``` r
library("tidyr")
dat_eu_0012 <- subset(dat, geo == "EU27_2020" & TIME_PERIOD %in% c(2008:2020))
dat_eu_0012_wide <- spread(dat_eu_0012, vehicle, values)
kable(subset(dat_eu_0012_wide, select = -geo), row.names = FALSE)
```

| freq | unit | TIME_PERIOD |   AC | BUS_TOT |  CAR | SEAV | TRN |
|:-----|:-----|------------:|-----:|--------:|-----:|-----:|----:|
| A    | PC   |        2008 | 10.4 |     8.9 | 73.7 |  0.5 | 6.5 |
| A    | PC   |        2009 |  9.7 |     8.5 | 75.0 |  0.5 | 6.3 |
| A    | PC   |        2010 | 10.3 |     8.8 | 74.0 |  0.5 | 6.5 |
| A    | PC   |        2011 | 10.9 |     9.0 | 73.0 |  0.4 | 6.6 |
| A    | PC   |        2012 | 11.6 |     9.1 | 72.3 |  0.4 | 6.7 |
| A    | PC   |        2013 | 11.9 |     9.0 | 72.1 |  0.4 | 6.6 |
| A    | PC   |        2014 | 12.2 |     8.6 | 72.1 |  0.4 | 6.6 |
| A    | PC   |        2015 | 12.5 |     8.6 | 71.9 |  0.4 | 6.6 |
| A    | PC   |        2016 | 12.8 |     8.4 | 72.0 |  0.4 | 6.5 |
| A    | PC   |        2017 | 13.7 |     8.0 | 71.4 |  0.4 | 6.5 |
| A    | PC   |        2018 | 14.4 |     7.9 | 70.8 |  0.4 | 6.6 |
| A    | PC   |        2019 | 14.8 |     7.9 | 70.2 |  0.4 | 6.7 |
| A    | PC   |        2020 |  5.7 |     6.9 | 82.1 |  0.3 | 5.1 |

### Train passengers for selected EU countries in 2008 - 2020

``` r
dat_trains <- subset(dat_labeled, geo %in% c("Austria", "Belgium", "Finland", "Sweden") &
  TIME_PERIOD %in% c(2008:2020) &
  vehicle == "Trains")
dat_trains_wide <- spread(dat_trains, geo, values)
kable(subset(dat_trains_wide, select = -vehicle), row.names = FALSE)
```

| freq   | unit       | TIME_PERIOD | Austria | Belgium | Finland | Sweden |
|:-------|:-----------|------------:|--------:|--------:|--------:|-------:|
| Annual | Percentage |        2008 |     9.8 |     6.6 |     4.9 |    8.1 |
| Annual | Percentage |        2009 |     9.9 |     6.8 |     4.7 |    8.2 |
| Annual | Percentage |        2010 |     9.7 |     6.9 |     4.7 |    8.0 |
| Annual | Percentage |        2011 |     9.9 |     7.1 |     4.6 |    7.5 |
| Annual | Percentage |        2012 |     9.7 |     6.9 |     4.8 |    7.8 |
| Annual | Percentage |        2013 |    10.0 |     7.0 |     4.8 |    7.8 |
| Annual | Percentage |        2014 |     9.9 |     7.4 |     4.6 |    7.8 |
| Annual | Percentage |        2015 |     9.7 |     7.2 |     4.8 |    8.0 |
| Annual | Percentage |        2016 |     9.8 |     6.9 |     4.4 |    9.0 |
| Annual | Percentage |        2017 |     9.6 |     7.0 |     4.9 |    9.1 |
| Annual | Percentage |        2018 |     9.7 |     7.8 |     5.1 |    9.2 |
| Annual | Percentage |        2019 |     9.6 |     7.9 |     5.5 |    9.9 |
| Annual | Percentage |        2020 |     7.9 |     7.0 |     3.7 |    7.1 |

### Other packages

#### Strongly recommended

The `giscoR` ([package homepage](https://ropengov.github.io/giscoR/))
package used to be only suggested but starting from `eurostat` version
4.0.0 it has become a dependency of eurostat and required for using
geospatial data functions. In addition to using
[`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
from the `eurostat` package, it is highly recommended to study `giscoR`
package functions and vignettes for creating more sophisticated
visualisations to support geospatial analyses.

#### Packages with similar functionalities

The [restatapi](https://CRAN.R-project.org/package=restatapi) R package
has similar functionalities and some familiar function names for
seasoned eurostat R package users. The `restatapi` package focuses more
on statistical data and retrieving and returning data in a non-tidy data
format.

The [rsdmx](https://CRAN.R-project.org/package=rsdmx) and
[rjsdmx](https://CRAN.R-project.org/package=RJSDMX) R packages provide a
more generic method to download data from a wide variety of statistical
data providers that utilize the Statistical Data and Metadata eXchange
([SDMX](https://sdmx.org)) standards.

## Further examples

For further examples, see articles in the [package
homepage](http://ropengov.github.io/eurostat/).

## Citations and related work

#### Citing the data sources

Eurostat data: cite [Eurostat](http://ec.europa.eu/eurostat/).

Administrative boundaries: cite EuroGeographics

#### Citing the eurostat R package

For main developers and contributors, see the [package
homepage](http://ropengov.github.io/eurostat).

This work can be freely used, modified and distributed under the
BSD-2-clause (modified FreeBSD) license:

``` r
citation("eurostat")
```

    ## Kindly cite the eurostat R package as follows:
    ## 
    ##   Lahti L., Huovari J., Kainu M., and Biecek P. (2017). Retrieval and
    ##   analysis of Eurostat open data with the eurostat package. The R
    ##   Journal 9(1), pp. 385-392. doi: 10.32614/RJ-2017-019
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Article{10.32614/RJ-2017-019,
    ##     title = {Retrieval and Analysis of Eurostat Open Data with the eurostat Package},
    ##     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
    ##     journal = {The R Journal},
    ##     volume = {9},
    ##     number = {1},
    ##     pages = {385--392},
    ##     year = {2017},
    ##     doi = {10.32614/RJ-2017-019},
    ##     url = {https://doi.org/10.32614/RJ-2017-019},
    ##   }
    ## 
    ##   Lahti, L., Huovari J., Kainu M., Biecek P., Hernangomez D., Antal D.,
    ##   and Kantanen P. (2023). eurostat: Tools for Eurostat Open Data
    ##   [Computer software]. R package version 4.0.0.
    ##   https://github.com/rOpenGov/eurostat
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Misc{eurostat,
    ##     title = {eurostat: Tools for Eurostat Open Data},
    ##     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek and Diego Hernangomez and Daniel Antal and Pyry Kantanen},
    ##     url = {https://github.com/rOpenGov/eurostat},
    ##     type = {Computer software},
    ##     year = {2023},
    ##     note = {R package version 4.0.0},
    ##   }

#### Contact

For contact information, see the [package
homepage](http://ropengov.github.io/eurostat).

## Version info

This tutorial was created with

``` r
sessioninfo::session_info()
```

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value
    ##  version  R version 4.5.2 (2025-10-31)
    ##  os       Ubuntu 24.04.3 LTS
    ##  system   x86_64, linux-gnu
    ##  ui       X11
    ##  language en
    ##  collate  C.UTF-8
    ##  ctype    C.UTF-8
    ##  tz       UTC
    ##  date     2026-02-17
    ##  pandoc   3.1.11 @ /opt/hostedtoolcache/pandoc/3.1.11/x64/ (via rmarkdown)
    ##  quarto   NA
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package     * version  date (UTC) lib source
    ##  assertthat    0.2.1    2019-03-21 [1] RSPM
    ##  backports     1.5.0    2024-05-23 [1] RSPM
    ##  bibtex        0.5.2    2026-02-03 [1] RSPM
    ##  bit           4.6.0    2025-03-06 [1] RSPM
    ##  bit64         4.6.0-1  2025-01-16 [1] RSPM
    ##  bslib         0.10.0   2026-01-26 [1] RSPM
    ##  cachem        1.1.0    2024-05-16 [1] RSPM
    ##  cellranger    1.1.0    2016-07-27 [1] RSPM
    ##  class         7.3-23   2025-01-01 [3] CRAN (R 4.5.2)
    ##  classInt      0.4-11   2025-01-08 [1] RSPM
    ##  cli           3.6.5    2025-04-23 [1] RSPM
    ##  countrycode   1.6.1    2025-03-31 [1] RSPM
    ##  crayon        1.5.3    2024-06-20 [1] RSPM
    ##  curl          7.0.0    2025-08-19 [1] RSPM
    ##  data.table    1.18.2.1 2026-01-27 [1] RSPM
    ##  desc          1.4.3    2023-12-10 [1] RSPM
    ##  digest        0.6.39   2025-11-19 [1] RSPM
    ##  dplyr         1.2.0    2026-02-03 [1] RSPM
    ##  e1071         1.7-17   2025-12-18 [1] RSPM
    ##  eurostat    * 4.0.0    2026-02-17 [1] local
    ##  evaluate      1.0.5    2025-08-27 [1] RSPM
    ##  fastmap       1.2.0    2024-05-15 [1] RSPM
    ##  fs            1.6.6    2025-04-12 [1] RSPM
    ##  generics      0.1.4    2025-05-09 [1] RSPM
    ##  glue          1.8.0    2024-09-30 [1] RSPM
    ##  here          1.0.2    2025-09-15 [1] RSPM
    ##  hms           1.1.4    2025-10-17 [1] RSPM
    ##  htmltools     0.5.9    2025-12-04 [1] RSPM
    ##  htmlwidgets   1.6.4    2023-12-06 [1] RSPM
    ##  httr          1.4.8    2026-02-13 [1] RSPM
    ##  httr2         1.2.2    2025-12-08 [1] RSPM
    ##  ISOweek       0.6-2    2011-09-07 [1] RSPM
    ##  jquerylib     0.1.4    2021-04-26 [1] RSPM
    ##  jsonlite      2.0.0    2025-03-27 [1] RSPM
    ##  KernSmooth    2.23-26  2025-01-01 [3] CRAN (R 4.5.2)
    ##  knitr       * 1.51     2025-12-20 [1] RSPM
    ##  lifecycle     1.0.5    2026-01-08 [1] RSPM
    ##  lubridate     1.9.5    2026-02-04 [1] RSPM
    ##  magrittr      2.0.4    2025-09-12 [1] RSPM
    ##  otel          0.2.0    2025-08-29 [1] RSPM
    ##  pillar        1.11.1   2025-09-17 [1] RSPM
    ##  pkgconfig     2.0.3    2019-09-22 [1] RSPM
    ##  pkgdown       2.2.0    2025-11-06 [1] any (@2.2.0)
    ##  plyr          1.8.9    2023-10-02 [1] RSPM
    ##  proxy         0.4-29   2025-12-29 [1] RSPM
    ##  purrr         1.2.1    2026-01-09 [1] RSPM
    ##  R6            2.6.1    2025-02-15 [1] RSPM
    ##  ragg          1.5.0    2025-09-02 [1] RSPM
    ##  rappdirs      0.3.4    2026-01-17 [1] RSPM
    ##  Rcpp          1.1.1    2026-01-10 [1] RSPM
    ##  readr         2.1.6    2025-11-14 [1] RSPM
    ##  readxl        1.4.5    2025-03-07 [1] RSPM
    ##  RefManageR    1.4.0    2022-09-30 [1] RSPM
    ##  regions       0.1.8    2021-06-21 [1] RSPM
    ##  rlang         1.1.7    2026-01-09 [1] RSPM
    ##  rmarkdown     2.30     2025-09-28 [1] RSPM
    ##  rprojroot     2.1.1    2025-08-26 [1] RSPM
    ##  sass          0.4.10   2025-04-11 [1] RSPM
    ##  sessioninfo   1.2.3    2025-02-05 [1] RSPM
    ##  stringi       1.8.7    2025-03-27 [1] RSPM
    ##  stringr       1.6.0    2025-11-04 [1] RSPM
    ##  systemfonts   1.3.1    2025-10-01 [1] RSPM
    ##  textshaping   1.0.4    2025-10-10 [1] RSPM
    ##  tibble        3.3.1    2026-01-11 [1] RSPM
    ##  tidyr       * 1.3.2    2025-12-19 [1] RSPM
    ##  tidyselect    1.2.1    2024-03-11 [1] RSPM
    ##  timechange    0.4.0    2026-01-29 [1] RSPM
    ##  tzdb          0.5.0    2025-03-15 [1] RSPM
    ##  vctrs         0.7.1    2026-01-23 [1] RSPM
    ##  vroom         1.7.0    2026-01-27 [1] RSPM
    ##  withr         3.0.2    2024-10-28 [1] RSPM
    ##  xfun          0.56     2026-01-18 [1] RSPM
    ##  xml2          1.5.2    2026-01-17 [1] RSPM
    ##  yaml          2.3.12   2025-12-10 [1] RSPM
    ## 
    ##  [1] /home/runner/work/_temp/Library
    ##  [2] /opt/R/4.5.2/lib/R/site-library
    ##  [3] /opt/R/4.5.2/lib/R/library
    ##  * ── Packages attached to the search path.
    ## 
    ## ──────────────────────────────────────────────────────────────────────────────
