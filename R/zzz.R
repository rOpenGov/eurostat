.onLoad <- function(libname, pkgname) {
  op <- options()
  op.eurostat <- list(
    eurostat_url = "https://ec.europa.eu/eurostat/"
  )
  # Only set options that are not already set
  toset <- !(names(op.eurostat) %in% names(op))
  if (any(toset)) options(op.eurostat[toset])
  invisible()
}
