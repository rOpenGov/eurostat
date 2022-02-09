#' @title Download Table of Contents of Eurostat Data Sets
#' @description Download table of contents (TOC) of eurostat datasets.
#' @return
#' A tibble with eight columns:
#'   * title: The name of dataset of theme.
#'   * code: The codename of dataset of theme, will be used by the
#'        [get_eurostat()] and [get_eurostat_raw()] functions.
#'   * type: Is it a dataset, folder or table.
#'   * last.update.of.data, last.table.structure.change,
#'        data.start, data.end: Dates.
#' @export
#' @seealso [get_eurostat()], [search_eurostat()].
#' @details The TOC is downloaded from <https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=table_of_contents_en.txt>. The values in column 'code' should be used to download a selected dataset.
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @author Przemyslaw Biecek and Leo Lahti <ropengov-forum@@googlegroups.com>
#' @examplesIf check_access_to_data()
#' \donttest{
#' tmp <- get_eurostat_toc()
#' head(tmp)
#' }
#' @keywords utilities database
get_eurostat_toc <- function() {
  set_eurostat_toc()
  invisible(get(".eurostatTOC", envir = .EurostatEnv))
}

# @describeIn get_eurostat_toc Old deprecated version
# @export
# getEurostatTOC <- function() {
#  .Deprecated("get_eurostat_toc")
#  get_eurostat_toc()
# }
