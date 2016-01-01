#' Get data from eurostat APi in JSON 
#'
#' @param id A code name for the dataset of interested. See the table of
#'  contents of eurostat datasets for more details. 
#' @param filters 
#' @param lang A language used for metadata (en/fr/de).
#' @param type A type of variables, code (default) or label.
#'
#' @return A dataset in data.frame format.
#' @export
#'
#' @examples \dontrun{
#' 	       tmp <- get_eurostat_json("cdh_e_fos")
#'	       yy <- get_eurostat_json("nama_gdp_c", 
#'	                               filters = list(geo="EU28", 
#'	                                              unit="EUR_HAB",
#'	                                              indic_na="B1GM")) 
#'	     }
#' @keywords utilities database
get_eurostat_json <- function(id, filters = NULL, type = c("code", "label"), 
                              lang = c("en", "fr", "de")){
  url_list <- list(scheme = "http",
                   hostname = "ec.europa.eu",
                   path = file.path("eurostat/wdds/rest/data/v1.1/json", 
                                    lang[1], id),
                   query = filters)
  class(url_list) <- "url"
  url <- httr::build_url(url_list)
  jdat <- jsonlite::fromJSON(url)
  dims <- jdat[[1]]$dimension
  ids <- dims$id
  
  dims_list <- lapply(dims[rev(ids)], function(x){
    y <- x$category$label
    if (type[1] == "label") {
      y <- unlist(y, use.names = FALSE)
    } else if (type[1] == "code"){
      y <- names(unlist(y))
    } else {
      stop("Invalid type ", type)
    }
  })
  
  variables <- expand.grid(dims_list, KEEP.OUT.ATTRS = FALSE)
  
  dat <- data.frame(variables[rev(names(variables))], values = jdat[[1]]$value)
  dat
}
