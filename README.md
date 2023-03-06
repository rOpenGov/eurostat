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

eurostat R package <a href='https://ropengov.github.io/eurostat/'><img src='man/figures/logo.png' align="right" height="139" /></a>
===================================================================================================================================

R tools to access open data from
[Eurostat](https://ec.europa.eu/eurostat). Data search, download,
manipulation and visualization.

### Installation and use

Install stable version from CRAN:

    install.packages("eurostat")

Alternatively, install development version from GitHub:

    # Install from GitHub
    library(devtools)
    devtools::install_github("ropengov/eurostat")

Development version can be also installed using the
[r-universe](https://ropengov.r-universe.dev):

    # Enable this universe
    options(repos = c(
      ropengov = "https://ropengov.r-universe.dev",
      CRAN = "https://cloud.r-project.org"
    ))

    install.packages("eurostat")

The package provides several different ways to get datasets from
Eurostat. Searching for data is one way, if you know what to look for.

    # Load the package
    library(eurostat)

    # Perform a simple search and print a table
    passengers <- search_eurostat("passenger transport")
    knitr::kable(head(passengers))

<table>
<colgroup>
<col style="width: 48%" />
<col style="width: 8%" />
<col style="width: 4%" />
<col style="width: 10%" />
<col style="width: 14%" />
<col style="width: 5%" />
<col style="width: 4%" />
<col style="width: 3%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">title</th>
<th style="text-align: left;">code</th>
<th style="text-align: left;">type</th>
<th style="text-align: left;">last update of data</th>
<th style="text-align: left;">last table structure change</th>
<th style="text-align: left;">data start</th>
<th style="text-align: left;">data end</th>
<th style="text-align: left;">values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Air passenger transport</td>
<td style="text-align: left;">enps_avia_pa</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">10.02.2022</td>
<td style="text-align: left;">10.02.2022</td>
<td style="text-align: left;">2005</td>
<td style="text-align: left;">2020</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Modal split of air, sea and inland passenger transport</td>
<td style="text-align: left;">tran_hv_ms_psmod</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">31.01.2023</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2008</td>
<td style="text-align: left;">2020</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Modal split of inland passenger transport</td>
<td style="text-align: left;">tran_hv_psmod</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">13.07.2022</td>
<td style="text-align: left;">13.07.2022</td>
<td style="text-align: left;">1990</td>
<td style="text-align: left;">2020</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Volume of passenger transport relative to GDP</td>
<td style="text-align: left;">tran_hv_pstra</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">13.07.2022</td>
<td style="text-align: left;">13.07.2022</td>
<td style="text-align: left;">1990</td>
<td style="text-align: left;">2020</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Maritime passenger transport performed in the Exclusive Economic Zone (EEZ) of the countries</td>
<td style="text-align: left;">mar_tp_pa</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">21.02.2023</td>
<td style="text-align: left;">21.02.2023</td>
<td style="text-align: left;">2005</td>
<td style="text-align: left;">2021</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Air passenger transport by reporting country</td>
<td style="text-align: left;">avia_paoc</td>
<td style="text-align: left;">dataset</td>
<td style="text-align: left;">13.02.2023</td>
<td style="text-align: left;">13.02.2023</td>
<td style="text-align: left;">1993</td>
<td style="text-align: left;">2022Q4</td>
<td style="text-align: left;">NA</td>
</tr>
</tbody>
</table>

See the
[Tutorial](https://ropengov.github.io/eurostat/articles/articles/eurostat_tutorial.html)
and other resources at the [package
homepage](https://ropengov.github.io/eurostat/) for more information and
examples.

### Recommended packages

It is recommended to install the `giscoR` package
(<a href="https://dieghernan.github.io/giscoR/" class="uri">https://dieghernan.github.io/giscoR/</a>).
This is another API package that provides R tools for Eurostat
geographic data to support geospatial analysis and visualization.

### Contribute

Contributions are very welcome:

-   [Use issue tracker](https://github.com/ropengov/eurostat/issues) for
    feedback and bug reports.
-   [Send pull requests](https://github.com/ropengov/eurostat/)
-   [Star us on the Github page](https://github.com/ropengov/eurostat/)
-   [Join the discussion in
    Gitter](https://app.gitter.im/#/room/#rOpenGov_eurostat:gitter.im)

### Acknowledgements

**Kindly cite this package** as follows: [Leo
Lahti](https://github.com/antagomir), Przemyslaw Biecek, Markus Kainu
and Janne Huovari. Retrieval and analysis of Eurostat open data with the
eurostat package. [R Journal 9(1):385-392,
2017](https://journal.r-project.org/archive/2017/RJ-2017-019/index.html).
R package version 3.8.2. DOI:
[10.32614/RJ-2017-019](https://doi.org/10.32614/RJ-2017-019). URL:
<https://ropengov.github.io/eurostat/>

We are grateful to all
[contributors](https://github.com/ropengov/eurostat/graphs/contributors),
including Daniel Antal, Joona Lehtomäki, Francois Briatte, and Oliver
Reiter, and for the [Eurostat](https://ec.europa.eu/eurostat/) open data
portal! This project is part of [rOpenGov](https://ropengov.org).

### Disclaimer

This package is in no way officially related to or endorsed by Eurostat.

When using data retrieved from Eurostat database in your work, please
indicate that the data source is Eurostat. If your re-use involves some
kind of modification to data or text, please state this clearly to the
end user. See Eurostat policy on [copyright and free re-use of
data](https://ec.europa.eu/eurostat/about/policies/copyright) for more
detailed information and certain exceptions.
