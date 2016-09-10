#/usr/bin/R CMD BATCH document.R
/usr/bin/R CMD build ../../ --no-build-vignettes
/usr/bin/R CMD check --as-cran eurostat_2.0.1.tar.gz --no-build-vignettes
/usr/bin/R CMD INSTALL eurostat_2.0.1.tar.gz



