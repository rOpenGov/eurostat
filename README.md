
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![rOG-badge](https://ropengov.github.io/rogtemplate/reference/figures/ropengov-badge.svg)](https://ropengov.org/)
[![R-CMD-check](https://github.com/rOpenGov/eurostat/actions/workflows/check-full.yaml/badge.svg)](https://github.com/rOpenGov/eurostat/actions/workflows/check-full.yaml)
[![R-CMD-check
(standard)](https://github.com/rOpenGov/eurostat/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/rOpenGov/eurostat/actions/workflows/check-standard.yaml)
[![cran
version](http://www.r-pkg.org/badges/version/eurostat)](https://CRAN.R-project.org/package=eurostat)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable-1)
[![DOI](https://img.shields.io/badge/DOI-10.32614/RJ--2017--019-blue)](https://doi.org/10.32614/RJ-2017-019)
[![codecov](https://codecov.io/gh/rOpenGov/eurostat/branch/master/graph/badge.svg?token=Wp2VVvpWQA)](https://app.codecov.io/gh/rOpenGov/eurostat)
[![Downloads](http://cranlogs.r-pkg.org/badges/grand-total/eurostat)](https://cran.r-project.org/package=eurostat)
[![Downloads](http://cranlogs.r-pkg.org/badges/eurostat)](https://cran.r-project.org/package=eurostat)
[![Gitter](https://badges.gitter.im/rOpenGov/eurostat.svg)](https://app.gitter.im/#/room/#rOpenGov_eurostat:gitter.im?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![r-universe](https://ropengov.r-universe.dev/badges/eurostat)](https://ropengov.r-universe.dev/)

[![Watch on
GitHub](https://img.shields.io/github/watchers/ropengov/eurostat.svg?style=social)](https://github.com/ropengov/eurostat/watchers)
[![Star on
GitHub](https://img.shields.io/github/stars/ropengov/eurostat.svg?style=social)](https://github.com/ropengov/eurostat/stargazers)
[![Follow](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/ropengov)

<!--[![Build Status](https://travis-ci.org/rOpenGov/eurostat.svg?branch=master)](https://travis-ci.org/rOpenGov/eurostat)-->

<!--[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/github/rOpenGov/eurostat?branch=master&svg=true)](https://ci.appveyor.com/project/rOpenGov/eurostat)-->

<!--[![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()-->

<!--[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.399279.svg)](https://doi.org/10.5281/zenodo.399279)-->

<!--[![PRs Welcome][prs-badge]][prs]-->

<!--[![Code of Conduct][coc-badge]][coc]-->

<!--[![Contributors](https://img.shields.io/github/contributors/cdnjs/cdnjs.svg?style=flat-square)](#contributors)-->

<!--[![License](https://img.shields.io/pypi/l/Django.svg)](https://opensource.org/licenses/BSD-2-Clause)-->

<!--[![Stories in Ready](http://badge.waffle.io/ropengov/eurostat.png?label=TODO)](http://waffle.io/ropengov/eurostat)-->

<!--[![CRAN version](http://www.r-pkg.org/badges/version/eurostat)](https://cran.r-project.org/package=eurostat)-->

<!-- badges: end -->

# eurostat R package <a href='https://ropengov.github.io/eurostat/'><img src='man/figures/logo.png' align="right" height="139" /></a>

R tools to access open data from
[Eurostat](https://ec.europa.eu/eurostat). Data search, download,
manipulation and visualization.

### Installation and use

Install stable version from CRAN:

``` r
install.packages("eurostat")
```

Alternatively, install development version from GitHub:

``` r
# Install from GitHub
library(devtools)
devtools::install_github("ropengov/eurostat")
```

Development version can be also installed using the
[r-universe](https://ropengov.r-universe.dev):

``` r
# Enable this universe
options(repos = c(
  ropengov = "https://ropengov.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))

install.packages("eurostat")
```

The package provides several different ways to get datasets from
Eurostat. Searching for data is one way, if you know what to look for.

``` r
# Load the package
library(eurostat)

# Perform a simple search and print a table
passengers <- search_eurostat("passenger transport")
knitr::kable(head(passengers))
```

| title | code | type | last.update.of.data | last.table.structure.change | data.start | data.end | values | hierarchy |
|:---|:---|:---|:---|:---|:---|:---|---:|---:|
| Air passenger transport - ENP-South countries | enps_avia_pa | dataset | 12.05.2025 | 12.05.2025 | 2005 | 2023 | 480 | 6 |
| Air passenger transport by type of schedule, transport coverage and country | avia_paoc | dataset | 15.09.2025 | 15.09.2025 | 1993 | 2025-Q2 | 2524910 | 5 |
| Air passenger transport by type of schedule, transport coverage and main airports | avia_paoa | dataset | 15.09.2025 | 15.09.2025 | 1993 | 2025-Q2 | 20609595 | 5 |
| Air passenger transport between reporting and partner countries by type of schedule | avia_paocc | dataset | 15.09.2025 | 15.09.2025 | 1993 | 2025-Q2 | 10518367 | 5 |
| Air passenger transport between main airports and partner reporting countries | avia_paoac | dataset | 15.09.2025 | 15.09.2025 | 1993 | 2025-Q2 | 20189218 | 5 |
| Air passenger transport by aircraft model, distance bands and transport coverage | avia_paodis | dataset | 16.06.2025 | 06.12.2024 | 2008 | 2023 | 852432 | 5 |

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
- [Star us on the Github page](https://github.com/ropengov/eurostat/)
- [Join the discussion in
  Gitter](https://app.gitter.im/#/room/#rOpenGov_eurostat:gitter.im)

### Acknowledgements

**Kindly cite this work** as follows:

``` text
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
  Kantanen P (2025). "eurostat: Tools for Eurostat Open Data."
  doi:10.32614/CRAN.package.eurostat
  <https://doi.org/10.32614/CRAN.package.eurostat>, R package version
  4.1.0.9003, <https://github.com/rOpenGov/eurostat>.

A BibTeX entry for LaTeX users is

  @Misc{R-eurostat,
    title = {eurostat: Tools for Eurostat Open Data},
    doi = {10.32614/CRAN.package.eurostat},
    author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek and Diego Hernangomez and Daniel Antal and Pyry Kantanen},
    url = {https://github.com/rOpenGov/eurostat},
    type = {Computer software},
    year = {2025},
    note = {R package version 4.1.0.9003},
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
data](https://ec.europa.eu/eurostat/about/policies/copyright) for more
detailed information and certain exceptions.
