# Get Eurostat Data from SDMX 2.1 API

**\[experimental\]**

Download data sets from Eurostat using the same logic as
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
function.

## Usage

``` r
get_eurostat_sdmx(
  id,
  time_format = "date",
  filters = NULL,
  type = "code",
  lang = "en",
  use.data.table = FALSE,
  agency = "Eurostat",
  compressed = TRUE,
  keepFlags = FALSE,
  legacy.data.output = FALSE,
  wait = 10,
  max_wait = 600,
  verbose = TRUE
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
  [`base::Date()`](https://rdrr.io/r/base/Dates.html) class with the
  date being the first day of the period. A "`date_last`" argument
  converts the dataset date to a
  [`base::Date()`](https://rdrr.io/r/base/Dates.html) class object with
  the difference that the exact date is the last date of the period.
  Period can be year, semester (half year), quarter, month, or week (See
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

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

- use.data.table:

  Use data.table to process files? Default is FALSE. If data.table is
  used, data will be downloaded as a TSV file and processed using
  [`tidy_eurostat()`](https://ropengov.github.io/eurostat/reference/tidy_eurostat.md)

- agency:

  Either "Eurostat" (default), "Eurostat_comext" (for Comext and Prodcom
  datasets), "COMP", "EMPL" or "GROW"

- compressed:

  Logical. Download data in compressed format? Default is TRUE.

- keepFlags:

  a logical whether the flags (e.g. "confidential", "provisional")
  should be kept in a separate column or if they can be removed. Default
  is `FALSE`. For flag values see information:
  <https://ec.europa.eu/eurostat/data/database#Flags>. Also possible
  non-real zero "0n" is indicated in flags column. Flags are not
  available for eurostat API, so `keepFlags` can not be used with a
  `filters`.

- legacy.data.output:

  Use legacy column names and data object structure. Default is FALSE.
  If TRUE, the object will try to emulate the naming conventions of
  eurostat package version 3.7.x and earlier.

- wait:

  Integer. Seconds between status checks. Default is 1 second.

- max_wait:

  Integer. Max time to wait in seconds. Default is 60 seconds.

- verbose:

  Output messages when downloading data. Default is `TRUE`.

## Details

This function is experimental because while it works as intended and is
useful in the same way as other get\_ functions in the package, we would
like to test it for a while and listen to user feedback before deciding
on what is the best way to interact with SDMX APIs.
