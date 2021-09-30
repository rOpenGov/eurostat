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
    url <- paste(base, "estat-navtree-portlet-prod/",
      "BulkDownloadListing?sort=1&downfile=table_of_contents_en.txt",
      sep = ""
    )
    .eurostatTOC <- readr::read_tsv(url(url),
      col_types = readr::cols(.default = readr::col_character())
    )

    assign(".eurostatTOC", .eurostatTOC, envir = .EurostatEnv)
  }
  invisible(0)
}
