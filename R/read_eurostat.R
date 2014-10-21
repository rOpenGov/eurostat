#' To read data from Eurostat database.
#' 
#' Cache as default 
#'
#' @param cache \code{TRUE} to temp-directory, \code{FALSE} to turn off 
#' or a directory. Also \code{option} eurostat_cache_dir  
#' @param update_cache a locigal wheater to update cache. Can be set also with
#' options(eurostat_update = TRUE)
#' @param ... arguments passed to get_eurostat. Only if cache FALSE 
#' or update_cache TRUE 
#' @examples \dontrun{
#' k <- read_eurostat("namq_aux_lp")
#' k <- read_eurostat("namq_aux_lp", update_cache = TRUE)
#' dir.create("r_cache")
#' k <- read_eurostat("namq_aux_lp", cache = "r_cache")
#' options(eurostat_update = TRUE)
#' k <- read_eurostat("namq_aux_lp")
#' options(eurostat_cache_dir = "r_cache")
#' k <- read_eurostat("namq_aux_lp")
#' k <- read_eurostat("namq_aux_lp", cache = FALSE)
#' }
read_eurostat <- function(id, cache = TRUE, update_cache = FALSE, ...){
  if (!update_cache & getOption("eurostat_update", FALSE)) update_cache = TRUE
  if (is.character(cache)){
    if (!file.exists(cache)) stop("The folder ", cache, " Does not exist")
    cache_file <- file.path(cache, paste0(id, ".rds"))
  } else if (cache) {
    cache_file <- file.path(getOption("eurostat_cache_dir", tempdir()), 
                            paste0(id, ".rds"))
  }
      
  if (is.logical(cache) && !cache){
    x <- get_eurostat(id, ...)
  } else if (update_cache || !file.exists(cache_file)) {
    x <- get_eurostat(id, ...)
    saveRDS(x, file = cache_file)
    message("Table ", id, " cached at ", path.expand(cache_file))
  } else {
    x <- readRDS(cache_file)
    message("Table ", id, " read from cache file: ", path.expand(cache_file))
  }
  x    
}