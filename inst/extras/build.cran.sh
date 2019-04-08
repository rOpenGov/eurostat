#/usr/bin/R CMD BATCH document.R
~/bin/R-3.5.1/bin/R CMD build ../../ #--no-build-vignettes
<<<<<<< HEAD
~/bin/R-3.5.1/bin/R CMD check --as-cran eurostat_3.3.31.tar.gz  #--no-build-vignettes
~/bin/R-3.5.1/bin/R CMD INSTALL eurostat_3.3.31.tar.gz
=======
~/bin/R-3.5.1/bin/R CMD check --as-cran eurostat_3.3.32.tar.gz  #--no-build-vignettes
~/bin/R-3.5.1/bin/R CMD INSTALL eurostat_3.3.32.tar.gz
>>>>>>> 3e253d9df083ba373a6f72e915f0530f3d050f6a

