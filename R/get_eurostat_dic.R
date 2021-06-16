#' @title Download Eurostat Dictionary
#' @description Download a Eurostat dictionary.
#' @details For given coded variable from Eurostat \url{https://ec.europa.eu/eurostat/}.
#'    The dictionaries link codes with human-readable labels.
#'    To translate codes to labels, use \code{\link{label_eurostat}}.
#' @param dictname A character, dictionary for the variable to be downloaded.
#' @param lang A character, language code. Options: "en" (default) / "fr" / "de".
#' @return tibble with two columns: code names and full names.
#' @export
#' @seealso \code{\link{label_eurostat}}, \code{\link{get_eurostat}}, 
#'          \code{\link{search_eurostat}}.
#' @references See citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{leo.lahti@@iki.fi}. Thanks to Wietse Dol for contributions. 
#' @examples 
#' \dontrun{
#' tmp <- get_eurostat_dic("crop_pro")
#' head(tmp)
#' tmp <- get_eurostat_dic("crop_pro", lang = "fr")
#' }
#'	     
#' @importFrom readr read_tsv cols col_character
#'	     
#' @keywords utilities database
get_eurostat_dic <- function(dictname, lang = "en") {
  dictlang <- paste0(dictname, "_", lang)
  if (!exists(dictlang, envir = .EurostatEnv)) {
    url <- getOption("eurostat_url")
    tname <- paste0(url, 
                    "estat-navtree-portlet-prod/BulkDownloadListing?file=dic%2F", lang, "%2F",
                    dictname, ".dic")
    dict <- readr::read_tsv(url(tname), col_names = c("code_name", "full_name"),
                    col_types = readr::cols(.default = readr::col_character()))
    dict$full_name <- gsub(pattern="\u0092", replacement="'", dict$full_name)

    assign(dictlang, dict, envir = .EurostatEnv)
  }
  get(dictlang, envir = .EurostatEnv)
}

