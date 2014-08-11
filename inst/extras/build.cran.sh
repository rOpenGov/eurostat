#/usr/bin/R CMD BATCH document.R
/usr/bin/R CMD build ../../
/usr/bin/R CMD check --as-cran eurostat_0.9.35.tar.gz
/usr/bin/R CMD INSTALL eurostat_0.9.35.tar.gz

