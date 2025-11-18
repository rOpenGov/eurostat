# Clean Eurostat Cache

Delete all .rds files from the eurostat cache directory. See
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
for more on cache.

## Usage

``` r
clean_eurostat_cache(cache_dir = NULL, config = FALSE)
```

## Arguments

- cache_dir:

  A path to cache directory. If `NULL` (default) tries to clean default
  temporary cache directory.

- config:

  Logical `TRUE/FALSE`. Should the cached path be deleted?

## See also

Other cache utilities:
[`set_eurostat_cache_dir()`](https://ropengov.github.io/eurostat/reference/set_eurostat_cache_dir.md)

## Author

Przemyslaw Biecek, Leo Lahti, Janne Huovari, Markus Kainu and Diego
Hernangómez

## Examples

``` r
if (FALSE) { # \dontrun{
clean_eurostat_cache()
} # }
```
