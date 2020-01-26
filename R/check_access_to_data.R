#' @title Check access to ec.europe.eu
#' @description Check if R has access to resources at http://ec.europa.eu
#' @export
#' @author Markus Kainu \email{markus.kainu@@kapsi.fi}
#' @return a logical.
#' @examples
#'  \dontrun{
#'    check_access_to_data()
#'  }

check_access_to_data <- function(){ 
  temp <- tempfile()
  http_url <- "http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_60M_2006_4326_LEVL_0.geojson"
  # If unix use curl::curl_download to test connection
  # If windows use download.file with default method 'wininet'
  if(.Platform$OS.type == "unix") {
    suppressWarnings(
      try(
        curl::curl_download(http_url, temp, quiet = TRUE, ), 
        silent = TRUE)
    )
    
  } else {
    suppressWarnings(
      try(
        download.file(http_url, 
                      temp, 
                      quiet= TRUE), 
        silent = TRUE)
    )
  }
  if (is.na(file.info(temp)$size)){
    FALSE
  }
  else{
    TRUE
  }
}