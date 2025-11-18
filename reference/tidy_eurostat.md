# Transform Data into Row-Column-Value Format

Transform raw Eurostat data table downloaded from the API into a tidy
row-column-value format (RCV).

## Usage

``` r
tidy_eurostat(
  dat,
  time_format = "date",
  select_time = NULL,
  stringsAsFactors = FALSE,
  keepFlags = FALSE,
  use.data.table = FALSE
)
```

## Arguments

- dat:

  a data_frame from
  [`get_eurostat_raw()`](https://ropengov.github.io/eurostat/reference/get_eurostat_raw.md).

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
  is `FALSE`. For flag values see:
  <https://ec.europa.eu/eurostat/data/database/information>. Also
  possible non-real zero "0n" is indicated in flags column. Flags are
  not available for eurostat API, so `keepFlags` can not be used with a
  `filters`.

- use.data.table:

  Use faster data.table functions? Default is FALSE. On Windows requires
  that RTools is installed.

## Value

tibble in the melted format with the last column 'values'.

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
data" in
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
documentation.

## See also

[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md),
[`convert_time_col()`](https://ropengov.github.io/eurostat/reference/convert_time_col.md),
[`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md)

## Author

Przemyslaw Biecek, Leo Lahti, Janne Huovari and Pyry Kantanen

## Examples

``` r
if (FALSE) { # \dontrun{
# Example of a dataset with multiple time series
get_eurostat("AVIA_GOR_ME",
  time_format = "date_last",
  cache = F
  )
} # }
```
