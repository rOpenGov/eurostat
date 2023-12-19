#' @title Defunct functions in eurostat
#' 
#' @description
#' This list of defunct functions is maintained to document changes to eurostat functions in a
#' transparent manner.
#' 
#' @param ... Generic representation of old arguments
#' 
#' @name eurostat-defunct
#' @aliases eurostat-defunct
#' 
#' @details
#' The following functions are defunct:
#' 
#' \itemize{
#'  \item \code{\link{grepEurostatTOC}}: Use \code{search_eurostat} instead
#' }
#' 
#' 
NULL

#' @rdname eurostat-defunct
#' @export
grepEurostatTOC <- function(...) {
  .Defunct(new = "search_eurostat")
}