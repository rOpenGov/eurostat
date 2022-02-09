#' @title Clean Eurostat Cache
#' @description Delete all .rds files from the eurostat cache directory.
#'              See [get_eurostat()] for more on cache.
#' @param cache_dir A path to cache directory. If `NULL` (default)
#'        tries to clean default temporary cache directory.
#' @param config Logical `TRUE/FALSE`. Should the cached path be
#'       deleted?
#' @export
#' @family cache utilities
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari, Markus Kainu and
#'   Diego Hernangómez
#' @examples
#' \dontrun{
#' clean_eurostat_cache()
#' }
clean_eurostat_cache <- function(cache_dir = NULL, config = FALSE) {

  # Config
  # nocov start
  if (isTRUE(config)) {
    config_dir <- rappdirs::user_config_dir("eurostat", "R")

    if (dir.exists(config_dir)) {
      unlink(config_dir, recursive = TRUE, force = TRUE)
      message("eurostat cache config deleted")
    }

    set_eurostat_cache_dir(file.path(tempdir(), "eurostat"))
  }
  # nocov end

  cache_dir <- eur_helper_cachedir(cache_dir)

  if (!file.exists(cache_dir)) {
    stop(
      "The cache folder ", cache_dir,
      " does not exist"
    )
  }

  files <- list.files(cache_dir, pattern = "rds|RData", full.names = TRUE)
  if (length(files) == 0) {
    message("The cache folder ", cache_dir, " is empty.")
  } else {
    unlink(files)
    message("Deleted .rds/.RData files from ", cache_dir)
  }
  invisible(TRUE)
}
