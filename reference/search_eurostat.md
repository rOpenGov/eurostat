# Grep Datasets Titles from Eurostat

Lists datasets from eurostat table of contents with the particular
pattern in item titles.

## Usage

``` r
search_eurostat(
  pattern,
  type = "dataset",
  column = "title",
  fixed = TRUE,
  lang = "en"
)
```

## Arguments

- pattern:

  Text string that is used to search from dataset, folder or table
  titles, depending on the type argument.

- type:

  Selection for types of datasets to be searched. Default is `dataset`,
  other possible options are `table`, `folder` and `all` for all types.

- column:

  Selection for the column of TOC where search is done. Default is
  `title`, other possible option is `code`.

- fixed:

  logical. If TRUE (default), pattern is a string to be matched as is.
  See [`grep()`](https://rdrr.io/r/base/grep.html) documentation for
  more information.

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

Downloads list of all datasets available on eurostat and return list of
names of datasets that contains particular pattern in the dataset
description. E.g. all datasets related to education of teaching.

If you wish to perform searches on other fields than item title, you can
download the Eurostat Table of Contents manually using
[`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md)
function and use [`grep()`](https://rdrr.io/r/base/grep.html) function
normally. The data browser on Eurostat website may also return useful
results.

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
`search_eurostat()`

## Author

Przemyslaw Biecek and Leo Lahti <ropengov-forum@googlegroups.com>

## Examples

``` r
# \donttest{
tmp <- search_eurostat("education")
head(tmp)
#> # A tibble: 6 × 9
#>   title        code  type  last.update.of.data last.table.structure…¹ data.start
#>   <chr>        <chr> <chr> <chr>               <chr>                  <chr>     
#> 1 Population … cens… data… 01.04.2019          10.01.2024             2011      
#> 2 Population … cens… data… 26.08.2015          10.01.2024             2011      
#> 3 Employed pe… cens… data… 27.03.2009          14.10.2024             2001      
#> 4 Population … cens… data… 27.03.2009          14.10.2024             2001      
#> 5 Pupils enro… educ… data… 02.02.2026          02.02.2026             2013      
#> 6 Pupils enro… educ… data… 02.02.2026          02.02.2026             2013      
#> # ℹ abbreviated name: ¹​last.table.structure.change
#> # ℹ 3 more variables: data.end <chr>, values <dbl>, hierarchy <dbl>
# Use "fixed = TRUE" when pattern has characters that would need escaping.
# Here, parentheses would normally need to be escaped in regex
tmp <- search_eurostat("Live births (total) by NUTS 3 region", fixed = TRUE)
# }
```
