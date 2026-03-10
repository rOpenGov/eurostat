# Recode Region Codes From Source To Target NUTS Typology

These objects are imported from other packages. Follow the links below
to see their documentation.

- regions:

  [`recode_nuts`](https://regions.dataobservatory.eu/reference/recode_nuts.html),
  [`validate_geo_code`](https://regions.dataobservatory.eu/reference/validate_geo_code.html),
  [`validate_nuts_regions`](https://regions.dataobservatory.eu/reference/validate_nuts_regions.html)

## Arguments

- dat:

  A data frame with a 3-5 character `geo_var` variable to be validated.

- geo_var:

  Defaults to `"geo"`. The variable that contains the 3-5 character geo
  codes to be validated.

- geo:

  A vector of geographical code to validate.

- nuts_year:

  A valid NUTS edition year.

## Value

The original data frame with a `'geo_var'` column is extended with a
`'typology'` column that states in which typology is the `'geo_var'` a
valid code. For invalid codes, looks up potential reasons of invalidity
and adds them to the `'typology_change'` column, and at last it adds a
column of character vector containing the desired codes in the target
typology, for example, in the NUTS2013 typology.

Returns the original `dat` data frame with a column that specifies the
comformity with the NUTS definition of the year `nuts_year`.

A character list with the valid typology, or 'invalid' in the cases when
the geo coding is not valid.

## Details

While country codes are technically not part of the NUTS typologies,
Eurostat de facto uses a `NUTS0` typology to identify countries. This de
facto typology has three exception which are handled by the
[validate_nuts_countries](https://regions.dataobservatory.eu/reference/validate_nuts_countries.html)
function.

NUTS typologies have different versions, therefore the conformity is
validated with one specific versions, which can be any of these: `1999`,
`2003`, `2006`, `2010`, `2013`, the currently used `2016` and the
already announced and defined `2021`.

The NUTS typology was codified with the `NUTS2003`, and the pre-1999
NUTS typologies may confuse programmatic data processing, given that
some NUTS1 regions were identified with country codes in smaller
countries that had no `NUTS1` divisions.

Currently the `2016` is used by Eurostat, but many datasets still
contain `2013` and sometimes earlier metadata.

## See also

Other regions functions:
[`add_nuts_level()`](https://ropengov.github.io/eurostat/reference/add_nuts_level.md),
[`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md),
[`recode_to_nuts_2013()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2013.md),
[`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md)

Other regions functions:
[`add_nuts_level()`](https://ropengov.github.io/eurostat/reference/add_nuts_level.md),
[`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md),
[`recode_to_nuts_2013()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2013.md),
[`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md)

Other regions functions:
[`add_nuts_level()`](https://ropengov.github.io/eurostat/reference/add_nuts_level.md),
[`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md),
[`recode_to_nuts_2013()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2013.md),
[`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md)

## Examples

``` r
{
foo <- data.frame (
  geo  =  c("FR", "DEE32", "UKI3" ,
            "HU12", "DED",
            "FRK"),
  values = runif(6, 0, 100 ),
  stringsAsFactors = FALSE )

recode_nuts(foo, nuts_year = 2013)
}
#>     geo     values     typology                           typology_change
#> 1    FR  8.0750138      country                                 unchanged
#> 2  UKI3 60.0760886 nuts_level_2                                 unchanged
#> 3   DED  0.7399441 nuts_level_1                                 unchanged
#> 4   FRK 46.6393497 nuts_level_1 Recoded from FRK [used in NUTS 2016-2021]
#> 5  HU12 15.7208442 nuts_level_2                    Used in NUTS 2016-2021
#> 6 DEE32 83.4333037 nuts_level_3                    Used in NUTS 1999-2003
#>   code_2013
#> 1        FR
#> 2      UKI3
#> 3       DED
#> 4       FR7
#> 5      <NA>
#> 6      <NA>
# \donttest{
my_reg_data <- data.frame(
  geo = c(
    "BE1", "HU102", "FR1",
    "DED", "FR7", "TR", "DED2",
    "EL", "XK", "GB"
  ),
  values = runif(10)
)

validate_nuts_regions(my_reg_data)
#>      geo     values         typology valid_2016
#> 1    BE1 0.49777739     nuts_level_1       TRUE
#> 2  HU102 0.28976724             <NA>      FALSE
#> 3    FR1 0.73288199     nuts_level_1       TRUE
#> 4    DED 0.77252151     nuts_level_1       TRUE
#> 5    FR7 0.87460066 iso-3166-alpha-3      FALSE
#> 6     TR 0.17494063          country       TRUE
#> 7   DED2 0.03424133     nuts_level_2       TRUE
#> 8     EL 0.32038573          country       TRUE
#> 9     XK 0.40232824          country       TRUE
#> 10    GB 0.19566983          country       TRUE

validate_nuts_regions(my_reg_data, nuts_year = 2013)
#>      geo     values     typology valid_2013
#> 1    BE1 0.49777739 nuts_level_1       TRUE
#> 2  HU102 0.28976724 nuts_level_3       TRUE
#> 3    FR1 0.73288199 nuts_level_1       TRUE
#> 4    DED 0.77252151 nuts_level_1       TRUE
#> 5    FR7 0.87460066 nuts_level_1       TRUE
#> 6     TR 0.17494063      country       TRUE
#> 7   DED2 0.03424133 nuts_level_2       TRUE
#> 8     EL 0.32038573      country       TRUE
#> 9     XK 0.40232824      country       TRUE
#> 10    GB 0.19566983      country       TRUE

validate_nuts_regions(my_reg_data, nuts_year = 2003)
#>      geo     values     typology valid_2003
#> 1    BE1 0.49777739 nuts_level_1       TRUE
#> 2  HU102 0.28976724         <NA>      FALSE
#> 3    FR1 0.73288199 nuts_level_1       TRUE
#> 4    DED 0.77252151 nuts_level_1       TRUE
#> 5    FR7 0.87460066 nuts_level_1       TRUE
#> 6     TR 0.17494063      country       TRUE
#> 7   DED2 0.03424133 nuts_level_2       TRUE
#> 8     EL 0.32038573      country       TRUE
#> 9     XK 0.40232824      country       TRUE
#> 10    GB 0.19566983      country       TRUE
# }
# \donttest{
my_reg_data <- data.frame(
  geo = c(
    "BE1", "HU102", "FR1",
    "DED", "FR7", "TR", "DED2",
    "EL", "XK", "GB"
  ),
  values = runif(10)
)

validate_geo_code(my_reg_data$geo)
#>  [1] "nuts_level_1"   "invalid"        "nuts_level_1"   "nuts_level_1"  
#>  [5] "invalid"        "non_eu_country" "nuts_level_2"   "country"       
#>  [9] "non_eu_country" "iso_country"   
# }
```
