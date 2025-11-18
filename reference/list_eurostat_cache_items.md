# Output cache information as data.frame

Parses cache_list.json file and returns a data.frame

## Usage

``` r
list_eurostat_cache_items(cache_dir = NULL)
```

## Arguments

- cache_dir:

  a path to a cache directory. `NULL` (default) uses and creates
  'eurostat' directory in the temporary directory defined by base R
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) function. The user
  can set the cache directory to an existing directory by using this
  argument. The cache directory can also be set with
  [`set_eurostat_cache_dir()`](https://ropengov.github.io/eurostat/reference/set_eurostat_cache_dir.md)
  function.

## Value

A data.frame object with 3 columns: dataset code, download date and
query md5 hash
