#' @title Download a Eurostat dictionary
#' @description Download a Eurostat dictionary. Download a dictionary for
#'              given coded variable from Eurostat (ec.europa.eu/eurostat).
#'              Dictionaries link codes with human-readable labels.
#'              To translate codes to labels with \code{\link{label_eurostat}}.
#' @param dictname A character, dictionary for given variable name 
#'        will be downloaded.
#' @param lang A character, code for language. Available are "en" (default), 
#'        "fr" and "de".
#' @return A data.frame with two columns, first with code names and 
#'          second with full names.
#' @export
#' @importFrom utils read.table
#' @seealso \code{\link{label_eurostat}}, \code{\link{get_eurostat}}, 
#'          \code{\link{search_eurostat}}.
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{ropengov-forum@@googlegroups.com}
#' @examples \dontrun{
#' 	       tmp <- get_eurostat_dic("crop_pro")
#' 	       head(tmp)
#' 	       tmp <- get_eurostat_dic("crop_pro", lang = "fr")
#'	     }
#' @keywords utilities database
get_eurostat_dic <- function(dictname, lang = "en") {
  url <- eurostat_url()		   
  utils::read.table(paste0(url, 
   "estat-navtree-portlet-prod/BulkDownloadListing?file=dic%2F", lang, "%2F",
   dictname, ".dic"),
   sep = "\t", header = FALSE, stringsAsFactors = FALSE, quote = "\"",
   fileEncoding = "Windows-1252")
}

#' @describeIn get_eurostat_dic Old deprecated version
#' @export
getEurostatDictionary <- function(dictname){
  .Deprecated("get_eurostat_dic")
}
