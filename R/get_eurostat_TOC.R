#' Download a table of contents of eurostat datasets.
#' 
#' @description Download a table of contents of eurostat datasets. 
#'              Note that the values in column 'code' should be used 
#'		to download a selected dataset.
#' 
#'  @return A data.frame with eight columns
#'      \item{title}{The name of dataset of theme}
#'      \item{code}{The codename of dataset of theme, will be used by the eurostat and get_eurostat_raw functions.}
#'      \item{type}{Is it a dataset, folder or table.}
#'      \item{last.update.of.data, last.table.structure.change, data.start, data.end}{Dates.}
#'
#' @export
#' @seealso \code{\link{get_eurostat}}, \code{\link{search_eurostat}}.
#' @details The TOC is downloaded from \url{http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=table_of_contents_en.txt}
#' @references See citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tmp <- get_eurostat_TOC(); head(tmp)}
#' @keywords utilities database
get_eurostat_TOC <- function() {
  set_eurostat_TOC()
  invisible(get(".eurostatTOC", envir = .EurostatEnv))
}

#' @describeIn get_eurostat_TOC Old depricated version
#' @export
getEurostatTOC <- function() {
  .Deprecated("get_eurostat_TOC")
  get_eurostat_TOC()
}


