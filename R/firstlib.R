#' @importFrom classInt classIntervals
#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom httr build_url
#' @importFrom jsonlite fromJSON
#' @importFrom RColorBrewer brewer.pal
#' @importFrom sp merge
#' @importFrom stringi stri_match_first_regex
#' @importFrom stringr str_replace_all
#' @importFrom tidyr separate
#' @importFrom tidyr gather_
#' @importFrom utils download.file
#' @importFrom utils read.table
#' @importFrom readr read_tsv
#' @importFrom readr col_character
.EurostatEnv <- new.env()
