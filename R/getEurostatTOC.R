# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# All rights reserved.
# This software is part of rOpenGov <ropengov.github.com>

#' Download a table of contents of eurostat datasets (ec.europa.eu/eurostat).
#' 
#' @description Download a table of contents of eurostat datasets. Note that the values in column 'code' should be used to download a selected dataset.
#' 
#'  @param ... Arguments to be passed
#'
#'  @return A data.frame with eight columns
#'      \item{title}{The name of dataset of theme}
#'      \item{code}{The codename of dataset of theme, will be used by the eurostat and get_eurostat_raw functions.}
#'      \item{type}{Is it a dataset, folder or table.}
#'      \item{last.update.of.data, last.table.structure.change, data.start, data.end}{Dates.}
#'
#' @export
#' @seealso \code{\link{get_eurostat}}, \code{\link{grepEurostatTOC}}.
#' @details The TOC is downloaded from \code{http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?sort=1&file=table_of_contents_en.txt}
#' @references
#' To cite the R package, see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tmp <- getEurostatTOC(); head(tmp)}
#' @keywords utilities database

getEurostatTOC <- function(...) {
  setEurostatTOC()
  invisible(get(".eurostatTOC", envir = .SmarterPolandEnv))
}
