#/usr/bin/R CMD BATCH document.R
~/bin/R-4.1.0/bin/R CMD build ../../ # --no-build-vignettes
~/bin/R-4.1.0/bin/R CMD check --as-cran eurostat_3.7.7.tar.gz # --no-build-vignettes
~/bin/R-4.1.0/bin/R CMD INSTALL eurostat_3.7.7.tar.gz
