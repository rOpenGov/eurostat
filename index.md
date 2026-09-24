# eurostat R package

[![Watch on
GitHub](https://img.shields.io/github/watchers/ropengov/eurostat.svg?style=social)](https://github.com/rOpenGov/eurostat)
[![Star on
GitHub](https://img.shields.io/github/stars/ropengov/eurostat.svg?style=social)](https://github.com/rOpenGov/eurostat)
[![Follow](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/ropengov)

R tools to access open data from
[Eurostat](https://ec.europa.eu/eurostat). Data search, download,
manipulation and visualization.

### Installation and use

Install stable version from CRAN:

``` R
install.packages("eurostat")
```

Alternatively, install development version from GitHub:

``` R
# Install from GitHub
library(devtools)
devtools::install_github("ropengov/eurostat")
```

Development version can be also installed using the
[r-universe](https://ropengov.r-universe.dev):

``` R
# Enable this universe
options(repos = c(
  ropengov = "https://ropengov.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))

install.packages("eurostat")
```

The package provides several different ways to get datasets from
Eurostat. Searching for data is one way, if you know what to look for.

``` R
# Load the package
library(eurostat)

# Perform a simple search and print a table
passengers <- search_eurostat("passenger transport")
knitr::kable(head(passengers))
```

| title | code | type | last.update.of.data | last.table.structure.change | data.start | data.end | values | hierarchy |
|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| Air passenger transport - ENP-South countries | enps_avia_pa | dataset | 05.03.2026 | 05.03.2026 | 2005 | 2025 | 425 | 6 |
| Air passenger transport by type of schedule, transport coverage and country | avia_paoc | dataset | 15.09.2026 | 10.09.2026 | 1993 | 2026-Q2 | 2665597 | 5 |
| Air passenger transport by type of schedule, transport coverage and main airports | avia_paoa | dataset | 15.09.2026 | 14.09.2026 | 1993 | 2026-Q2 | 22389430 | 5 |
| Air passenger transport between reporting and partner countries by type of schedule | avia_paocc | dataset | 15.09.2026 | 10.09.2026 | 1993 | 2026-Q2 | 11691835 | 5 |
| Air passenger transport between main airports and partner reporting countries | avia_paoac | dataset | 15.09.2026 | 14.09.2026 | 1993 | 2026-Q2 | 22020044 | 5 |
| Air passenger transport by aircraft model, distance bands and transport coverage | avia_paodis | dataset | 03.12.2025 | 29.10.2025 | 2008 | 2024 | 907536 | 5 |

See the
[Tutorial](https://ropengov.github.io/eurostat/articles/articles/eurostat_tutorial.html)
and other resources at the [package
homepage](https://ropengov.github.io/eurostat/) for more information and
examples.

### Recommended packages

It is recommended to install the `giscoR` package
(<https://dieghernan.github.io/giscoR/>). This is another API package
that provides R tools for Eurostat geographic data to support geospatial
analysis and visualization.

### Contribute

Contributions are very welcome:

- [Use issue tracker](https://github.com/ropengov/eurostat/issues) for
  feedback and bug reports.
- [Send pull requests](https://github.com/ropengov/eurostat/)
- [Discuss with developers and other users in GitHub
  Discussions](https://github.com/rOpenGov/eurostat/discussions)
- [Star us on the Github page](https://github.com/ropengov/eurostat/)

### Acknowledgements

**Kindly cite this work** as follows:

``` R
print(citation("eurostat"), bibtex = TRUE)
Kindly cite this package by citing the following R Journal article:

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

In addition, please provide a citation to the specific software version
used:

  Lahti L, Huovari J, Kainu M, Biecek P, Hernangomez D, Antal D,
  Kantanen P (2026). "eurostat: Tools for Eurostat Open Data."
  doi:10.32614/CRAN.package.eurostat
  <https://doi.org/10.32614/CRAN.package.eurostat>. R package version
  4.1.0, <https://github.com/rOpenGov/eurostat>.

A BibTeX entry for LaTeX users is

  @Misc{R-eurostat,
    title = {eurostat: Tools for Eurostat Open Data},
    doi = {10.32614/CRAN.package.eurostat},
    author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek and Diego Hernangomez and Daniel Antal and Pyry Kantanen},
    url = {https://github.com/rOpenGov/eurostat},
    type = {Computer software},
    year = {2026},
    note = {R package version 4.1.0},
  }
```

We are grateful to all
[contributors](https://github.com/ropengov/eurostat/graphs/contributors),
including Daniel Antal, Joona Lehtomäki, Francois Briatte, and Oliver
Reiter, and for the [Eurostat](https://ec.europa.eu/eurostat/) open data
portal! This project is part of [rOpenGov](https://ropengov.org).

This project has received funding from the European Union under grant No
101095295 (OpenMUSE), the FIN-CLARIAH research infrastructure and the
Strategic Research Council’s YOUNG program by the Research Council of
Finland (decisions 345630, 358720, 367756, 352604).

### Disclaimer

This package is in no way officially related to or endorsed by Eurostat.

When using data retrieved from Eurostat database in your work, please
indicate that the data source is Eurostat. If your re-use involves some
kind of modification to data or text, please state this clearly to the
end user. See Eurostat policy on [copyright and free re-use of
data](https://ec.europa.eu/eurostat/help/copyright-notice) for more
detailed information and certain exceptions.
