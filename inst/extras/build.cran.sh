#/usr/bin/R CMD BATCH document.R
~/bin/R-4.5.1/bin/R CMD build ../../ # --no-build-vignettes
~/bin/R-4.5.1/bin/R CMD check --as-cran eurostat_4.1.2.tar.gz # --no-build-vignettes
~/bin/R-4.5.1/bin/R CMD INSTALL eurostat_4.1.2.tar.gz
