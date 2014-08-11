# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# All rights reserved.
# This software is part of rOpenGov <ropengov.github.com>

#'Download a dataset from the eurostat database (ec.europa.eu/eurostat).
#'
#'@description Download a dataset from the eurostat database. The dataset is
#'  transformed into the tabular format.
#'  
#'  Arguments:
#'@param id A code name for the data set of interested. See the table of
#'  contents of eurostat datasets for more details.
#'  
#'  Returns:
#'@return A dataset in data.frame format. First column contains comma separated
#'  codes of cases. Other columns usually corresponds to years and column names 
#'  are years with preceding X. Data is in character format as it contains values
#'  together with eurostat flags for data.
#'  
#'@export
#'@seealso \code{\link{getEurostatTOC}}, \code{\link{get_eurostat}}.
#'@details Data is downloaded from
#'  \code{http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing}
#'  website.
#'@references see citation("eurostat").
#' @examples \dontrun{
#' 	       tmp <- get_eurostat_raw("educ_iste")
#' 	       head(tmp)
#'	     }
#'@keywords utilities database

get_eurostat_raw <-
function(id) {

  adres <- paste("http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?sort=1&file=data%2F",id,".tsv.gz",sep="")
  tfile <- tempfile()
  on.exit(unlink(tfile))
  
  #  download and read file
  download.file(adres, tfile)
  dat <- read.table(gzfile(tfile), sep="\t", na.strings = ": ", 
                    header = TRUE, stringsAsFactors = FALSE)
  
  dat
}
