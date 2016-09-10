#' @importFrom classInt classIntervals
#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom httr build_url
#' @importFrom jsonlite fromJSON
#' @importFrom RColorBrewer brewer.pal
#' @importFrom readr read_tsv
#' @importFrom readr col_character
#' @importFrom sp merge
#' @importFrom stringi stri_match_first_regex
#' @importFrom stringr str_replace_all
#' @importFrom tibble data_frame
#' @importFrom tibble is_tibble
#' @importFrom tibble as_data_frame
#' @importFrom tidyr separate
#' @importFrom tidyr gather_
#' @importFrom utils download.file
.EurostatEnv <- new.env()
