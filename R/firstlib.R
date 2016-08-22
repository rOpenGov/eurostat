#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom httr build_url
#' @importFrom jsonlite fromJSON
#' @importFrom stringi stri_match_first_regex
#' @importFrom tidyr separate
#' @importFrom tidyr gather_
#' @importFrom tidyr extract_numeric
#' @importFrom utils download.file
#' @importFrom utils read.table
.EurostatEnv <- new.env()
