#' @title Get Data from Eurostat API in JSON 
#' @description Retrieve data from Eurostat API in JSON format.
#' @details Data to retrieve from \href{http://ec.europa.eu/eurostat/web/json-and-unicode-web-services}{The Eurostat Web Services} can be specified with filters. Normally, it is better to use JSON query through \code{\link{get_eurostat}}, than to use \code{\link{get_eurostat_json}} directly.
#' @details Queries are limited to 50 sub-indicators at a time.
#'    A time can be filtered with fixed "time" filter or with "sinceTimePeriod"
#'    and "lastTimePeriod" filters. A \code{sinceTimePeriod = 2000} returns
#'    observations from 2000 to a last available. A \code{lastTimePeriod = 10}
#'    returns a 10 last observations.
#' @param id A code name for the dataset of interested. See the table of
#'        contents of eurostat datasets for more details. 
#' @param filters A named list of filters. Names of list objects are 
#'        Eurostat variable codes and values are vectors of observation codes. 
#'        If \code{NULL} (default) the whole 
#'        dataset is returned. See details for more on filters and 
#'        limitations per query.
#' @param lang A language used for metadata (en/fr/de).
#' @param type A type of variables, "code" (default), "label" or "both". The 
#'        "both" will return a data_frame with named vectors, labels as values 
#'        and codes as names.
#' @param stringsAsFactors if \code{TRUE} (the default) variables are
#'         converted to factors in original Eurostat order. If \code{FALSE}
#'         they are returned as a character.
#'
#' @return A dataset as a data_frame.
#' @export
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari and Markus Kainu \email{ropengov-forum@@googlegroups.com} \url{http://github.com/ropengov/eurostat}
#' @examples
#'  \dontrun{
#'    tmp <- get_eurostat_json("cdh_e_fos")
#'    yy <- get_eurostat_json(id = "nama_gdp_c", filters = list(geo=c("EU28", "FI"), 
#'                                                         unit="EUR_HAB",
#'                                                         indic_na="B1GM")) 
#' }
#' @keywords utilities database
get_eurostat_json <- function(id, filters = NULL, 
                              type = c("code", "label", "both"), 
                              lang = c("en", "fr", "de"),
                              stringsAsFactors = default.stringsAsFactors()){
  
  #get response
  url <- eurostat_json_url(id = id, filters = filters, lang = lang)
  resp <- httr::GET(url)
  status <- httr::status_code(resp)
  
  # check status and get json
  if (status == 200){
    jdat <- jsonlite::fromJSON(url)
  } else if (status == 400){
    stop("Failure to get data. Probably invalid dataset id. Status code: ", 
         status)
  } else if (status == 500){
    stop("Failure to get data. Probably filters did not return any data 
         or data exceeded query size limitation. Status code: ", status)
  } else {
    stop("Failure to get data. Status code: ", status)
  }
  
  # get json data
  dims <- jdat[[1]]$dimension
  ids <- dims$id
  
  dims_list <- lapply(dims[rev(ids)], function(x){
    y <- x$category$label
    if (type[1] == "label") {
      y <- unlist(y, use.names = FALSE)
    } else if (type[1] == "code"){
      y <- names(unlist(y))
    } else if (type[1] == "both"){
      y <- unlist(y)
    } else {
      stop("Invalid type ", type)
    }
  })
  
  variables <- expand.grid(dims_list, KEEP.OUT.ATTRS = FALSE, 
                           stringsAsFactors = stringsAsFactors)
  
  dat <- data.frame(variables[rev(names(variables))], values = jdat[[1]]$value)
  
  as_data_frame(dat)
  
}



# Internal function to build json url
eurostat_json_url <- function(id, filters, lang){

  # prepare filters for query
  filters2 <- as.list(unlist(filters))
  names(filters2) <- rep(names(filters), lapply(filters, length))
  
  # prepare url
  url_list <- list(scheme = "http",
                   hostname = "ec.europa.eu",
                   path = file.path("eurostat/wdds/rest/data/v1.1/json", 
                                    lang[1], id),
                   query = filters2)
  class(url_list) <- "url"
  url <- httr::build_url(url_list)
  url
}