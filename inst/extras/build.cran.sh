#/usr/bin/R CMD BATCH document.R
/usr/bin/R CMD build ../../ # --no-build-vignettes
/usr/bin/R CMD check --as-cran eurostat_1.2.13.9001.tar.gz # --no-build-vignettes
/usr/bin/R CMD INSTALL eurostat_1.2.13.9001.tar.gz



