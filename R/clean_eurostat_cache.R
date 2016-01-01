#' @title Clean Eurostat Cache
#' @description Delete all .rds files from the eurostat cache directory.
#'              See \code{\link{get_eurostat}} for more on cache.
#' @param cache_dir A path to cache directory. If \code{NULL} (default)
#'        tries to clean default temporary cache directory.
#' @export
#' @examples clean_eurostat_cache() 
clean_eurostat_cache <- function(cache_dir = NULL){
  if (is.null(cache_dir)){
    cache_dir <- getOption("eurostat_cache_dir", file.path(tempdir(), "eurostat"))
    if (!file.exists(cache_dir)) {
      message("The cache does not exist") 
      return(invisible(TRUE))
      }
  }
  if (!file.exists(cache_dir)) stop("The cache folder ", cache_dir, " does not exist")
  
  files <- list.files(cache_dir, pattern = "rds", full.names = TRUE)
  if (length(files) == 0) {
    message("The cache folder ", cache_dir, " is empty.")
  } else {
    unlink(files)
    message("Deleted .rds files from ", cache_dir)    
  }
  invisible(TRUE)
}
