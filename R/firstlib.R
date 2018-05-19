#' @import dplyr
#' @import methods
#' @importFrom classInt classIntervals
#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom httr build_url
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom RColorBrewer brewer.pal
#' @importFrom readr read_tsv
#' @importFrom readr col_character
#' @importFrom sf st_as_sf
#' @importFrom sp merge
#' @importFrom stringi stri_match_first_regex
#' @importFrom stringr str_replace_all
#' @importFrom tibble data_frame
#' @importFrom tibble is_tibble
#' @importFrom tibble as_data_frame
#' @importFrom tidyr separate
#' @importFrom tidyr gather_
#' @importFrom utils download.file
#' @importFrom sf st_read
#' @importFrom sf as_Spatial
#' @importFrom dplyr filter
#' @importFrom dplyr left_join
#' @importFrom broom tidy
#' @importFrom methods as
#' @importFrom utils data
.EurostatEnv <- new.env()
