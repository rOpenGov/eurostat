# Create A Data Bibliography

Creates a bibliography from selected Eurostat data files, including last
Eurostat update, URL access data, and optional keywords set by the user.

## Usage

``` r
get_bibentry(code, keywords = NULL, format = "Biblatex", lang = "en")
```

## Arguments

- code:

  A Eurostat data code or a vector of Eurostat data codes as character
  or factor.

- keywords:

  A list of keywords to be added to the entries. Defaults to `NULL`.

- format:

  Default is `'Biblatex'`, alternatives are `'bibentry'` or `'Bibtex'`
  (not case sensitive)

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

## Value

a bibentry, Bibtex or Biblatex object.

## Citing Eurostat data

For citing datasets, use `get_bibentry()` to build a bibliography that
is suitable for your reference manager of choice.

When using Eurostat data in other contexts than academic publications
that in-text citations or footnotes/endnotes, the following guidelines
may be helpful:

- The origin of the data should always be mentioned as "Source:
  Eurostat".

- The online dataset codes(s) should also be provided in order to ensure
  transparency and facilitate access to the Eurostat data and related
  methodological information. For example: "Source: Eurostat (online
  data code: namq_10_gdp)"

- Online publications (e.g. web pages, PDF) should include a clickable
  link to the dataset using the bookmark functionality available in the
  Eurostat data browser.

It should be avoided to associate different entities (e.g. Eurostat,
National Statistical Offices, other data providers) to the same dataset
or indicator without specifying the role of each of them in the
treatment of data.

See also section "Eurostat: Copyright notice and free re-use of data" in
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
documentation.

## See also

[utils::bibentry](https://rdrr.io/r/utils/bibentry.html)
[RefManageR::toBiblatex](https://docs.ropensci.org/RefManageR/reference/toBiblatex.html)

## Author

Daniel Antal, Przemyslaw Biecek

## Examples

``` r
if (FALSE) { # \dontrun{
  my_bibliography <- get_bibentry(
    code = c("tran_hv_frtra", "tec00001"),
    keywords = list(
      c("transport", "freight", "multimodal data", "GDP"),
      c("economy and finance", "annual", "national accounts", "GDP")
    ),
    format = "Biblatex"
  )
  my_bibliography
} # }
```
