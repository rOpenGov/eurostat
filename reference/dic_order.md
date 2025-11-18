# Order of Variable Levels from Eurostat Dictionary.

Orders the factor levels.

## Usage

``` r
dic_order(x, dic, type)
```

## Arguments

- x:

  a variable (code or labelled) to get order for.

- dic:

  a name of the dictionary. Correspond a variable name in the data_frame
  from
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).
  Can be also data_frame from
  [`get_eurostat_dic()`](https://ropengov.github.io/eurostat/reference/get_eurostat_dic.md).

- type:

  a type of the x. Could be `code` or `label`.

## Value

A numeric vector of orders.

## Details

Some variables, like classifications, have logical or conventional
ordering. Eurostat data tables are nor necessary ordered in this order.
The function `dic_order()` get the ordering from Eurostat
classifications dictionaries. The function
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
can also order factor levels of labels with argument `eu_order = TRUE`.

## See also

Other helpers:
[`cut_to_classes()`](https://ropengov.github.io/eurostat/reference/cut_to_classes.md),
[`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md),
[`eurotime2num()`](https://ropengov.github.io/eurostat/reference/eurotime2num.md),
[`harmonize_country_code()`](https://ropengov.github.io/eurostat/reference/harmonize_country_code.md),
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)

## Author

Przemyslaw Biecek, Leo Lahti, Janne Huovari and Markus Kainu
