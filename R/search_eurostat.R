#' @title Grep Datasets Titles from Eurostat
#' @description Lists names of dataset from eurostat with the particular
#' pattern in the description.
#' @details Downloads list of all datasets available on
#' eurostat and return list of names of datasets that contains particular
#' pattern in the dataset description. E.g. all datasets related to
#' education of teaching.
#' @param pattern Character, datasets, folder or tables with this pattern in
#'  	  the description will be returned (depending on the 'type' argument)
#' @param type Grep the Eurostat table of contents either for
#'  	  'dataset' (default), 'folder', 'table' or "all" (for all types).
#' @param fixed logical. If TRUE, pattern is a string to be matched as is.
#'      Change to FALSE if more complex regex matching is needed.
#' @return A tibble with eight columns
#'    \itemize{
#'  	\item{title}{The name of dataset of theme}
#'	\item{code}{The codename of dataset of theme, will be used by the get_eurostat and get_eurostat_raw functions.}
#'	\item{type}{Is it a dataset, folder or table.}
#'	\item{last.update.of.data, last.table.structure.change, data.start, data.end}{Dates.}
#'    }
#' @export
#' @seealso \code{\link{get_eurostat}}, \code{\link{get_eurostat_toc}}
#' @references See citation("eurostat")
#' @author Przemyslaw Biecek and Leo Lahti \email{ropengov-forum@@googlegroups.com}
#' @examples \dontrun{
#'   tmp <- search_eurostat("education")
#'   head(tmp)
#'   # Use "fixed = TRUE" when pattern has characters that would need escaping.
#'   # Here, parentheses would normally need to be escaped in regex
#'   tmp <- search_eurostat("Live births (total) by NUTS 3 region", fixed = TRUE)
#' }
#' @keywords utilities database
search_eurostat <- function(pattern, type = "dataset", fixed = TRUE) {
  
  # Check if you have access to ec.europe.eu. 
  if (!check_access_to_data()){
    message("You have no access to ec.europe.eu. 
      Please check your connection and/or review your proxy settings")
  } else {
  
  set_eurostat_toc()
  tmp <- get(".eurostatTOC", envir = .EurostatEnv)
  if (type != "all") tmp <- tmp[ tmp$type %in% type, ]
  tmp[ grep(tmp$title, pattern = pattern, fixed = fixed), ]
  }
}


#' @describeIn search_eurostat Old deprecated version
#' @export
grepEurostatTOC <- function(pattern, type = "dataset"){
  .Deprecated("search_eurostat")
  search_eurostat(pattern = pattern, type = type)
}
