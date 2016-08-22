#' @title Download Eurostat Dictionary
#' @description Download a Eurostat dictionary.
#' @details For given coded variable from Eurostat \url{ec.europa.eu/eurostat}.
#'    The dictionaries link codes with human-readable labels.
#'    To translate codes to labels, use \code{\link{label_eurostat}}.
#' @param dictname A character, dictionary for the variable to be downloaded.
#' @param lang A character, language code. Options: "en" (default) / "fr" / "de".
#' @return data.frame with two columns: code names and full names.
#' @export
#' @seealso \code{\link{label_eurostat}}, \code{\link{get_eurostat}}, 
#'          \code{\link{search_eurostat}}.
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{leo.lahti@@iki.fi}. Thanks to Wietse Dol for contributions. 
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
   sep = "\t", header = FALSE,
   colClasses = c('character','character'),
   stringsAsFactors = FALSE,
   quote = "\"",
   fileEncoding = "") # was: Windows-1252 or UTF-8
}

