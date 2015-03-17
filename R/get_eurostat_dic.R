#' Download a Eurostat dictionary
#' 
#' @description Download a dictionary for given coded variable from 
#'              Eurostat (ec.europa.eu/eurostat). Dictionaries link
#'              codes with human-readable labels. To translate codes to labels
#'              with \code{\link{label_eurostat}}.
#' 
#' Arguments:
#'  @param dictname Character, dictionary for given variable name 
#'         will be downloaded.
#'
#' Returns:
#'  @return A data.frame with two columns, first with code names and 
#'          second with full names.
#'
#' @export
#' @seealso \code{\link{label_eurostat}}, \code{\link{get_eurostat}}, \code{\link{search_eurostat}}.
#' 
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{ropengov-forum@@googlegroups.com}
#' @examples \dontrun{
#' 	       tmp <- get_eurostat_dic("crop_pro")
#' 	       head(tmp)
#'	     }
#' @keywords utilities database

get_eurostat_dic <-
function(dictname) {
  url <- eurostat_url()		   
  read.table(paste(url, 
   "estat-navtree-portlet-prod/BulkDownloadListing?file=dic%2Fen%2F",
   dictname, ".dic", sep=""),
   sep="\t", header=F, stringsAsFactors=FALSE, quote = "\"",
   fileEncoding="Windows-1252")
}

#' @describeIn get_eurostat_dic Old deprecated version
#' @export
getEurostatDictionary <- function(dictname){
  .Deprecated("get_eurostat_dic")
}
