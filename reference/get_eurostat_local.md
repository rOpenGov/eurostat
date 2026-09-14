# Read Local SDMX-CSV files

**\[experimental\]** Read compressed or uncompressed SDMX-CSV files

## Usage

``` r
get_eurostat_local(
  file,
  time_format = "date",
  type = "code",
  lang = "en",
  select_time = NULL,
  stringsAsFactors = FALSE,
  keepFlags = FALSE,
  legacy.data.output = FALSE
)
```

## Arguments

- file:

  file path as string

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

- type:

  A type of variables, "`code`" (default), "`label`" or "`both`". The
  parameter "`both`" will return a data_frame with named vectors, labels
  as values and codes as names.

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

- select_time:

  a character symbol for a time frequency or `NULL`, which is used by
  default as most datasets have just one time frequency. For datasets
  with multiple time frequencies, select one or more of the desired
  frequencies with: "Y" (or "A") = annual, "S" = semi-annual / semester,
  "Q" = quarterly, "M" = monthly, "W" = weekly. For all frequencies in
  same data frame `time_format = "raw"` should be used.

- stringsAsFactors:

  if `TRUE` (the default) variables are converted to factors in the
  original Eurostat order. If `FALSE` they are returned as strings.

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

## Details

This implementation is experimental. It uses only data.table methods to
read and wrangle data files.

Download datasets in sdmx-csv format from
<https://ec.europa.eu/eurostat/databrowser/bulk?lang=en>
