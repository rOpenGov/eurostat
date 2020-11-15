#/usr/bin/R CMD BATCH document.R
~/bin/R-4.0.0/bin/R CMD build ../../ --no-build-vignettes
~/bin/R-4.0.0/bin/R CMD check --as-cran eurostat_3.6.72.tar.gz  --no-build-vignettes
~/bin/R-4.0.0/bin/R CMD INSTALL eurostat_3.6.72.tar.gz
