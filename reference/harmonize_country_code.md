# Harmonize Country Code

The European Commission and the Eurostat generally uses ISO 3166-1
alpha-2 codes with two exceptions: EL (not GR) is used to represent
Greece, and UK (not GB) is used to represent the United Kingdom. This
function turns country codes into to ISO 3166-1 alpha-2.

## Usage

``` r
harmonize_country_code(x)
```

## Arguments

- x:

  A character or a factor vector of eurostat countycodes.

## Value

a vector.

## See also

Other helpers:
[`cut_to_classes()`](https://ropengov.github.io/eurostat/reference/cut_to_classes.md),
[`dic_order()`](https://ropengov.github.io/eurostat/reference/dic_order.md),
[`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md),
[`eurotime2num()`](https://ropengov.github.io/eurostat/reference/eurotime2num.md),
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)

## Author

Janne Huovari <janne.huovari@ptt.fi>

## Examples

``` r
# \donttest{
lp <- get_eurostat("nama_10_lp_ulc")
#> Dataset query already saved in cache_list.json...
#> Reading cache file /tmp/RtmpnHI0fi/eurostat/acd6add385173f70e480efba6eb2dba8.rds
#> Table  nama_10_lp_ulc  read from cache file:  /tmp/RtmpnHI0fi/eurostat/acd6add385173f70e480efba6eb2dba8.rds
lp$geo <- harmonize_country_code(lp$geo)
# }
```
