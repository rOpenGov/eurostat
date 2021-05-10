
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R build
status](https://github.com/rOpenGov/eurostat/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenGov/eurostat/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable-1)
[![codecov.io](https://codecov.io/github/rOpenGov/eurostat/coverage.svg?branch=master)](https://codecov.io/github/rOpenGov/eurostat?branch=master)
[![Downloads](http://cranlogs.r-pkg.org/badges/grand-total/eurostat)](https://cran.r-project.org/package=eurostat)
[![Downloads](http://cranlogs.r-pkg.org/badges/eurostat)](https://cran.r-project.org/package=eurostat)
[![Gitter](https://badges.gitter.im/rOpenGov/eurostat.svg)](https://gitter.im/rOpenGov/eurostat?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Watch on
GitHub](https://img.shields.io/github/watchers/ropengov/eurostat.svg?style=social)](https://github.com/ropengov/eurostat/watchers)
[![Star on
GitHub](https://img.shields.io/github/stars/ropengov/eurostat.svg?style=social)](https://github.com/ropengov/eurostat/stargazers)
[![Follow](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/intent/follow?screen_name=ropengov)

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

# eurostat R package

R tools to access open data from
[Eurostat](https://ec.europa.eu/eurostat). Data search, download,
manipulation and visualization.

### Installation and use

``` r
# Install from CRAN
install.packages("eurostat")

# Install from GitHub
library(devtools)
devtools::install_github("ropengov/eurostat")
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

| title                                                              | code            | type    | last update of data | last table structure change | data start | data end | values |
|:-------------------------------------------------------------------|:----------------|:--------|:--------------------|:----------------------------|:-----------|:---------|:-------|
| Air passenger transport                                            | enps\_avia\_pa  | dataset | 16.04.2021          | NA                          | 2005       | 2020     | NA     |
| Volume of passenger transport relative to GDP                      | tran\_hv\_pstra | dataset | 01.09.2020          | 08.02.2021                  | 1990       | 2018     | NA     |
| Modal split of passenger transport                                 | tran\_hv\_psmod | dataset | 01.09.2020          | 08.02.2021                  | 1990       | 2018     | NA     |
| Air passenger transport by reporting country                       | avia\_paoc      | dataset | 07.05.2021          | 07.05.2021                  | 1993       | 2021Q1   | NA     |
| Air passenger transport by main airports in each reporting country | avia\_paoa      | dataset | 07.05.2021          | 07.05.2021                  | 1993       | 2021Q1   | NA     |
| Air passenger transport between reporting countries                | avia\_paocc     | dataset | 07.05.2021          | 07.05.2021                  | 1993       | 2021Q1   | NA     |

See the
[Tutorial](https://ropengov.github.io/eurostat/articles/website/eurostat_tutorial.html)
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

-   [Use issue tracker](https://github.com/ropengov/eurostat/issues) for
    feedback and bug reports.
-   [Send pull requests](https://github.com/ropengov/eurostat/)
-   [Star us on the Github page](https://github.com/ropengov/eurostat/)
-   [Join the discussion in Gitter](https://gitter.im/rOpenGov/eurostat)

### Acknowledgements

**Kindly cite this work** as follows: [Leo
Lahti](https://github.com/antagomir), Przemyslaw Biecek, Markus Kainu
and Janne Huovari. Retrieval and analysis of Eurostat open data with the
eurostat package. [R Journal 9(1):385-392,
2017](https://journal.r-project.org/archive/2017/RJ-2017-019/index.html).
R package version 3.7.2. URL: <https://ropengov.github.io/eurostat/>

We are grateful to all
[contributors](https://github.com/ropengov/eurostat/graphs/contributors),
including Daniel Antal, Joona Lehtomäki, Francois Briatte, and Oliver
Reiter, and for the [Eurostat](https://ec.europa.eu/eurostat/) open data
portal! This project is part of [rOpenGov](http://ropengov.org).

### Disclaimer

This package is in no way officially related to or endorsed by Eurostat.

<!--[build-badge]: https://img.shields.io/travis/ropengov/eurostat.svg?style=flat-square-->
<!--[build]: https://travis-ci.org/ropengov/eurostat-->
