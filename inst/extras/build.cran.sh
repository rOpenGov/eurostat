#/usr/bin/R CMD BATCH document.R
~/bin/R-3.6.2/bin/R CMD build ../../ --no-build-vignettes
~/bin/R-3.6.2/bin/R CMD check --as-cran eurostat_3.5.20003.tar.gz  --no-build-vignettes
~/bin/R-3.6.2/bin/R CMD INSTALL eurostat_3.5.20003.tar.gz

