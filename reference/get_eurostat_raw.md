# Download Data from Eurostat Dissemination API

Download data from the eurostat database through the new dissemination
API.

## Usage

``` r
get_eurostat_raw(id, use.data.table = FALSE)
```

## Arguments

- id:

  A unique identifier / code for the dataset of interest. If code is not
  known
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  function can be used to search Eurostat table of contents.

- use.data.table:

  Use faster data.table functions? Default is FALSE. On Windows requires
  that RTools is installed.

## Value

A dataset in tibble format. First column contains comma separated codes
of cases. Other columns usually corresponds to years and column names
are years with preceding X. Data is in character format as it contains
values together with eurostat flags for data.

## Data source: Eurostat SDMX 2.1 Dissemination API

Data is downloaded from Eurostat SDMX 2.1 API endpoint as compressed TSV
files that are transformed into tabular format. See Eurostat
documentation for more information:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+SDMX+2.1+-+data+query>

The new dissemination API replaces the old bulk download facility that
was used by Eurostat before October 2023 and by the eurostat R package
versions before 4.0.0. See Eurostat documentation about the transition
from Bulk Download to API for more information about the differences
between the old bulk download facility and the data provided by the new
API connection:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API>

See especially the document Migrating_to_API_TSV.pdf that describes the
changes in TSV file format in new applications.

For more information about SDMX 2.1, see SDMX standards: Section 7:
Guidelines for the use of web services, Version 2.1:
<https://sdmx.org/wp-content/uploads/SDMX_2-1_SECTION_7_WebServicesGuidelines.pdf>

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

[`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)

## Author

Przemyslaw Biecek, Leo Lahti, Janne Huovari and Pyry Kantanen

## Examples

``` r
# \donttest{
eurostat:::get_eurostat_raw("educ_iste")
#> # A tibble: 213 × 16
#>    freq,indic_ed,geo\\TIME_PE…¹ `1998` `1999` `2000` `2001` `2002` `2003` `2004`
#>    <chr>                        <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr> 
#>  1 A,ST1_1,AL                   NA     NA     18.2   18.7   NA     18.7   NA    
#>  2 A,ST1_1,AT                   10.5 d 11.2   NA     11.1   11.3   11.3   11.9  
#>  3 A,ST1_1,BE                   NA     NA     NA     11.2 d 10.7 d 11.0 d 10.8 d
#>  4 A,ST1_1,BE_FRA               NA     NA     NA     NA     9.9    10.5   10.5  
#>  5 A,ST1_1,BE_VLA               13.1   13.3   13.7   NA     11.3   11.2   11.1  
#>  6 A,ST1_1,BG                   13.0   14.1   13.2   13.6   13.5   13.7   13.5  
#>  7 A,ST1_1,CY                   NA     15.3   14.9   16.6   15.1   15.0   14.0  
#>  8 A,ST1_1,CZ                   16.8   17.4   16.6   15.6   15.1   14.8   14.4  
#>  9 A,ST1_1,DE                   17.2   17.2   16.4   16.3   16.1   16.0   16.1  
#> 10 A,ST1_1,DK                   10.9 d 11.0 d 11.0 d 10.9 d 11.7 d 11.4 d : u   
#> # ℹ 203 more rows
#> # ℹ abbreviated name: ¹​`freq,indic_ed,geo\\TIME_PERIOD`
#> # ℹ 8 more variables: `2005` <chr>, `2006` <chr>, `2007` <chr>, `2008` <chr>,
#> #   `2009` <chr>, `2010` <chr>, `2011` <chr>, `2012` <chr>
# }
```
