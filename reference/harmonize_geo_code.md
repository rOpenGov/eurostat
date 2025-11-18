# Harmonize NUTS region codes that changed with the `NUTS2016` definition

Eurostat mixes `NUTS2013` and `NUTS2016` geographic label codes in the
`'geo'` column, which creates time-wise comparativity issues. This
deprecated function checked if you data is affected by this problem and
gives information on what to do.

This function is deprecated, and a more general function was moved to
[`regions::validate_nuts_regions()`](https://regions.dataobservatory.eu/reference/validate_nuts_regions.html).

## Usage

``` r
harmonize_geo_code(dat)
```

## Arguments

- dat:

  A Eurostat data frame downloaded with
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)

## Value

An augmented data frame that explains potential problems and possible
solutions.

## See also

[`regions::validate_nuts_regions()`](https://regions.dataobservatory.eu/reference/validate_nuts_regions.html)

Other regions functions:
[`add_nuts_level()`](https://ropengov.github.io/eurostat/reference/add_nuts_level.md),
[`recode_to_nuts_2013()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2013.md),
[`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md),
`reexports`

## Author

Daniel Antal

## Examples

``` r
dat <- eurostat::tgs00026
regions::validate_nuts_regions(dat)
#> # A tibble: 2,723 × 8
#>    unit              direct na_item geo   time  values typology     valid_2016
#>    <chr>             <chr>  <chr>   <chr> <chr>  <dbl> <chr>        <lgl>     
#>  1 PPS_EU27_2020_HAB BAL    B6N     AT11  2009   18900 nuts_level_2 TRUE      
#>  2 PPS_EU27_2020_HAB BAL    B6N     AT12  2009   19900 nuts_level_2 TRUE      
#>  3 PPS_EU27_2020_HAB BAL    B6N     AT13  2009   19800 nuts_level_2 TRUE      
#>  4 PPS_EU27_2020_HAB BAL    B6N     AT21  2009   18500 nuts_level_2 TRUE      
#>  5 PPS_EU27_2020_HAB BAL    B6N     AT22  2009   18700 nuts_level_2 TRUE      
#>  6 PPS_EU27_2020_HAB BAL    B6N     AT31  2009   19300 nuts_level_2 TRUE      
#>  7 PPS_EU27_2020_HAB BAL    B6N     AT32  2009   19600 nuts_level_2 TRUE      
#>  8 PPS_EU27_2020_HAB BAL    B6N     AT33  2009   18700 nuts_level_2 TRUE      
#>  9 PPS_EU27_2020_HAB BAL    B6N     AT34  2009   19700 nuts_level_2 TRUE      
#> 10 PPS_EU27_2020_HAB BAL    B6N     BE10  2009   15400 nuts_level_2 TRUE      
#> # ℹ 2,713 more rows
```
