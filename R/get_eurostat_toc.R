#' @title Download Table of Contents of Eurostat Data Sets
#' @description Download table of contents (TOC) of eurostat datasets.
#' @details In the downloaded Eurostat Table of Contents the 'code' column 
#' values are refer to the function 'id' that is used as an argument in certain
#' functions when downloading datasets.
#' @return A tibble with eight columns:
#' \describe{
#'    \item{title}{Dataset title in English (default)}
#' 	  \item{code}{ Each item (dataset, table and folder) of the TOC has a 
#' 	  unique code which allows it to be identified in the API. Used in the
#' 	  [get_eurostat()] and [get_eurostat_raw()] functions to retrieve datasets.}
#' 	  \item{type}{dataset, folder or table}
#' 	  \item{last.update.of.data}{Date, indicates the last time the 
#' 	  dataset/table was updated}
#' 	  \item{last.table.structure.change}{Date, indicates the last time the 
#' 	  dataset/table structure was modified}
#' 	  \item{data.start}{Date of the oldest value included in the dataset 
#' 	  (if available)}
#' 	  \item{data.end}{Date of the most recent value included in the dataset 
#' 	  (if available)}
#' }
#' 
#' @seealso [get_eurostat()], [search_eurostat()]
#' @inheritSection eurostat-package Data source: Eurostat Table of Contents
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @author
#' Przemyslaw Biecek and Leo Lahti <ropengov-forum@@googlegroups.com>
#' 
#' @examplesIf check_access_to_data()
#' \donttest{
#' tmp <- get_eurostat_toc()
#' head(tmp)
#' }
#' @keywords utilities database
#' @export
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
