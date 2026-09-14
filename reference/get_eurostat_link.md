# Download Eurostat Data from API Link (robust, no list-columns, async-aware)

**\[experimental\]**

Supports TSV, SDMX-CSV, SDMX-ML, JSON-stat, and Spreadsheet (.xlsx)
formats. Always returns a tibble where possible.

## Usage

``` r
get_eurostat_link(link, destfile = NULL, verbose = TRUE)
```

## Arguments

- link:

  Eurostat "Copy API link" URL or Data Browser download link

- destfile:

  Optional file path for saving raw files (only for Excel)

- verbose:

  Output messages when downloading data. Default is `TRUE`.

## Value

Tibble for all supported formats
