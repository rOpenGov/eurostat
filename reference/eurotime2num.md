# Conversion of Eurostat Time Format to Numeric

A conversion of a Eurostat time format to numeric.

## Usage

``` r
eurotime2num(x)
```

## Arguments

- x:

  a charter string with time information in Eurostat time format.

## Value

see [`as.numeric()`](https://rdrr.io/r/base/numeric.html).

## Details

Bi-annual (semester), quarterly, monthly and weekly data can be
presented as a fraction of the year in beginning of the period.
Conversion of daily data is not supported.

## See also

Other helpers:
[`cut_to_classes()`](https://ropengov.github.io/eurostat/reference/cut_to_classes.md),
[`dic_order()`](https://ropengov.github.io/eurostat/reference/dic_order.md),
[`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md),
[`harmonize_country_code()`](https://ropengov.github.io/eurostat/reference/harmonize_country_code.md),
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)

## Author

Janne Huovari <janne.huovari@ptt.fi>, Pyry Kantanen

## Examples

``` r
# \donttest{
na_q <- get_eurostat("namq_10_pc", time_format = "raw")
#> Dataset query already saved in cache_list.json...
#> Reading cache file /tmp/Rtmp6a05NR/eurostat/e1b4f7bfc8517d9788bafad0e3d30853.rds
#> Table  namq_10_pc  read from cache file:  /tmp/Rtmp6a05NR/eurostat/e1b4f7bfc8517d9788bafad0e3d30853.rds
na_q$TIME_PERIOD <- eurotime2num(x = na_q$TIME_PERIOD)

unique(na_q$TIME_PERIOD)
#>   [1] 1995.00 1995.25 1995.50 1995.75 1996.00 1996.25 1996.50 1996.75 1997.00
#>  [10] 1997.25 1997.50 1997.75 1998.00 1998.25 1998.50 1998.75 1999.00 1999.25
#>  [19] 1999.50 1999.75 2000.00 2000.25 2000.50 2000.75 2001.00 2001.25 2001.50
#>  [28] 2001.75 2002.00 2002.25 2002.50 2002.75 2003.00 2003.25 2003.50 2003.75
#>  [37] 2004.00 2004.25 2004.50 2004.75 2005.00 2005.25 2005.50 2005.75 2006.00
#>  [46] 2006.25 2006.50 2006.75 2007.00 2007.25 2007.50 2007.75 2008.00 2008.25
#>  [55] 2008.50 2008.75 2009.00 2009.25 2009.50 2009.75 2010.00 2010.25 2010.50
#>  [64] 2010.75 2011.00 2011.25 2011.50 2011.75 2012.00 2012.25 2012.50 2012.75
#>  [73] 2013.00 2013.25 2013.50 2013.75 2014.00 2014.25 2014.50 2014.75 2015.00
#>  [82] 2015.25 2015.50 2015.75 2016.00 2016.25 2016.50 2016.75 2017.00 2017.25
#>  [91] 2017.50 2017.75 2018.00 2018.25 2018.50 2018.75 2019.00 2019.25 2019.50
#> [100] 2019.75 2020.00 2020.25 2020.50 2020.75 2021.00 2021.25 2021.50 2021.75
#> [109] 2022.00 2022.25 2022.50 2022.75 2023.00 2023.25 2023.50 2023.75 2024.00
#> [118] 2024.25 2024.50 2024.75 2025.00 2025.25 2025.50 1991.00 1991.25 1991.50
#> [127] 1991.75 1992.00 1992.25 1992.50 1992.75 1993.00 1993.25 1993.50 1993.75
#> [136] 1994.00 1994.25 1994.50 1994.75 2025.75 1990.00 1990.25 1990.50 1990.75
#> [145] 1980.00 1980.25 1980.50 1980.75 1981.00 1981.25 1981.50 1981.75 1982.00
#> [154] 1982.25 1982.50 1982.75 1983.00 1983.25 1983.50 1983.75 1984.00 1984.25
#> [163] 1984.50 1984.75 1985.00 1985.25 1985.50 1985.75 1986.00 1986.25 1986.50
#> [172] 1986.75 1987.00 1987.25 1987.50 1987.75 1988.00 1988.25 1988.50 1988.75
#> [181] 1989.00 1989.25 1989.50 1989.75
# }
```
