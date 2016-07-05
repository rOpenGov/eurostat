#' @title set_eurostat_toc
#' @description For internal use
#' @param ... Arguments to be passed
#' @return Empty element
#' @references see citation("eurostat")
#' @importFrom utils read.table
#' @author Przemyslaw Biecek and Leo Lahti \email{ropengov-forum@@googlegroups.com}
#' @keywords internal
set_eurostat_toc <- function(...) {
   if (!exists(".eurostatTOC", envir = .EurostatEnv)) {
   base <- eurostat_url()
   url <- paste(base, "estat-navtree-portlet-prod/", 
       	 "BulkDownloadListing?sort=1&downfile=table_of_contents_en.txt", 
	 sep = "")
   .eurostatTOC <- utils::read.table(file = url, sep = "\t", header = TRUE, quote = "\"", 
                              fill = TRUE, comment.char = "", stringsAsFactors = FALSE)
    assign(".eurostatTOC", .eurostatTOC, envir = .EurostatEnv)
  }
  invisible(0)
}
