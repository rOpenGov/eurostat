# Get Eurostat data interactive

A simple interactive helper function to go through the steps of
downloading and/or finding suitable eurostat datasets.

## Usage

``` r
get_eurostat_interactive(code = NULL)
```

## Arguments

- code:

  A unique identifier / code for the dataset of interest. If code is not
  known
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  function can be used to search Eurostat table of contents.

## Details

This function is intended to enable easy exploration of different
eurostat package functionalities and functions. In order to not drown
the end user in endless menus this function does not allow for setting
all possible
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
function arguments. It is possible to set `time_format`, `type`, `lang`,
`stringsAsFactors`, `keepFlags`, and `use.data.table` in the interactive
menus.

In some datasets setting these parameters may result in a "Error in
label_eurostat" error, for example: "labels for XXXXXX includes
duplicated labels in the Eurostat dictionary". In these cases, and with
other more complex queries, please use
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
function directly.

## See also

[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
