## Test environments
* local OS X install, R 3.5.1
* ubuntu 18.04 (on travis-ci), R 3.3.1
* win-builder (devel and release)

## R CMD check results

There were two warnings:

* building ‘eurostat_3.3.54.tar.gz’
Warning: invalid uid value replaced by that for user 'nobody'
Warning: invalid gid value replaced by that for user 'nobody'

* checking data for ASCII and uncompressed saves ... OK
 WARNING
‘qpdf’ is needed for checks on size reduction of PDFs



## Downstream dependencies

I have also run R CMD check on downstream dependencies.

All packages that I could install passed.


