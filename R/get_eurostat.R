#' Read data from Eurostat database.
#' 
#' Download dataset from the Eurostat database (\url{ec.europa.eu/eurostat}). 
#' 
#' @param id A code name for the data set of interest. See the table of contents of eurostat datasets for details.
#' @param time_format a string giving a type of the conversion of the time 
#' 	  column from the eurostat format. A "date" (default) convers to 
#'	  a \code{\link{Date}} with a first date of the period. 
#'	  A "date_last" convers to a \code{\link{Date}} with 
#'         a last date of the period. A "num" convers to a numeric and "raw" 
#'         does not do conversion. See \code{\link{eurotime2date}} and 
#'         \code{\link{eurotime2num}}.
#' @param cache a logical wheather to do caching. Default is \code{TRUE}.
#' @param update_cache a locigal wheater to update cache. Can be set also with
#' 	  options(eurostat_update = TRUE)
#' @param cache_dir a path to cache directory. The \code{NULL} uses directory 
#'        eurostat directory in the temporary directory from 
#'        \code{\link{tempdir}}. Directory can be set also with 
#'        \code{option} eurostat_cache_dir.
#' 
#' @export
#' @details Datasets are downloaded from the Eurostat bulk download facility 
#' \url{http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing}. The data is transformed into the molten row-column-value format (RCV).
#' 
#' By default datasets are cached. In a temporary directory by default or in 
#' a named directory if cache_dir or option eurostat_cache_dir is defined.
#'
#'
#' @return a data.frame. One column for each dimension in the data and 
#'    the values column for numerical values. 
#'    The time column for a time dimension. 
#' @seealso \code{{\link{tidy_eurostat}}}
#' @examples \dontrun{
#' k <- get_eurostat("namq_aux_lp")
#' k <- get_eurostat("namq_aux_lp", update_cache = TRUE)
#' dir.create("r_cache")
#' k <- get_eurostat("namq_aux_lp", cache_dir = "r_cache")
#' options(eurostat_update = TRUE)
#' k <- get_eurostat("namq_aux_lp")
#' options(eurostat_cache_dir = "r_cache")
#' k <- get_eurostat("namq_aux_lp")
#' k <- get_eurostat("namq_aux_lp", cache = FALSE)
#' }
get_eurostat <- function(id, time_format = "date", cache = TRUE, 
                         update_cache = FALSE, cache_dir = NULL){

  if (cache){  
    # check option for update
    update_cache <- update_cache | getOption("eurostat_update", FALSE)
    
    # get cache directory
    if (is.null(cache_dir)){
      cache_dir <- getOption("eurostat_cache_dir", NULL)
      if (is.null(cache_dir)){
        cache_dir <- file.path(tempdir(), "eurostat")
        if (!file.exists(cache_dir)) dir.create(cache_dir)
      } else {
        if (!file.exists(cache_dir)) {
          stop("The folder ", cache_dir, " does not exist")
          }
      }
    }
    
    # cache filename
    cache_file <- file.path(cache_dir, paste0(id, ".rds"))
  }
  
  # if cache = FALSE or update or new: dowload else read from cache
  if (!cache || update_cache || !file.exists(cache_file)){
    y_raw <- get_eurostat_raw(id)
    y <- tidy_eurostat(y_raw, time_format)
  } else {
    y <- readRDS(cache_file)
    message("Table ", id, " read from cache file: ", path.expand(cache_file))   
  }
  
  # if update or new: save
  if (cache && (update_cache || !file.exists(cache_file))){
    saveRDS(y, file = cache_file)
    message("Table ", id, " cached at ", path.expand(cache_file))    
  }

  y    
}