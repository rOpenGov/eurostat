#' Lists names of dataset from eurostat with the particular pattern in the description. 
#' 
#' @description This function downloads list of all datasets available on eurostat and return list of names of datasets that contains particular pattern in the dataset description. E.g. all datasets related to education of teaching.
#'
#' Arguments:
#'  @param pattern Character, only datasets that contains this pattern in the description will be returned.
#'
#' Returns:
#'  @return A data.frame with eight columns
#'  	    \item{title}{The name of dataset of theme}
#'	    \item{code}{The codename of dataset of theme, will be used by the getEurostatRCV and getEurostatRaw functions.}
#'	    \item{type}{Is it a dataset, folder or table.}
#'	    \item{last.update.of.data, last.table.structure.change, data.start, data.end}{Dates.}
#'
#' @export
#' @seealso \code{\link{getEurostatRCV}}, \code{\link{getEurostatRaw}}, \code{\link{getEurostatTOC}}
#' @references
#' See citation("eurostat") 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{tmp <- grepEurostatTOC("education"); head(tmp)}
#' @keywords utilities database

grepEurostatTOC <-
function(pattern) {
  setEurostatTOC()
  tmp <- get(".eurostatTOC", envir = .SmarterPolandEnv)
  tmp <- tmp[tmp[,3]=="dataset",]
  tmp[grep(as.character(tmp[,1]), pattern=pattern),]
}
