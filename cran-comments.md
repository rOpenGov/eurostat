## Test environments
* local OS X install, R 4.0.0
* ubuntu 20.04 (on travis-ci), R 4.4.0
* win-builder (devel and release)

## R CMD check results

There is one note:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Leo Lahti <leo.lahti@iki.fi>’

New submission

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2020-10-27 as reauired archived package
      'RefManageR'.
      

-> The reason is that RefManageR was removed from CRAN against our
expectations, and then subsequently eurostat, which depends on
RefManageR, was removed. We have been waiting for RefManageR fix. But
this is taking long, so I removed those parts while waiting and hope
to have eurostat in CRAN while RefManageR problem is getting solved
with CRAN.



## Downstream dependencies

I have also run R CMD check on downstream dependencies.

All packages that I could install passed.


