#' A funtion to read data from Eurostat database.
#' 
#' Download a dataset from the eurostat database (ec.europa.eu/eurostat). 
#' The dataset is transformed into the molten / row-column-value format (RCV).
#' 
#' Cache as default
#' 
#' @param id A code name for the data set of interest. See the table of contents of eurostat datasets for details.
#' @param time_format a string giving a type of the conversion of the time column from 
#'         the eurostat format. A "date" (default) convers to a \code{\link{Date}} with a first 
#'         date of the period. A "date_last" convers to a \code{\link{Date}} with 
#'         a last date of the period. A "num" convers to a numeric and "raw" 
#'         does not do conversion. See \code{\link{eurotime2date}} and 
#'         \code{\link{eurotime2num}}.
#'
#' @param cache \code{TRUE} to temp-directory, \code{FALSE} to turn off 
#' or a directory. Also \code{option} eurostat_cache_dir
#' @param update_cache a locigal wheater to update cache. Can be set also with
#' options(eurostat_update = TRUE)
#' 
#' @export
#' @examples \dontrun{
#' k <- get_eurostat("namq_aux_lp")
#' k <- get_eurostat("namq_aux_lp", update_cache = TRUE)
#' dir.create("r_cache")
#' k <- get_eurostat("namq_aux_lp", cache = "r_cache")
#' options(eurostat_update = TRUE)
#' k <- get_eurostat("namq_aux_lp")
#' options(eurostat_cache_dir = "r_cache")
#' k <- get_eurostat("namq_aux_lp")
#' k <- get_eurostat("namq_aux_lp", cache = FALSE)
#' }
get_eurostat <- function(id, time_format = "date", cache = TRUE, update_cache = FALSE){
  if (!update_cache & getOption("eurostat_update", FALSE)) update_cache = TRUE
  if (is.character(cache)){
    if (!file.exists(cache)) stop("The folder ", cache, " Does not exist")
    cache_file <- file.path(cache, paste0(id, ".rds"))
  } else if (cache) {
    cache_file <- file.path(getOption("eurostat_cache_dir", tempdir()), 
                            paste0(id, ".rds"))
  }
      
  if (is.logical(cache) && !cache){
    x <- tidy_eurostat(id, time_format)
  } else if (update_cache || !file.exists(cache_file)) {
    x <- tidy_eurostat(id, time_format)
    saveRDS(x, file = cache_file)
    message("Table ", id, " cached at ", path.expand(cache_file))
  } else {
    x <- readRDS(cache_file)
    message("Table ", id, " read from cache file: ", path.expand(cache_file))
  }
  x    
}