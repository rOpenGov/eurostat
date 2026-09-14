# Transform CSV files into Row-Column-Value Format data.table object

Transform raw Eurostat TSV files downloaded from the API into a tidy
row-column-value format (RCV).

## Usage

``` r
tidy_eurostat_sdmx_csv(
  dat,
  time_format = "date",
  select_time = NULL,
  keepFlags = FALSE
)
```

## Arguments

- dat:

  a data_frame from
  [`get_eurostat_raw()`](https://ropengov.github.io/eurostat/reference/get_eurostat_raw.md).

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

- select_time:

  a character symbol for a time frequency or `NULL`, which is used by
  default as most datasets have just one time frequency. For datasets
  with multiple time frequencies, select one or more of the desired
  frequencies with: "Y" (or "A") = annual, "S" = semi-annual / semester,
  "Q" = quarterly, "M" = monthly, "W" = weekly. For all frequencies in
  same data frame `time_format = "raw"` should be used.

- keepFlags:

  a logical whether the flags (e.g. "confidential", "provisional")
  should be kept in a separate column or if they can be removed. Default
  is `FALSE`. For flag values see information:
  <https://ec.europa.eu/eurostat/data/database#Flags>. Also possible
  non-real zero "0n" is indicated in flags column. Flags are not
  available for eurostat API, so `keepFlags` can not be used with a
  `filters`.

## Value

data.table object in the melted format with the last column 'values' or
'OBS_VALUE'.

## Details

Can read only SDMX-CSV files, in compressed (.csv.gz) and uncompressed
(.csv) format. As opposed to regular tidy_eurostat function,
stringsAsFactors is determined outside this function, in
[`get_eurostat_local()`](https://ropengov.github.io/eurostat/reference/get_eurostat_local.md).

## References

See `citation("eurostat")`:

    Kindly cite this package by citing the following R Journal article:

      Lahti L., Huovari J., Kainu M., and Biecek P. (2017). Retrieval and
      analysis of Eurostat open data with the eurostat package. The R
      Journal 9(1), pp. 385-392. doi: 10.32614/RJ-2017-019

    In addition, please provide a citation to the specific software version
    used:

      Lahti L, Huovari J, Kainu M, Biecek P, Hernangomez D, Antal D,
      Kantanen P (2026). "eurostat: Tools for Eurostat Open Data."
      doi:10.32614/CRAN.package.eurostat
      <https://doi.org/10.32614/CRAN.package.eurostat>. R package version
      4.1.0, <https://github.com/rOpenGov/eurostat>.

    To see these entries in BibTeX format, use 'print(<citation>,
    bibtex=TRUE)', 'toBibtex(.)', or set
    'options(citation.bibtex.max=999)'.

When citing data downloaded from Eurostat, see section "Citing Eurostat
data" in
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
documentation.

## See also

[`get_eurostat_local()`](https://ropengov.github.io/eurostat/reference/get_eurostat_local.md)

## Author

Pyry Kantanen
