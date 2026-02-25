# Download Table of Contents of Eurostat Data Sets

Download table of contents (TOC) of eurostat datasets.

## Usage

``` r
get_eurostat_toc(lang = "en")
```

## Arguments

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

## Value

A tibble with nine columns:

- title:

  Dataset title in English (default)

- code:

  Each item (dataset, table and folder) of the TOC has a unique code
  which allows it to be identified in the API. Used in the
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  and
  [`get_eurostat_raw()`](https://ropengov.github.io/eurostat/reference/get_eurostat_raw.md)
  functions to retrieve datasets.

- type:

  dataset, folder or table

- last.update.of.data:

  Date, indicates the last time the dataset/table was updated (format
  `DD.MM.YYYY` or `%d.%m.%Y`)

- last.table.structure.change:

  Date, indicates the last time the dataset/table structure was modified
  (format `DD.MM.YYYY` or `%d.%m.%Y`)

- data.start:

  Date of the oldest value included in the dataset (if available)
  (format usually `YYYY` or `%Y` but can also be `YYYY-MM`,
  `YYYY-MM-DD`, `YYYY-SN`, `YYYY-QN` etc.)

- data.end:

  Date of the most recent value included in the dataset (if available)
  (format usually `YYYY` or `%Y` but can also be `YYYY-MM`,
  `YYYY-MM-DD`, `YYYY-SN`, `YYYY-QN` etc.)

- values:

  Number of actual values included in the dataset

- hierarchy:

  Hierarchy of the data navigation tree, represented in the original txt
  file by a 4-spaces indentation prefix in the title

## Details

In the downloaded Eurostat Table of Contents the 'code' column values
are refer to the function 'id' that is used as an argument in certain
functions when downloading datasets.

## Data source: Eurostat Table of Contents

The Eurostat Table of Contents (TOC) is downloaded from
<https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=en>
(default) or from French or German language variants:
<https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=fr>
<https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=de>

See Eurostat documentation on TOC items:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+-+Detailed+guidelines+-+Catalogue+API+-+TOC>

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
[`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)

## Author

Przemyslaw Biecek, Leo Lahti and Pyry Kantanen
<ropengov-forum@googlegroups.com>

## Examples

``` r
# \donttest{
tmp <- get_eurostat_toc()
#> Warning: One or more parsing issues, call `problems()` on your data frame for details,
#> e.g.:
#>   dat <- vroom(...)
#>   problems(dat)
head(tmp)
#> # A tibble: 6 × 9
#>   title        code  type  last.update.of.data last.table.structure…¹ data.start
#>   <chr>        <chr> <chr> <chr>               <chr>                  <chr>     
#> 1 Database by… data  fold… " "                 " "                    " "       
#> 2 General and… gene… fold… " "                 " "                    " "       
#> 3 European an… euro… fold… " "                 " "                    " "       
#> 4 Balance of … ei_bp fold… " "                 " "                    " "       
#> 5 Current acc… ei_b… table "19.02.2026"        "19.02.2026"           "1991-Q1" 
#> 6 Financial a… ei_b… table "19.02.2026"        "19.02.2026"           "1991-Q1" 
#> # ℹ abbreviated name: ¹​last.table.structure.change
#> # ℹ 3 more variables: data.end <chr>, values <dbl>, hierarchy <dbl>

# Convert columns containing dates as character into Date class
# Last update of data
tmp[[4]] <- as.Date(tmp[[4]], format = c("%d.%m.%Y"))
# Last table structure change
tmp[[5]] <- as.Date(tmp[[5]], format = c("%d.%m.%Y"))
# Data start, contains several formats (date, week, month quarter, semester)
# Unfortunately semesters are not directly supported so they need to be
# changed into quarters
tmp$data.start <- gsub("S2", "Q3", tmp$data.start)
tmp$data.start <- lubridate::as_date(
 x = tmp$data.start, 
 format = c("%Y", "%Y-Q%q", "%Y-W%W", "%Y-S%q", "%Y-%m-%d", "%Y-%m")
 )
#> Warning:  1927 failed to parse.
# Data end, same as data start
tmp$data.end <- gsub("S2", "Q3", tmp$data.end)
tmp$data.end <- lubridate::as_date(
 x = tmp$data.end, 
 format = c("%Y", "%Y-Q%q", "%Y-W%W", "%Y-S%q", "%Y-%m-%d", "%Y-%m")
 )
#> Warning:  1927 failed to parse.
# }
```
