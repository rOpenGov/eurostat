#/usr/bin/R CMD BATCH document.R
/usr/bin/R CMD build ../../
/usr/bin/R CMD check --as-cran eurostat_1.0.11.tar.gz
/usr/bin/R CMD INSTALL eurostat_1.0.11.tar.gz


