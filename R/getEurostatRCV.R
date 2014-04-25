# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# All rights reserved.
# This software is part of rOpenGov <ropengov.github.com>

#' Download a dataset from the eurostat database (ec.europa.eu/eurostat).  
#' 
#' @description Download a dataset from the eurostat database. The dataset is transformed into the molten / row-column-value format (RCV).
#' 
#' Arguments:
#'  @param kod A code name for the data set of interest. See the table of contents of eurostat datasets for details.
#'
#' Returns:
#'  @return A dataset in the molten format with the last column 'value'. See the melt function from reshape package for more details.
#'
#' @export
#' @seealso \code{\link{getEurostatTOC}}, \code{\link{getEurostatRaw}}, \code{\link{grepEurostatTOC}}
#' @details Data is downloaded from \code{http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing} website.
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{
#'    tmp <- getEurostatRCV(kod = "educ_iste")
#'    head(tmp)
#'    t1 <- getEurostatRCV("tsdtr420")
#'    tmp <- cast(t1, geo ~ time , mean, subset=victim=="KIL_MIO_POP")
#'    tmp2 <- tmp[c(1:10,14:30),1:19]
#'    tmp3 <- tmp2
#'    rownames(tmp3) <- tmp2[,1]
#'    tmp3 <- tmp3[c("UK", "SK", "FR", "PL", "ES", "PT", "LV"),]
#'    matplot(1991:2008, t(tmp3[,-1]), type="o", 
#'            pch=19, lty=1, las=1, 
#'	      xlab="", ylab="", yaxt="n")
#'    }
#' @keywords utilities database

getEurostatRCV <-
function(kod = "educ_iste") {

  dat <- getEurostatRaw(kod)
  dat2 <- t(as.data.frame(strsplit(as.character(dat[,1]), split=",")))
  cnames <- strsplit(colnames(dat)[1], split="[,\\\\]")[[1]]
  colnames(dat2) <- cnames[-length(cnames)]
  rownames(dat2) <- dat[,1]
  rownames(dat) <- dat[,1]
  dat3 <- data.frame(dat2, dat[,-1])
  colnames(dat3) <- c(colnames(dat2), colnames(dat)[-1])
  dat4 <- melt(dat3, id=cnames[-length(cnames)])
  colnames(dat4)[ncol(dat4)-1] = cnames[length(cnames)]

  dat4

}
