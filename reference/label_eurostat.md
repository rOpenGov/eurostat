# Get Eurostat Codes for data downloaded from new dissemination API

Get definitions for Eurostat codes from Eurostat dictionaries.

## Usage

``` r
label_eurostat(
  x,
  dic = NULL,
  code = NULL,
  eu_order = FALSE,
  lang = "en",
  countrycode = NULL,
  countrycode_nomatch = NULL,
  custom_dic = NULL,
  fix_duplicated = FALSE
)

label_eurostat_vars(x = NULL, id, lang = "en")

label_eurostat_tables(x, lang = "en")
```

## Arguments

- x:

  A character or a factor vector or a data_frame.

- dic:

  A string (vector) naming eurostat dictionary or dictionaries. If
  `NULL` (default) dictionary names taken from column names of the
  data_frame.

- code:

  For data_frames names of the column for which also code columns should
  be retained. The suffix "\_code" is added to code column names.

- eu_order:

  Logical. Should Eurostat ordering used for label levels. Affects only
  factors.

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

- countrycode:

  A `NULL` or a name of the coding scheme for the
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html)
  to label "geo" variable with countrycode-package. It can be used to
  convert to short and long country names in many different languages.
  If `NULL` (default) eurostat dictionary is used instead.

- countrycode_nomatch:

  What to do when using the countrycode to label a "geo" and countrycode
  fails to find a match, for example other than country codes like EU28.
  The original code is used with a `NULL` (default), eurostat dictionary
  label is used with "eurostat", and `NA` is used with NA.

- custom_dic:

  a named vector or named list of named vectors to give an own
  dictionary for (part of) codes. Names of the vector should be codes
  and values labels. List can be used to specify dictionaries and then
  list names should be dictionary codes.

- fix_duplicated:

  A logical. If TRUE, the code is added to the duplicated label values.
  If FALSE (default) error is given if labeling produce duplicates.

- id:

  A unique identifier / code for the dataset of interest. If code is not
  known
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  function can be used to search Eurostat table of contents.

## Value

a vector or a data_frame.

## Details

A character or a factor vector of codes returns a corresponding vector
of definitions. `label_eurostat()` labels also data_frames from
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md).
For vectors a dictionary name have to be supplied. For data_frames
dictionary names are taken from column names. "time" and "values"
columns are returned as they were, so you can supply data_frame from
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
and get data_frame with definitions instead of codes.

Some Eurostat dictionaries includes duplicated labels. By default
duplicated labels cause an error, but they can be fixed automatically
with `fix_duplicated = TRUE`.

## Functions

- `label_eurostat_vars()`: Get definitions for variable (column) names.

- `label_eurostat_tables()`: Get definitions for table names

## See also

[`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html)

Other helpers:
[`cut_to_classes()`](https://ropengov.github.io/eurostat/reference/cut_to_classes.md),
[`dic_order()`](https://ropengov.github.io/eurostat/reference/dic_order.md),
[`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md),
[`eurotime2num()`](https://ropengov.github.io/eurostat/reference/eurotime2num.md),
[`harmonize_country_code()`](https://ropengov.github.io/eurostat/reference/harmonize_country_code.md)

## Author

Janne Huovari <janne.huovari@ptt.fi>

## Examples

``` r
if (FALSE) { # \dontrun{
lp <- get_eurostat("nama_10_lp_ulc")
lpl <- label_eurostat(lp)
str(lpl)
lpl_order <- label_eurostat(lp, eu_order = TRUE)
lpl_code <- label_eurostat(lp, code = "unit")
# Note that the dataset id must be provided in label_eurostat_vars
label_eurostat_vars(id = "nama_10_lp_ulc", x = "geo", lang = "en")
label_eurostat_tables("nama_10_lp_ulc")
label_eurostat(c("FI", "DE", "EU28"), dic = "geo")
label_eurostat(
  c("FI", "DE", "EU28"),
  dic = "geo",
  custom_dic = c(DE = "Germany")
)
label_eurostat(
  c("FI", "DE", "EU28"),
  dic = "geo", countrycode = "country.name",
  custom_dic = c(EU28 = "EU")
)
label_eurostat(
  c("FI", "DE", "EU28"),
  dic = "geo",
  countrycode = "country.name"
)
# In Finnish
label_eurostat(
  c("FI", "DE", "EU28"),
  dic = "geo",
  countrycode = "cldr.short.fi"
)
} # }
```
