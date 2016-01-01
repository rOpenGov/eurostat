#' @title Grep datasets titles from eurostat
#' @description Lists names of dataset from eurostat with the particular
#' pattern in the description. Downloads list of all datasets available on
#' eurostat and return list of names of datasets that contains particular 
#' pattern in the dataset description. E.g. all datasets related to
#' education of teaching.
#' @param pattern Character, datasets, folder or tables with this pattern in 
#'  	  the description will be returned (depending on the 'type' argument)
#' @param type Grep the Eurostat table of contents either for 
#'  	  'dataset' (default), 'folder', 'table' or "all" (for all types) .
#' @return A data.frame with eight columns
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
#' @examples \dontrun{tmp <- search_eurostat("education"); head(tmp)}
#' @keywords utilities database
search_eurostat <- function(pattern, type = "dataset") {
  set_eurostat_toc()
  tmp <- get(".eurostatTOC", envir = .EurostatEnv)
  if (type != "all") tmp <- tmp[ tmp[, "type"] %in% type, ]
  tmp[ grep(as.character(tmp[, "title"]), pattern = pattern), ]
}


#' @describeIn search_eurostat Old deprecated version
#' @export
grepEurostatTOC <- function(pattern, type = "dataset"){
  .Deprecated("search_eurostat")
  search_eurostat(pattern = pattern, type = type)
}