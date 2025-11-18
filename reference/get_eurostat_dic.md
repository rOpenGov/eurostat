# Download Eurostat Dictionary

Download a Eurostat dictionary.

## Usage

``` r
get_eurostat_dic(dictname, lang = "en")
```

## Arguments

- dictname:

  A character, dictionary for the variable to be downloaded.

- lang:

  A character, language code. Options: "en" (default), "fr", "de".

## Value

tibble with two columns: code names and full names.

## Details

For given coded variable from Eurostat <https://ec.europa.eu/eurostat/>.
The dictionaries link codes with human-readable labels. To translate
codes to labels, use
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md).

## References

See `citation("eurostat")`:

    # Kindly cite the eurostat R package as follows:
    #
    #   Lahti L., Huovari J., Kainu M., and Biecek P. (2017). Retrieval and
    #   analysis of Eurostat open data with the eurostat package. The R
    #   Journal 9(1), pp. 385-392. doi: 10.32614/RJ-2017-019
    #
    # A BibTeX entry for LaTeX users is
    #
    #   @Article{10.32614/RJ-2017-019,
    #     title = {Retrieval and Analysis of Eurostat Open Data with the eurostat Package},
    #     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
    #     journal = {The R Journal},
    #     volume = {9},
    #     number = {1},
    #     pages = {385--392},
    #     year = {2017},
    #     doi = {10.32614/RJ-2017-019},
    #     url = {https://doi.org/10.32614/RJ-2017-019},
    #   }
    #
    #   Lahti, L., Huovari J., Kainu M., Biecek P., Hernangomez D., Antal D.,
    #   and Kantanen P. (2023). eurostat: Tools for Eurostat Open Data
    #   [Computer software]. R package version 4.0.0.
    #   https://github.com/rOpenGov/eurostat
    #
    # A BibTeX entry for LaTeX users is
    #
    #   @Misc{eurostat,
    #     title = {eurostat: Tools for Eurostat Open Data},
    #     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek and Diego Hernangomez and Daniel Antal and Pyry Kantanen},
    #     url = {https://github.com/rOpenGov/eurostat},
    #     type = {Computer software},
    #     year = {2023},
    #     note = {R package version 4.0.0},
    #   }

## See also

[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md),
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md),
[`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md).

## Author

Przemyslaw Biecek and Leo Lahti <leo.lahti@iki.fi>. Thanks to Wietse Dol
for contributions. Updated by Pyry Kantanen to support XML codelists.

## Examples

``` r
# \donttest{
get_eurostat_dic("crop_pro")
#> # A tibble: 25 × 2
#>    code_name full_name                                                       
#>    <chr>     <chr>                                                           
#>  1 C1050     Cereals (excluding rice)                                        
#>  2 C1120     Common wheat and spelt                                          
#>  3 C1130     Durum wheat                                                     
#>  4 C1160     Barley                                                          
#>  5 C1200     Grain maize                                                     
#>  6 C1250     Rice                                                            
#>  7 C1360     Potatoes (including early potatoes and seed potatoes)           
#>  8 C1370     Sugar beet (excluding seed)                                     
#>  9 C1410     Oilseeds                                                        
#> 10 C1600     Vegetables, melons and strawberries (excluding  kitchen gardens)
#> # ℹ 15 more rows

# Try another language
get_eurostat_dic("crop_pro", lang = "fr")
#> # A tibble: 25 × 2
#>    code_name full_name                                                       
#>    <chr>     <chr>                                                           
#>  1 C1050     Céréales (à l'exception du riz)                                 
#>  2 C1120     Blé tendre et épeautre                                          
#>  3 C1130     Blé dur                                                         
#>  4 C1160     Orge                                                            
#>  5 C1200     Maïs-grain                                                      
#>  6 C1250     Riz                                                             
#>  7 C1360     Pommes de terre (y compris les primeurs et les plants)          
#>  8 C1370     Betterave sucrière (à l'exception des semences)                 
#>  9 C1410     Plantes oléagineuses                                            
#> 10 C1600     Légumes, melons et fraises (à l'exception des jardins familiaux)
#> # ℹ 15 more rows
# }
```
