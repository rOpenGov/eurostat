# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# All rights reserved.
# This software is part of rOpenGov <ropengov.github.com>

#' Download a dataset from the eurostat database (ec.europa.eu/eurostat).  
#' 
#' @description Download a dataset from the eurostat database. The dataset is transformed into the tabular format.
#' 
#' Arguments:
#'  @param id A code name for the data set of interested. See the table of contents of eurostat datasets for more details.
#'
#' Returns:
#'  @return A dataset in data.frame format. First column contains names of cases. Column names usually corresponds to years.
#'
#' @export
#' @seealso \code{\link{getEurostatTOC}}, \code{\link{getEurostatRaw}}, \code{\link{grepEurostatTOC}}.
#' @details Data is downloaded from \code{http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing} website.
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek, Leo Lahti \email{louhos@@googlegroups.com} and Janne Huovari \email{janne.huovari@ptt.fi}
#' @examples \dontrun{
#' 	       tmp <- getEurostatRaw("educ_iste")
#' 	       head(tmp)
#'	     }
#' @keywords utilities database

getEurostatRaw <-
function(id = "educ_iste") {

  adres <- paste("http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?sort=1&file=data%2F",id,".tsv.gz",sep="")
  tfile <- tempfile()

  #  download and read file
  download.file(adres, tfile)
  dat <- read.table(gzfile(tfile), sep="\t", na.strings = ": ", header=F, stringsAsFactors=F)
  unlink(tfile)
  colnames(dat) <- as.character(dat[1,])
  dat <- dat[-1,]

  #  remove additional marks
  for (i in 2:ncol(dat)) {
    dat[,i] <- extract_numeric(dat[,i])
  }
  dat
}
