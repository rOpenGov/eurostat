---
output: 
  html_document: 
    keep_md: yes
---




<br>

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()
[![DOI](https://zenodo.org/badge/18989920.svg)](https://zenodo.org/badge/latestdoi/18989920)

[![Build Status](https://travis-ci.org/rOpenGov/eurostat.svg?branch=master)](https://travis-ci.org/rOpenGov/eurostat)
[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/github/rOpenGov/eurostat?branch=master&svg=true)](https://ci.appveyor.com/project/rOpenGov/eurostat)
[![codecov.io](https://codecov.io/github/rOpenGov/eurostat/coverage.svg?branch=master)](https://codecov.io/github/rOpenGov/eurostat?branch=master)
[![Downloads](http://cranlogs.r-pkg.org/badges/grand-total/eurostat)](https://cran.r-project.org/package=eurostat)
[![Downloads](http://cranlogs.r-pkg.org/badges/eurostat)](https://cran.r-project.org/package=eurostat)

[![Gitter](https://badges.gitter.im/rOpenGov/eurostat.svg)](https://gitter.im/rOpenGov/eurostat?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![PRs Welcome][prs-badge]][prs]
[![Code of Conduct][coc-badge]][coc]
[![Watch on GitHub][github-watch-badge]][github-watch]
[![Star on GitHub][github-star-badge]][github-star]
[![Follow](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/intent/follow?screen_name=ropengov)  

<!--[![Contributors](https://img.shields.io/github/contributors/cdnjs/cdnjs.svg?style=flat-square)](#contributors)-->

<!--[![License](https://img.shields.io/pypi/l/Django.svg)](https://opensource.org/licenses/BSD-2-Clause)-->

<!--[![Stories in Ready](http://badge.waffle.io/ropengov/eurostat.png?label=TODO)](http://waffle.io/ropengov/eurostat)-->
<!--[![CRAN version](http://www.r-pkg.org/badges/version/eurostat)](https://cran.r-project.org/package=eurostat)-->

<br>

# eurostat R package

<!-- README.md is generated from README.Rmd. Please edit that file -->

R tools to access open data from [Eurostat](http://ec.europa.eu/eurostat). Data search, download, manipulation and visualization. See the [package homepage](http://ropengov.github.io/eurostat) for further info.


### Installation

To install the CRAN release version, use:


```r
install.packages("eurostat")
```


For the latest github development version, use:


```r
install_github("ropengov/eurostat")
```


### Using the package

The [R Journal
manuscript](https://journal.r-project.org/archive/2017/RJ-2017-019/index.html)
provides a generic overview of the package functionality. Various
tutorials [are available](http://ropengov.github.io/eurostat/articles/index.html) and provide more detailed demonstrations of package functionality. In
particular, check the following online resources:
 
  * [Cheat sheet: eurostat R package](http://ropengov.github.io/eurostat/articles/cheatsheet.html)
  * [Tutorial (vignette) for the eurostat R package](http://ropengov.github.io/eurostat/articles/eurostat_tutorial.html)
  * [Blog posts](http://ropengov.github.io/eurostat/articles/blogposts.html)
  * [Detailed function documentation](http://ropengov.github.io/eurostat/reference/index.html)
  <!--* [Publications using the eurostat R package](http://ropengov.github.io/eurostat/articles/publications.html)-->

<!--
 * [Eurostat R Cheat Sheet](https://github.com/rOpenGov/eurostat/blob/master/vignettes/cheatsheet/eurostat_cheatsheet.pdf)
 * [Package vignette](https://github.com/rOpenGov/eurostat/blob/master/vignettes/eurostat_tutorial.md) for installation and standard use
 * Blog posts ([package release](https://rpubs.com/muuankarski/27120) / [case studies](http://ropengov.github.io/r/2015/05/01/eurostat-package-examples/))  
 * Journal manuscript ([preprint](https://journal.r-project.org/archive/2017/RJ-2017-019/index.html) / [markdown](https://github.com/rOpenGov/eurostat/blob/master/vignettes/2017_RJournal_manuscript/lahti-huovari-kainu-biecek.md)) with reproducible examples
-->

### Contribute

Contributions are very welcome:

  * [Use issue tracker](https://github.com/ropengov/eurostat/issues) for feedback and bug reports.
  * [Send pull requests](https://github.com/ropengov/eurostat/)
  * [Star us on the Github page](https://github.com/ropengov/eurostat)
  * [Join the discussion in Gitter](https://gitter.im/rOpenGov/eurostat)

### Acknowledgements

**Kindly cite this work** as follows: [Leo Lahti](https://github.com/antagomir), Przemyslaw Biecek, Markus Kainu and Janne Huovari. Retrieval and analysis of Eurostat open data with the eurostat package. R Journal 2017 (in press; [preprint](https://journal.r-project.org/archive/2017/RJ-2017-019/index.html)). R package version 3.1.1. URL: [http://ropengov.github.io/eurostat](http://ropengov.github.io/eurostat)

We are greatful to all [contributors](https://github.com/rOpenGov/eurostat/graphs/contributors), including Joona Lehtomäki, Francois Briatte, and Oliver Reiter, and for the [Eurostat](http://ec.europa.eu/eurostat/) open data portal! This project is part of [rOpenGov](http://ropengov.github.io).





### Disclaimer

This package is in no way officially related to or endorsed by Eurostat.


[chat-badge]: https://img.shields.io/badge/chat-on%20gitter-46BC99.svg?style=flat-square
[chat]: https://gitter.im/kentcdodds/all-contributors?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
[build-badge]: https://img.shields.io/travis/kentcdodds/all-contributors.svg?style=flat-square
[build]: https://travis-ci.org/kentcdodds/all-contributors
[version-badge]: https://img.shields.io/npm/v/all-contributors.svg?style=flat-square
[package]: https://www.npmjs.com/package/all-contributors
[license-badge]: https://img.shields.io/npm/l/all-contributors.svg?style=flat-square
[license]: https://github.com/kentcdodds/all-contributors/blob/master/LICENSE
[prs-badge]: https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square
[prs]: http://makeapullrequest.com
[donate-badge]: https://img.shields.io/badge/$-support-green.svg?style=flat-square
[donate]: http://kcd.im/donate
[coc-badge]: https://img.shields.io/badge/code%20of-conduct-ff69b4.svg?style=flat-square
[coc]: https://github.com/kentcdodds/all-contributors/blob/master/other/CODE_OF_CONDUCT.md
[implementations-badge]: https://img.shields.io/badge/%F0%9F%92%A1-implementations-8C8E93.svg?style=flat-square
[implementations]: https://github.com/kentcdodds/all-contributors/blob/master/other/IMPLEMENTATIONS.md
[github-watch-badge]: https://img.shields.io/github/watchers/kentcdodds/all-contributors.svg?style=social
[github-watch]: https://github.com/kentcdodds/all-contributors/watchers
[github-star-badge]: https://img.shields.io/github/stars/kentcdodds/all-contributors.svg?style=social
[github-star]: https://github.com/kentcdodds/all-contributors/stargazers
[twitter]: https://twitter.com/intent/tweet?text=Check%20out%20all-contributors!%20%E2%9C%A8%20Recognize%20all%20contributors,%20not%20just%20the%20ones%20who%20commit%20code%20%E2%9C%A8%20https://github.com/kentcdodds/all-contributors%20%F0%9F%A4%97
[twitter-badge]: https://img.shields.io/twitter/url/https/github.com/kentcdodds/all-contributors.svg?style=social
[emojis]: https://github.com/kentcdodds/all-contributors#emoji-key
[all-contributors]: https://github.com/kentcdodds/all-contributors
