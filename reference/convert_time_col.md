# Time Column Conversions for data from new dissemination API

Internal function to convert time column.

## Usage

``` r
convert_time_col(x, time_format)
```

## Arguments

- x:

  A time column (vector) from a downloaded dataset

- time_format:

  one of the following: `date`, `date_last`, or `num`. See
  [`tidy_eurostat()`](https://ropengov.github.io/eurostat/reference/tidy_eurostat.md)
  for more information.
