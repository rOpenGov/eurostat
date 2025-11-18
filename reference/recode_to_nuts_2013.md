# Recode geo labels and rename regions from NUTS2016 to NUTS2013

Eurostat mixes NUTS2013 and NUTS2016 geographic label codes in the
`'geo'` column, which creates time-wise comparativity issues.

This function is deprecated, and a more general function was moved to
`[regions::recode_nuts()]`.

## Usage

``` r
recode_to_nuts_2013(dat)
```

## Arguments

- dat:

  A Eurostat data frame downloaded with
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).

## Value

An augmented and potentially relabelled data frame which contains all
formerly `'NUTS2013'` definition geo labels in the `'NUTS2016'`
vocabulary when only the code changed, but the boundary did not. It also
contains some information on other geo labels that cannot be brought to
the current `'NUTS2013'` definition. Furthermore, when the official name
of the region changed, it will use the new name (if the otherwise the
region boundary did not change.) If not called before, the function will
use the helper function
[`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md)

## See also

[`regions::recode_nuts()`](https://regions.dataobservatory.eu/reference/recode_nuts.html)

Other regions functions:
[`add_nuts_level()`](https://ropengov.github.io/eurostat/reference/add_nuts_level.md),
[`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md),
[`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md),
`reexports`

## Author

Daniel Antal

## Examples

``` r
test_regional_codes <- data.frame(
  geo = c("FRB", "FRE", "UKN02", "IE022", "FR243", "FRB03"),
  time = c(rep(as.Date("2014-01-01"), 5), as.Date("2015-01-01")),
  values = c(1:6),
  control = c(
    "Changed from NUTS2 to NUTS1",
    "New region NUTS2016 only",
    "Discontinued region NUTS2013",
    "Boundary shift NUTS2013",
    "Recoded in NUTS2013",
    "Recoded in NUTS2016"
  )
)

recode_to_nuts_2013(test_regional_codes)
#> Warning: The 'recode_to_nuts_2013' function is deprecated. Use instead regions::recode_nuts(dat, nuts_year = 2013)
#>     geo       time values                      control     typology
#> 1 UKN02 2014-01-01      3 Discontinued region NUTS2013 nuts_level_3
#> 2 IE022 2014-01-01      4      Boundary shift NUTS2013 nuts_level_3
#> 3 FR243 2014-01-01      5          Recoded in NUTS2013 nuts_level_3
#> 4 FRB03 2015-01-01      6          Recoded in NUTS2016 nuts_level_3
#> 5   FRB 2014-01-01      1  Changed from NUTS2 to NUTS1 nuts_level_1
#> 6   FRE 2014-01-01      2     New region NUTS2016 only nuts_level_1
#>                               typology_change code_2013
#> 1                                   unchanged     UKN02
#> 2                                   unchanged     IE022
#> 3                                   unchanged     FR243
#> 4 Recoded from FRB03 [used in NUTS 2016-2021]     FR243
#> 5                      Used in NUTS 2016-2021      <NA>
#> 6                      Used in NUTS 2016-2021      <NA>
```
