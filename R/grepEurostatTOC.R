#' Lists names of dataset from eurostat with the particular pattern in the description. 
#' 
#' @description This function downloads list of all datasets available on eurostat and return list of names of datasets that contains particular pattern in the dataset description. E.g. all datasets related to education of teaching.
#'
#' Arguments:
#'  @param pattern Character, datasets, folder or tables with this pattern in the description will be returned (depending on the 'type' argument)
#'  @param type Grep the Eurostat table of contents either for 'dataset', 'folder' or 'table'.
#'
#' Returns:
#'  @return A data.frame with eight columns
#'  	    \item{title}{The name of dataset of theme}
#'	    \item{code}{The codename of dataset of theme, will be used by the get_eurostat and get_eurostat_raw functions.}
#'	    \item{type}{Is it a dataset, folder or table.}
#'	    \item{last.update.of.data, last.table.structure.change, data.start, data.end}{Dates.}
#'
#' @export
#' @seealso \code{\link{get_eurostat}}, \code{\link{get_eurostat_raw}}, \code{\link{getEurostatTOC}}
#' @references
#' See citation("eurostat") 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tmp <- grepEurostatTOC("education"); head(tmp)}
#' @keywords utilities database

grepEurostatTOC <- function(pattern, type = "dataset") {
  setEurostatTOC()
  tmp <- get(".eurostatTOC", envir = .SmarterPolandEnv)
  tmp <- tmp[tmp[, "type"] %in% type,]
  tmp[grep(as.character(tmp[, "title"]), pattern=pattern),]
}
