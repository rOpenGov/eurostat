## Test environments
* local ubuntu 14.10, R 3.1.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs. 

There were 2 NOTEs:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Leo Lahti <louhos@googlegroups.com>’
New submission
Components with restrictions and base license permitting such:
  BSD_2_clause + file LICENSE
File 'LICENSE':
  YEAR: 2014-2015
  COPYRIGHT HOLDER: Leo Lahti, Przemyslaw Biecek, Janne Huovari and Markus Kainu

* checking package dependencies ... NOTE
  No repository set, so cyclic dependency check skipped


## Resubmission
This is a resubmission. In this version I have:

* Added a period at the end of the Description field in DESCRIPTION file

* Removed mentions of API in documentation and DESCRIPTION file

* Moved NEWS file into markdown format (NEWS.md; in .Rbuildignore)

* In general polished the package for the first release
