## R CMD check results

On R 4.2.2 under aarch64-apple-darwin20 (64-bit), macOS Ventura 13.2.1

0 errors | 0 warnings | 1 note

* checking for future file timestamps ... NOTE
  unable to verify current time
  
Seems to be a problem related to worldclockapi.com, that has already been discussed in 2019 on r-package-devel mailing list.

On R 2023-02-21 r83888 ucrt under x86_64-w64-mingw32 (64-bit), Windows Server 2022 x64 (devtools::check_win_devel):

0 errors | 0 warnings | 0 notes

## Downstream dependencies

We checked 8 reverse dependencies with revdepcheck, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
