# Set Eurostat Cache

This function will store your `cache_dir` path on your local machine and
would load it for future sessions. Type
`Sys.getenv("EUROSTAT_CACHE_DIR")` to find your cached path.

Alternatively, you can store the `cache_dir` manually with the following
options:

- Run `Sys.setenv(EUROSTAT_CACHE_DIR = "cache_dir")`. You would need to
  run this command on each session (Similar to `install = FALSE`).

- Set `options(eurostat_cache_dir = "cache_dir")`. Similar to the
  previous option. This is provided for backwards compatibility
  purposes.

- Write this line on your .Renviron file:
  `EUROSTAT_CACHE_DIR = "value_for_cache_dir"` (same behavior than
  `install = TRUE`). This would store your `cache_dir` permanently.

## Usage

``` r
set_eurostat_cache_dir(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
)
```

## Arguments

- cache_dir:

  A path to a cache directory. On missing value the function would store
  the cached files on a temporary dir (See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- overwrite:

  If this is set to `TRUE`, it will overwrite an existing
  `EUROSTAT_CACHE_DIR` that you already have in local machine.

- install:

  if `TRUE`, will install the key in your local machine for use in
  future sessions. Defaults to `FALSE`. If `cache_dir` is `FALSE` this
  parameter is set to `FALSE` automatically.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

An (invisible) character with the path to your `cache_dir`.

## See also

[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)

Other cache utilities:
[`clean_eurostat_cache()`](https://ropengov.github.io/eurostat/reference/clean_eurostat_cache.md)

## Author

Diego Hernangómez

## Examples

``` r
# Don't run this! It would modify your current state
if (FALSE) { # \dontrun{
set_eurostat_cache_dir(verbose = TRUE)
} # }

Sys.getenv("EUROSTAT_CACHE_DIR")
#> [1] "/tmp/Rtmp6a05NR/eurostat"
```
