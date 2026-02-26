# Date Conversion from New Eurostat Time Format

Date conversion from Eurostat time format. A function to convert
Eurostat time values to objects of class
[`Date()`](https://rdrr.io/r/base/Dates.html) representing calendar
dates.

## Usage

``` r
eurotime2date(x, last = FALSE)
```

## Arguments

- x:

  a charter string with time information in Eurostat time format.

- last:

  a logical. If `FALSE` (default) the date is the first date of the
  period (month, quarter or year). If `TRUE` the date is the last date
  of the period.

## Value

an object of class [`Date()`](https://rdrr.io/r/base/Dates.html).

## Details

Available patterns are YYYY (year), YYYY-SN (semester), YYYY-QN
(quarter), YYYY-MM (month), YYYY-WNN (week) and YYYY-MM-DD (day).

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

[`lubridate::ymd()`](https://lubridate.tidyverse.org/reference/ymd.html)

Other helpers:
[`cut_to_classes()`](https://ropengov.github.io/eurostat/reference/cut_to_classes.md),
[`dic_order()`](https://ropengov.github.io/eurostat/reference/dic_order.md),
[`eurotime2num()`](https://ropengov.github.io/eurostat/reference/eurotime2num.md),
[`harmonize_country_code()`](https://ropengov.github.io/eurostat/reference/harmonize_country_code.md),
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)

## Author

Janne Huovari <janne.huovari@ptt.fi>

## Examples

``` r
# \donttest{
na_q <- get_eurostat("namq_10_pc", time_format = "raw")
#> Table namq_10_pc cached at /tmp/Rtmpk5vgHn/eurostat/320ac949cd393396b6257171b450d86f.rds
na_q$TIME_PERIOD <- eurotime2date(x = na_q$TIME_PERIOD)
unique(na_q$TIME_PERIOD)
#>   [1] "1995-01-01" "1995-04-01" "1995-07-01" "1995-10-01" "1996-01-01"
#>   [6] "1996-04-01" "1996-07-01" "1996-10-01" "1997-01-01" "1997-04-01"
#>  [11] "1997-07-01" "1997-10-01" "1998-01-01" "1998-04-01" "1998-07-01"
#>  [16] "1998-10-01" "1999-01-01" "1999-04-01" "1999-07-01" "1999-10-01"
#>  [21] "2000-01-01" "2000-04-01" "2000-07-01" "2000-10-01" "2001-01-01"
#>  [26] "2001-04-01" "2001-07-01" "2001-10-01" "2002-01-01" "2002-04-01"
#>  [31] "2002-07-01" "2002-10-01" "2003-01-01" "2003-04-01" "2003-07-01"
#>  [36] "2003-10-01" "2004-01-01" "2004-04-01" "2004-07-01" "2004-10-01"
#>  [41] "2005-01-01" "2005-04-01" "2005-07-01" "2005-10-01" "2006-01-01"
#>  [46] "2006-04-01" "2006-07-01" "2006-10-01" "2007-01-01" "2007-04-01"
#>  [51] "2007-07-01" "2007-10-01" "2008-01-01" "2008-04-01" "2008-07-01"
#>  [56] "2008-10-01" "2009-01-01" "2009-04-01" "2009-07-01" "2009-10-01"
#>  [61] "2010-01-01" "2010-04-01" "2010-07-01" "2010-10-01" "2011-01-01"
#>  [66] "2011-04-01" "2011-07-01" "2011-10-01" "2012-01-01" "2012-04-01"
#>  [71] "2012-07-01" "2012-10-01" "2013-01-01" "2013-04-01" "2013-07-01"
#>  [76] "2013-10-01" "2014-01-01" "2014-04-01" "2014-07-01" "2014-10-01"
#>  [81] "2015-01-01" "2015-04-01" "2015-07-01" "2015-10-01" "2016-01-01"
#>  [86] "2016-04-01" "2016-07-01" "2016-10-01" "2017-01-01" "2017-04-01"
#>  [91] "2017-07-01" "2017-10-01" "2018-01-01" "2018-04-01" "2018-07-01"
#>  [96] "2018-10-01" "2019-01-01" "2019-04-01" "2019-07-01" "2019-10-01"
#> [101] "2020-01-01" "2020-04-01" "2020-07-01" "2020-10-01" "2021-01-01"
#> [106] "2021-04-01" "2021-07-01" "2021-10-01" "2022-01-01" "2022-04-01"
#> [111] "2022-07-01" "2022-10-01" "2023-01-01" "2023-04-01" "2023-07-01"
#> [116] "2023-10-01" "2024-01-01" "2024-04-01" "2024-07-01" "2024-10-01"
#> [121] "2025-01-01" "2025-04-01" "2025-07-01" "1991-01-01" "1991-04-01"
#> [126] "1991-07-01" "1991-10-01" "1992-01-01" "1992-04-01" "1992-07-01"
#> [131] "1992-10-01" "1993-01-01" "1993-04-01" "1993-07-01" "1993-10-01"
#> [136] "1994-01-01" "1994-04-01" "1994-07-01" "1994-10-01" "2025-10-01"
#> [141] "1990-01-01" "1990-04-01" "1990-07-01" "1990-10-01" "1980-01-01"
#> [146] "1980-04-01" "1980-07-01" "1980-10-01" "1981-01-01" "1981-04-01"
#> [151] "1981-07-01" "1981-10-01" "1982-01-01" "1982-04-01" "1982-07-01"
#> [156] "1982-10-01" "1983-01-01" "1983-04-01" "1983-07-01" "1983-10-01"
#> [161] "1984-01-01" "1984-04-01" "1984-07-01" "1984-10-01" "1985-01-01"
#> [166] "1985-04-01" "1985-07-01" "1985-10-01" "1986-01-01" "1986-04-01"
#> [171] "1986-07-01" "1986-10-01" "1987-01-01" "1987-04-01" "1987-07-01"
#> [176] "1987-10-01" "1988-01-01" "1988-04-01" "1988-07-01" "1988-10-01"
#> [181] "1989-01-01" "1989-04-01" "1989-07-01" "1989-10-01"
# }

if (FALSE) { # \dontrun{
# Test for weekly data
get_eurostat(
  id = "lfsi_abs_w",
  select_time = c("W"),
  time_format = "date"
  )
} # }
```
