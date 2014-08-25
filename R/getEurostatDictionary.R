# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# All rights reserved.
# This software is part of rOpenGov <ropengov.github.com>

#' getEurostatDictionary
#' 
#' @description Download a dictionary for given coded variable from Eurostat (ec.europa.eu/eurostat). 
#' 
#' Arguments:
#'  @param dictname Character, dictionary for given variable name will be downloaded.
#'
#' Returns:
#'  @return A data.frame with two columns, first with code names and second with full names.
#'
#' @export
#' @seealso \code{\link{get_eurostat}}, \code{\link{get_eurostat_raw}}, \code{\link{grepEurostatTOC}}.
#' @details The TOC is downloaded from the \code{http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?file=dic....}
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{
#' 	       tmp <- getEurostatDictionary("crop_pro")
#' 	       head(tmp)
#'	     }
#' @keywords utilities database

getEurostatDictionary <-
function(dictname) {
  read.table(paste("http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?file=dic%2Fen%2F",dictname,".dic",sep=""),
             sep="\t", header=F, stringsAsFactors=FALSE, quote = "\"",fileEncoding="Windows-1252")
}