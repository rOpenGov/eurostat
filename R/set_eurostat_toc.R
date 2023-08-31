#' @title Set Eurostat TOC
#' @description Internal function.
#' @param ... Arguments to be passed
#' @return Empty element
#' @references see citation("eurostat")
#' @author Przemyslaw Biecek and Leo Lahti <ropengov-forum@@googlegroups.com>
#'
#' @importFrom readr read_tsv cols col_character
#'
#' @keywords internal
set_eurostat_toc <- function(...) {
  if (!exists(".eurostatTOC", envir = .EurostatEnv)) {
    base <- getOption("eurostat_url")
    url <- paste(base, "api/dissemination/catalogue/toc/txt?lang=en",
      sep = ""
    )
    .eurostatTOC <- readr::read_tsv(url(url),
      col_types = readr::cols(.default = readr::col_character())
    )
    
    # Clean the names, replace " " (empty spaces) with "."
    names(.eurostatTOC) <- gsub(" ", ".", names(.eurostatTOC))

    assign(".eurostatTOC", .eurostatTOC, envir = .EurostatEnv)
  }
  invisible(0)
}
