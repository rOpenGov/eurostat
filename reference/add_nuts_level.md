# Add the statistical aggregation level to data frame

Eurostat regional statistics contain country, and various regional level
information. In many cases, for example, when mapping, it is useful to
filter out national level data from NUTS2 level regional data, for
example.

This function will be deprecated. Use the more comprehensive
`[regions::validate_nuts_regions()]` instead.

## Usage

``` r
add_nuts_level(dat, geo_labels = "geo")
```

## Arguments

- dat:

  A data frame or tibble returned by
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).

- geo_labels:

  A geographical label, defaults to `geo`.

## Value

a new numeric variable nuts_level with the numeric value of NUTS level 0
(country), 1 (greater region), 2 (region), 3 (small region).

## Details

DEPRECATED FUNCTIONS FOR BACKWARD COMPATIBILITY FUNCTIONS GIVE WARNING
AND CALL APPROPRIATE regions FUNCTIONS

## See also

[`regions::validate_nuts_regions()`](https://regions.dataobservatory.eu/reference/validate_nuts_regions.html)

Other regions functions:
[`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md),
[`recode_to_nuts_2013()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2013.md),
[`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md),
`reexports`

## Author

Daniel Antal

## Examples

``` r
dat <- data.frame(
  geo    = c("FR", "IE04", "DEB1C"),
  values = c(1000, 23, 12)
)

add_nuts_level(dat)
#> This function will be deprecated. Use regions::validate_nuts_regions() instead.
#>     geo values     typology valid_2016 nuts_level
#> 1    FR   1000      country       TRUE          0
#> 2  IE04     23 nuts_level_2       TRUE          2
#> 3 DEB1C     12 nuts_level_3       TRUE          3
```
