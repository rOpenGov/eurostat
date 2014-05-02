#' setEurostatTOC
#' 
#' @description For internal use
#' 
#' Arguments:
#'  @param ... Arguments to be passed
#'
#' Returns:
#'  @return TBA
#'
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @examples #
#' @keywords internal

setEurostatTOC <- function(...) {
   if (!exists(".eurostatTOC", envir = .SmarterPolandEnv)) {
   .eurostatTOC <-  read.table("http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?sort=1&file=table_of_contents_en.txt",  sep="\t", header=T,  quote="\"", fill = TRUE, comment.char="")
    assign(".eurostatTOC", .eurostatTOC, envir = .SmarterPolandEnv)
  }
  invisible(0)
}
