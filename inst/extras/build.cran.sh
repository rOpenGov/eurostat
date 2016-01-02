#~/bin/R-3.2.0/bin/R CMD BATCH document.R
#~/bin/R-3.2.0/bin/R CMD build ../../
#~/bin/R-3.2.0/bin/R CMD check --as-cran eurostat_1.1.9001.tar.gz
#~/bin/R-3.2.0/bin/R CMD INSTALL eurostat_1.0.9001.tar.gz

#/usr/local/bin/R CMD BATCH document.R
/usr/local/bin/R CMD build ../../ --no-build-vignettes
/usr/local/bin/R CMD check --as-cran eurostat_1.1.9007.tar.gz --no-build-vignettes
/usr/local/bin/R CMD INSTALL eurostat_1.1.9007.tar.gz



