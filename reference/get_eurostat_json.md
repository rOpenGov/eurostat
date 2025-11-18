# Get Data from Eurostat API in JSON

Retrieve data from Eurostat API in JSON format.

## Usage

``` r
get_eurostat_json(
  id,
  filters = NULL,
  type = "code",
  lang = "en",
  stringsAsFactors = FALSE,
  proxy = FALSE,
  ...
)
```

## Arguments

- id:

  A unique identifier / code for the dataset of interest. If code is not
  known
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  function can be used to search Eurostat table of contents.

- filters:

  A named list of filters. Names of list objects are Eurostat variable
  codes and values are vectors of observation codes. If `NULL` (default)
  the whole dataset is returned. See details for more information on
  filters and limitations per query.

- type:

  A type of variables, "`code`" (default), "`label`" or "`both`". The
  parameter "`both`" will return a data_frame with named vectors, labels
  as values and codes as names.

- lang:

  2-letter language code, default is "`en`" (English), other options are
  "`fr`" (French) and "`de`" (German). Used for labeling datasets.

- stringsAsFactors:

  if `TRUE` (the default) variables are converted to factors in the
  original Eurostat order. If `FALSE` they are returned as strings.

- proxy:

  Use proxy, TRUE or FALSE (default).

- ...:

  Arguments passed on to
  [`httr2::req_proxy`](https://httr2.r-lib.org/reference/req_proxy.html)

  `req`

  :   A [request](https://httr2.r-lib.org/reference/request.html).

  `url,port`

  :   Location of proxy.

  `username,password`

  :   Login details for proxy, if needed.

  `auth`

  :   Type of HTTP authentication to use. Should be one of the
      following: `basic`, digest, digest_ie, gssnegotiate, ntlm, any.

## Value

A dataset as an object of `data.frame` class.

## Details

Data to retrieve from [The Eurostat Web
Services](https://ec.europa.eu/eurostat/web/main/data/web-services) can
be specified with filters. Normally, it is better to use JSON query
through
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md),
than to use `get_eurostat_json()` directly.

Queries are limited to 50 sub-indicators at a time. A time can be
filtered with fixed "time" filter or with "sinceTimePeriod" and
"lastTimePeriod" filters. A `sinceTimePeriod = 2000` returns
observations from 2000 to a last available. A `lastTimePeriod = 10`
returns a 10 last observations. See "Filtering datasets" section below
for more detailed information about filters.

To use a proxy to connect, proxy arguments can be passed to
[`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html)
via
[`httr2::req_proxy()`](https://httr2.r-lib.org/reference/req_proxy.html) -
see latter function documentation for parameter names that can be passed
with `...`. A non-functional example:
`get_eurostat_json(id, filters, proxy = TRUE, url = "127.0.0.1", port = 80)`.

When retrieving data from Eurostat JSON API the user may encounter
errors. For end user convenience, we have provided a ready-made internal
dataset `sdmx_http_errors` that contains descriptive labels and
descriptions about the possible interpretation or cause of each error.
These messages are returned if the API returns a status indicating a
HTTP error (400 or greater).

The Eurostat implementation seems to be based on SDMX 2.1, which is the
reason we've used SDMX Standards guidelines as a supplementary source
that we have included in the dataset. What this means in practice is
that the dataset contains error codes and their mappings that are not
mentioned in the Eurostat website. We hope you never encounter them.

## Data source: Eurostat API Statistics (JSON API)

Data is downloaded from Eurostat API Statistics. See Eurostat
documentation for more information about data queries in API Statistics
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query>

This replaces the old JSON Web Services that was used by Eurostat before
February 2023 and by the eurostat R package versions before 3.7.13. See
Eurostat documentation about the migration from JSON web service to API
Statistics for more information about the differences between the old
and the new service:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+migrating+from+JSON+web+service+to+API+Statistics>

For easily viewing which filtering options are available - in addition
to the default ones, time and language - Eurostat Web services Query
builder tool may be useful:
<https://ec.europa.eu/eurostat/web/query-builder>

## Filtering datasets

When using Eurostat API Statistics (JSON API), datasets can be filtered
before they are downloaded and saved in local memory. The general format
for filter parameters is `<DIMENSION_CODE>=<VALUE>`.

Filter parameters are optional but the used dimension codes must be
present in the data product that is being queried. Dimension codes can
vary between different data products so it may be useful to examine new
datasets in Eurostat data browser beforehand. However, most if not all
Eurostat datasets concern European countries and contain information
that was gathered at some point in time, so `geo` and `time` dimension
codes can usually be used.

`<DIMENSION_CODE>` and `<VALUE>` are case-insensitive and they can be
written in lowercase or uppercase in the query.

Parameters are passed onto the `eurostat` package functions
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
and `get_eurostat_json()` as a list item. If an individual item contains
multiple items, as it often can be in the case of `geo` parameters and
other optional items, they must be in the form of a vector:
`c("FI", "SE")`. For examples on how to use these parameters, see
function examples below.

### Time parameters

`time` and `time_period` address the same `TIME_PERIOD` dimension in the
dataset and can be used interchangeably. In the Eurostat documentation
it is stated that "Using more than one Time parameter in the same query
is not accepted", but practice has shown that actually Eurostat API
allows multiple `time` parameters in the same query. This makes it
possible to use R colon operator when writing queries, so
`time = c(2015:2018)` translates to
`&time=2015&time=2016&time=2017&time=2018`.

The only exception to this is when the queried dataset contains e.g.
quarterly data and `TIME_PERIOD` is saved as `2015-Q1`, `2015-Q2` etc.
Then it is possible to use `time=2015-Q1&time=2015-Q2` style in the
query URL, but this makes it unfeasible to use the colon operator and
requires a lot of manual typing.

Because of this, it is useful to know about other time parameters as
well:

- `untilTimePeriod`: return dataset items from the oldest record up
  until the set time, for example "all data until 2000":
  `untilTimePeriod = 2000`

- `sinceTimePeriod`: return dataset items starting from set time, for
  example "all datastarting from 2008": `sinceTimePeriod = 2008`

- `lastTimePeriod`: starting from the most recent time period, how many
  preceding time periods should be returned? For example 10 most recent
  observations: `lastTimePeriod = 10`

Using both `untilTimePeriod` and `sinceTimePeriod` parameters in the
same query is allowed, making the usage of the R colon operator
unnecessary. In the case of quarterly data, using `untilTimePeriod` and
`sinceTimePeriod` parameters also works, as opposed to the colon
operator, so it is generally safer to use them as well.

### Other dimensions

In `get_eurostat_json()` examples `nama_10_gdp` dataset is filtered with
two additional filter parameters:

- `na_item = "B1GQ"`

- `unit = "CLV_I10"`

Filters like these are most likely unique to the `nama_10_gdp` dataset
(or other datasets within the same domain) and should not be used with
others dataset without user discretion. By using
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
we know that `"B1GQ"` stands for "Gross domestic product at market
prices" and `"CLV_I10"` means "Chain linked volumes, index 2010=100".

Different dimension codes can be translated to a natural language by
using the
[`get_eurostat_dic()`](https://ropengov.github.io/eurostat/reference/get_eurostat_dic.md)
function, which returns labels for individual dimension items such as
`na_item` and `unit`, as opposed to
[`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
which does it for whole datasets. For example, the parameter `na_item`
stands for "National accounts indicator (ESA 2010)" and `unit` stands
for "Unit of measure".

### Language

All datasets have metadata available in English, French and German. If
no parameter is given, the labels are returned in English.

Example:

- `lang = "fr"`

### More information

For more information about data filtering see Eurostat documentation on
API Statistics:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query#APIStatisticsdataquery-TheparametersdefinedintheRESTrequest>

## Eurostat: Copyright notice and free re-use of data

The following copyright notice is provided for end user convenience.
Please check up-to-date copyright information from the eurostat website:
<https://ec.europa.eu/eurostat/about-us/policies/copyright>

"(c) European Union, 1995 - today

Eurostat has a policy of encouraging free re-use of its data, both for
non-commercial and commercial purposes. All statistical data, metadata,
content of web pages or other dissemination tools, official publications
and other documents published on its website, with the exceptions listed
below, can be reused without any payment or written licence provided
that:

- the source is indicated as Eurostat;

- when re-use involves modifications to the data or text, this must be
  stated clearly to the end user of the information."

For exceptions to the abovementioned principles see [Eurostat
website](https://ec.europa.eu/eurostat/about-us/policies/copyright)

## Citing Eurostat data

For citing datasets, use
[`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
to build a bibliography that is suitable for your reference manager of
choice.

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

## Disclaimer: Availability of filtering functionalities

Currently it only possible to download filtered data through API
Statistics (JSON API) when using `eurostat` package, although
technically filtering datasets downloaded through the SDMX Dissemination
API is also supported by Eurostat. We may support this feature in the
future. In the meantime, if you are interested in filtering
Dissemination API data queries manually, please consult the following
Eurostat documentation:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+SDMX+2.1+-+data+filtering>

## References

See `citation("eurostat")`:

    Kindly cite the eurostat R package as follows:

      Lahti L., Huovari J., Kainu M., and Biecek P. (2017). Retrieval and
      analysis of Eurostat open data with the eurostat package. The R
      Journal 9(1), pp. 385-392. doi: 10.32614/RJ-2017-019

    A BibTeX entry for LaTeX users is

      @Article{10.32614/RJ-2017-019,
        title = {Retrieval and Analysis of Eurostat Open Data with the eurostat Package},
        author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
        journal = {The R Journal},
        volume = {9},
        number = {1},
        pages = {385--392},
        year = {2017},
        doi = {10.32614/RJ-2017-019},
        url = {https://doi.org/10.32614/RJ-2017-019},
      }

      Lahti, L., Huovari J., Kainu M., Biecek P., Hernangomez D., Antal D.,
      and Kantanen P. (2023). eurostat: Tools for Eurostat Open Data
      [Computer software]. R package version 4.0.0.
      https://github.com/rOpenGov/eurostat

    A BibTeX entry for LaTeX users is

      @Misc{eurostat,
        title = {eurostat: Tools for Eurostat Open Data},
        author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek and Diego Hernangomez and Daniel Antal and Pyry Kantanen},
        url = {https://github.com/rOpenGov/eurostat},
        type = {Computer software},
        year = {2023},
        note = {R package version 4.0.0},
      }

When citing data downloaded from Eurostat, see section "Citing Eurostat
data" in
[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
documentation.

## See also

[`httr2::req_proxy()`](https://httr2.r-lib.org/reference/req_proxy.html)

## Author

Przemyslaw Biecek, Leo Lahti, Janne Huovari Markus Kainu and Pyry
Kantanen

## Examples

``` r
if (FALSE) { # \dontrun{
# Generally speaking these queries would be done through get_eurostat
tmp <- get_eurostat_json("nama_10_gdp")
yy <- get_eurostat_json("nama_10_gdp", filters = list(
  geo = c("FI", "SE", "EU28"),
  time = c(2015:2023),
  lang = "FR",
  na_item = "B1GQ",
  unit = "CLV_I10"
))

# TIME_PERIOD filter works also with the new JSON API
yy2 <- get_eurostat_json("nama_10_gdp", filters = list(
   geo = c("FI", "SE", "EU28"),
   TIME_PERIOD = c(2015:2023),
   lang = "FR",
   na_item = "B1GQ",
   unit = "CLV_I10"
))

# An example from get_eurostat
dd <- get_eurostat("nama_10_gdp",
  filters = list(
  geo = "FI",
  na_item = "B1GQ",
  unit = "CLV_I10"
))
} # }
```
