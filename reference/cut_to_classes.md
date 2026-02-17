# Cuts the Values Column into Classes and Polishes the Labels

Categorises a numeric vector into automatic or manually defined
categories and polishes the labels ready for used in mapping with
`ggplot2`.

## Usage

``` r
cut_to_classes(
  x,
  n = 5,
  style = "equal",
  manual = FALSE,
  manual_breaks = NULL,
  decimals = 0,
  nodata_label = "No data"
)
```

## Arguments

- x:

  A numeric vector, eg. `values` variable in data returned by
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).

- n:

  A numeric. number of classes/categories

- style:

  chosen style: one of "fixed", "sd", "equal", "pretty", "quantile",
  "kmeans", "hclust", "bclust", "fisher", "jenks", "dpih", "headtails",
  "maximum", or "box"

- manual:

  Logical. If manual breaks are being used

- manual_breaks:

  Numeric vector with manual threshold values

- decimals:

  Number of decimals to include with labels

- nodata_label:

  String. Text label for NA category.

## Value

a factor.

## See also

[`classInt::classIntervals()`](https://r-spatial.github.io/classInt/reference/classIntervals.html)

Other helpers:
[`dic_order()`](https://ropengov.github.io/eurostat/reference/dic_order.md),
[`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md),
[`eurotime2num()`](https://ropengov.github.io/eurostat/reference/eurotime2num.md),
[`harmonize_country_code()`](https://ropengov.github.io/eurostat/reference/harmonize_country_code.md),
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)

## Author

Markus Kainu <markuskainu@gmail.com>

## Examples

``` r
# \donttest{
# lp <- get_eurostat("nama_aux_lp")
lp <- get_eurostat("nama_10_lp_ulc")
#> Table nama_10_lp_ulc cached at /tmp/RtmpnHI0fi/eurostat/acd6add385173f70e480efba6eb2dba8.rds
lp$class <- cut_to_classes(lp$values, n = 5, style = "equal", decimals = 1)
#> Warning: var has missing values, omitted in finding classes
#> Warning: var has missing values, omitted in finding classes
# }
```
