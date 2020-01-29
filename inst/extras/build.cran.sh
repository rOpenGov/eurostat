#/usr/bin/R CMD BATCH document.R
~/bin/R-3.6.2/bin/R CMD build ../../ --no-build-vignettes
<<<<<<< HEAD
~/bin/R-3.6.2/bin/R CMD check --as-cran eurostat_3.5.20003.tar.gz  --no-build-vignettes
~/bin/R-3.6.2/bin/R CMD INSTALL eurostat_3.5.20003.tar.gz
||||||| merged common ancestors
~/bin/R-3.6.2/bin/R CMD check --as-cran eurostat_3.5.20001.tar.gz  --no-build-vignettes
~/bin/R-3.6.2/bin/R CMD INSTALL eurostat_3.5.20001.tar.gz
=======
~/bin/R-3.6.2/bin/R CMD check --as-cran eurostat_3.5.1.tar.gz  --no-build-vignettes
~/bin/R-3.6.2/bin/R CMD INSTALL eurostat_3.5.1.tar.gz
>>>>>>> 292b120bfd9d47233659ccd67abb1d190a8fcee3

