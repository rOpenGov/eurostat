# Get Eurostat Data

Download data sets from Eurostat <https://ec.europa.eu/eurostat>

## Usage

``` r
get_eurostat(
  id,
  time_format = "date",
  filters = NULL,
  type = "code",
  select_time = NULL,
  lang = "en",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  compress_file = TRUE,
  stringsAsFactors = FALSE,
  keepFlags = FALSE,
  use.data.table = FALSE,
  ...
)
```

## Arguments

- id:

  A unique identifier / code for the dataset of interest. If code is not
  known
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  function can be used to search Eurostat table of contents.

- time_format:

  a string giving a type of the conversion of the time column from the
  eurostat format. The default argument "`date`" converts to a
  [`Date()`](https://rdrr.io/r/base/Dates.html) class with the date
  being the first day of the period. A "`date_last`" argument converts
  the dataset date to a [`Date()`](https://rdrr.io/r/base/Dates.html)
  class object with the difference that the exact date is the last date
  of the period. Period can be year, semester (half year), quarter,
  month, or week (See
  [`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md)
  for more information). Argument "`num`" converts the date into a
  numeric (integer) meaning that the first day of the year 2000 is close
  to 2000.01 and the last day of the year is close to 2000.99 (see
  [`eurotime2num()`](https://ropengov.github.io/eurostat/reference/eurotime2num.md)
  for more information). Using the argument "`raw`" preserves the dates
  as they were in the original Eurostat data.

- filters:

  A named list of filters. Names of list objects are Eurostat variable
  codes and values are vectors of observation codes. If `NULL` (default)
  the whole dataset is returned. See details for more information on
  filters and limitations per query.

- type:

  A type of variables, "`code`" (default), "`label`" or "`both`". The
  parameter "`both`" will return a data_frame with named vectors, labels
  as values and codes as names.

- select_time:

  a character symbol for a time frequency or `NULL`, which is used by
  default as most datasets have just one time frequency. For datasets
  with multiple time frequencies, select one or more of the desired
  frequencies with: "Y" (or "A") = annual, "S" = semi-annual / semester,
  "Q" = quarterly, "M" = monthly, "W" = weekly. For all frequencies in
  same data frame `time_format = "raw"` should be used.

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

- cache:

  a logical whether to do caching. Default is `TRUE`.

- update_cache:

  a logical whether to update cache. Can be set also with
  `options(eurostat_update = TRUE)`

- cache_dir:

  a path to a cache directory. `NULL` (default) uses and creates
  'eurostat' directory in the temporary directory defined by base R
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) function. The user
  can set the cache directory to an existing directory by using this
  argument. The cache directory can also be set with
  [`set_eurostat_cache_dir()`](https://ropengov.github.io/eurostat/reference/set_eurostat_cache_dir.md)
  function.

- compress_file:

  a logical whether to compress the RDS-file in caching. Default is
  `TRUE`.

- stringsAsFactors:

  if `TRUE` (the default) variables are converted to factors in the
  original Eurostat order. If `FALSE` they are returned as strings.

- keepFlags:

  a logical whether the flags (e.g. "confidential", "provisional")
  should be kept in a separate column or if they can be removed. Default
  is `FALSE`. For flag values see:
  <https://ec.europa.eu/eurostat/data/database/information>. Also
  possible non-real zero "0n" is indicated in flags column. Flags are
  not available for eurostat API, so `keepFlags` can not be used with a
  `filters`.

- use.data.table:

  Use faster data.table functions? Default is FALSE. On Windows requires
  that RTools is installed.

- ...:

  Arguments passed on to
  [`get_eurostat_json`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)

  `proxy`

  :   Use proxy, TRUE or FALSE (default).

## Value

a tibble.

One column for each dimension in the data, the time column for a time
dimension and the values column for numerical values. Eurostat data does
not include all missing values and a treatment of missing values depend
on source. In bulk download facility missing values are dropped if all
dimensions are missing on particular time. In JSON API missing values
are dropped only if all dimensions are missing on all times. The data
from bulk download facility can be completed for example with
[`tidyr::complete()`](https://tidyr.tidyverse.org/reference/complete.html).

## Details

Datasets are downloaded from [the Eurostat SDMX 2.1
API](https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API)
in TSV format or from The Eurostat [API Statistics JSON
API](https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query).
If only the table `id` is given, the whole table is downloaded from the
SDMX API. If any `filters` are given JSON API is used instead.

The bulk download facility is the fastest method to download whole
datasets. It is also often the only way as the JSON API has limitation
of maximum 50 sub-indicators at time and whole datasets usually exceeds
that. Also, it seems that multi frequency datasets can only be retrieved
via bulk download facility and the `select_time` is not available for
JSON API method.

If your connection is through a proxy, you may have to set proxy
parameters to use JSON API, see
[`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md).

By default datasets are cached to reduce load on Eurostat services and
because some datasets can be quite large. Cache files are stored in a
temporary directory by default or in a named directory (See
[`set_eurostat_cache_dir()`](https://ropengov.github.io/eurostat/reference/set_eurostat_cache_dir.md)).
The cache can be emptied with
[`clean_eurostat_cache()`](https://ropengov.github.io/eurostat/reference/clean_eurostat_cache.md).

The `id`, a code, for the dataset can be searched with the
[`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
or from the Eurostat database
<https://ec.europa.eu/eurostat/data/database>. The Eurostat database
gives codes in the Data Navigation Tree after every dataset in
parenthesis.

## Eurostat: Copyright notice and free re-use of data

The following copyright notice is provided for end user convenience.
Please check up-to-date copyright information from the eurostat website:
<https://ec.europa.eu/eurostat/about-us/policies/copyright>

"(c) European Union, 1995 - today

Eurostat has a policy of encouraging free re-use of its data, both for
non-commercial and commercial purposes. All statistical data, metadata,
content of web pages or other dissemination tools, official publications
and other documents published on its website, with the exceptions listed
below, can be reused without any payment or written licence provided
that:

- the source is indicated as Eurostat;

- when re-use involves modifications to the data or text, this must be
  stated clearly to the end user of the information."

For exceptions to the abovementioned principles see [Eurostat
website](https://ec.europa.eu/eurostat/about-us/policies/copyright)

## Filtering datasets

When using Eurostat API Statistics (JSON API), datasets can be filtered
before they are downloaded and saved in local memory. The general format
for filter parameters is `<DIMENSION_CODE>=<VALUE>`.

Filter parameters are optional but the used dimension codes must be
present in the data product that is being queried. Dimension codes can
vary between different data products so it may be useful to examine new
datasets in Eurostat data browser beforehand. However, most if not all
Eurostat datasets concern European countries and contain information
that was gathered at some point in time, so `geo` and `time` dimension
codes can usually be used.

`<DIMENSION_CODE>` and `<VALUE>` are case-insensitive and they can be
written in lowercase or uppercase in the query.

Parameters are passed onto the `eurostat` package functions
`get_eurostat()` and
[`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
as a list item. If an individual item contains multiple items, as it
often can be in the case of `geo` parameters and other optional items,
they must be in the form of a vector: `c("FI", "SE")`. For examples on
how to use these parameters, see function examples below.

### Time parameters

`time` and `time_period` address the same `TIME_PERIOD` dimension in the
dataset and can be used interchangeably. In the Eurostat documentation
it is stated that "Using more than one Time parameter in the same query
is not accepted", but practice has shown that actually Eurostat API
allows multiple `time` parameters in the same query. This makes it
possible to use R colon operator when writing queries, so
`time = c(2015:2018)` translates to
`&time=2015&time=2016&time=2017&time=2018`.

The only exception to this is when the queried dataset contains e.g.
quarterly data and `TIME_PERIOD` is saved as `2015-Q1`, `2015-Q2` etc.
Then it is possible to use `time=2015-Q1&time=2015-Q2` style in the
query URL, but this makes it unfeasible to use the colon operator and
requires a lot of manual typing.

Because of this, it is useful to know about other time parameters as
well:

- `untilTimePeriod`: return dataset items from the oldest record up
  until the set time, for example "all data until 2000":
  `untilTimePeriod = 2000`

- `sinceTimePeriod`: return dataset items starting from set time, for
  example "all datastarting from 2008": `sinceTimePeriod = 2008`

- `lastTimePeriod`: starting from the most recent time period, how many
  preceding time periods should be returned? For example 10 most recent
  observations: `lastTimePeriod = 10`

Using both `untilTimePeriod` and `sinceTimePeriod` parameters in the
same query is allowed, making the usage of the R colon operator
unnecessary. In the case of quarterly data, using `untilTimePeriod` and
`sinceTimePeriod` parameters also works, as opposed to the colon
operator, so it is generally safer to use them as well.

### Other dimensions

In
[`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
examples `nama_10_gdp` dataset is filtered with two additional filter
parameters:

- `na_item = "B1GQ"`

- `unit = "CLV_I10"`

Filters like these are most likely unique to the `nama_10_gdp` dataset
(or other datasets within the same domain) and should not be used with
others dataset without user discretion. By using
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
we know that `"B1GQ"` stands for "Gross domestic product at market
prices" and `"CLV_I10"` means "Chain linked volumes, index 2010=100".

Different dimension codes can be translated to a natural language by
using the
[`get_eurostat_dic()`](https://ropengov.github.io/eurostat/reference/get_eurostat_dic.md)
function, which returns labels for individual dimension items such as
`na_item` and `unit`, as opposed to
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
which does it for whole datasets. For example, the parameter `na_item`
stands for "National accounts indicator (ESA 2010)" and `unit` stands
for "Unit of measure".

### Language

All datasets have metadata available in English, French and German. If
no parameter is given, the labels are returned in English.

Example:

- `lang = "fr"`

### More information

For more information about data filtering see Eurostat documentation on
API Statistics:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query#APIStatisticsdataquery-TheparametersdefinedintheRESTrequest>

## Citing Eurostat data

For citing datasets, use
[`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
to build a bibliography that is suitable for your reference manager of
choice.

When using Eurostat data in other contexts than academic publications
that in-text citations or footnotes/endnotes, the following guidelines
may be helpful:

- The origin of the data should always be mentioned as "Source:
  Eurostat".

- The online dataset codes(s) should also be provided in order to ensure
  transparency and facilitate access to the Eurostat data and related
  methodological information. For example: "Source: Eurostat (online
  data code: namq_10_gdp)"

- Online publications (e.g. web pages, PDF) should include a clickable
  link to the dataset using the bookmark functionality available in the
  Eurostat data browser.

It should be avoided to associate different entities (e.g. Eurostat,
National Statistical Offices, other data providers) to the same dataset
or indicator without specifying the role of each of them in the
treatment of data.

See also section "Eurostat: Copyright notice and free re-use of data" in
`get_eurostat()` documentation.

## Disclaimer: Availability of filtering functionalities

Currently it only possible to download filtered data through API
Statistics (JSON API) when using `eurostat` package, although
technically filtering datasets downloaded through the SDMX Dissemination
API is also supported by Eurostat. We may support this feature in the
future. In the meantime, if you are interested in filtering
Dissemination API data queries manually, please consult the following
Eurostat documentation:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+SDMX+2.1+-+data+filtering>

## Strategies for handling large datasets more efficiently

Most Eurostat datasets are relatively manageable, at least on a machine
with 16 GB of RAM. The largest dataset in Eurostat database, at the time
of writing this, had 148362539 (148 million) values, which results in an
object with 148 million rows in tidy data (long) format. The test
machine with 16 GB of RAM was able to handle the second largest dataset
in the database with 91 million values (rows).

There are still some methods to make data fetching functions perform
faster:

- turn caching off: `get_eurostat(cache = FALSE)`

- turn cache compression off (may result in rather large cache files!):
  `get_eurostat(compress_file = FALSE)`

- if you want faster caching with manageable file sizes, use
  stringsAsFactors:
  `get_eurostat(cache = TRUE, compress_file = TRUE, stringsAsFactors = TRUE)`

- Use faster data.table functions: `get_eurostat(use.data.table = TRUE)`

- Keep column processing to a minimum:
  `get_eurostat(time_format = "raw", type = "code")` etc.

- Read `get_eurostat()` function documentation carefully so you
  understand what different arguments do

- Filter the dataset so that you fetch only the parts you need!

## References

See `citation("eurostat")`:

    Kindly cite the eurostat R package as follows:

      Lahti L., Huovari J., Kainu M., and Biecek P. (2017). Retrieval and
      analysis of Eurostat open data with the eurostat package. The R
      Journal 9(1), pp. 385-392. doi: 10.32614/RJ-2017-019

    A BibTeX entry for LaTeX users is

      @Article{10.32614/RJ-2017-019,
        title = {Retrieval and Analysis of Eurostat Open Data with the eurostat Package},
        author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
        journal = {The R Journal},
        volume = {9},
        number = {1},
        pages = {385--392},
        year = {2017},
        doi = {10.32614/RJ-2017-019},
        url = {https://doi.org/10.32614/RJ-2017-019},
      }

      Lahti, L., Huovari J., Kainu M., Biecek P., Hernangomez D., Antal D.,
      and Kantanen P. (2023). eurostat: Tools for Eurostat Open Data
      [Computer software]. R package version 4.0.0.
      https://github.com/rOpenGov/eurostat

    A BibTeX entry for LaTeX users is

      @Misc{eurostat,
        title = {eurostat: Tools for Eurostat Open Data},
        author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek and Diego Hernangomez and Daniel Antal and Pyry Kantanen},
        url = {https://github.com/rOpenGov/eurostat},
        type = {Computer software},
        year = {2023},
        note = {R package version 4.0.0},
      }

When citing data downloaded from Eurostat, see section "Citing Eurostat
data" in `get_eurostat()` documentation.

## See also

[`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md),
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)

## Author

Przemyslaw Biecek, Leo Lahti, Janne Huovari, Markus Kainu and Pyry
Kantanen

## Examples

``` r
if (FALSE) { # \dontrun{
k <- get_eurostat("nama_10_lp_ulc")
k <- get_eurostat("nama_10_lp_ulc", time_format = "num")
k <- get_eurostat("nama_10_lp_ulc", update_cache = TRUE)

k <- get_eurostat("nama_10_lp_ulc",
  cache_dir = file.path(tempdir(), "r_cache")
)
options(eurostat_update = TRUE)
k <- get_eurostat("nama_10_lp_ulc")
options(eurostat_update = FALSE)

set_eurostat_cache_dir(file.path(tempdir(), "r_cache2"))
k <- get_eurostat("nama_10_lp_ulc")
k <- get_eurostat("nama_10_lp_ulc", cache = FALSE)
k <- get_eurostat("avia_gonc", select_time = "Y", cache = FALSE)

dd <- get_eurostat("nama_10_gdp",
  filters = list(
    geo = "FI",
    na_item = "B1GQ",
    unit = "CLV_I10"
  )
)

# A dataset with multiple time series in one
dd2 <- get_eurostat("AVIA_GOR_ME",
  select_time = c("A", "M", "Q"),
  time_format = "date_last"
)

# An example of downloading whole dataset from JSON API
dd3 <- get_eurostat("AVIA_GOR_ME",
  filters = list()
)

# Filtering a dataset from a local file
dd3_filter <- get_eurostat("AVIA_GOR_ME",
  filters = list(
    tra_meas = "FRM_BRD"
  )
)

} # }
```
