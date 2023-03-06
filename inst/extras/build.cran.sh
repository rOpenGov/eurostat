#/usr/bin/R CMD BATCH document.R
~/bin/R-4.2.2/bin/R CMD build ../../ # --no-build-vignettes
~/bin/R-4.2.2/bin/R CMD check --as-cran eurostat_3.8.2.tar.gz # --no-build-vignettes
~/bin/R-4.2.2/bin/R CMD INSTALL eurostat_3.8.2.tar.gz
