#' set_eurostat_TOC
#' 
#' @description For internal use
#' 
#' Arguments:
#'  @param ... Arguments to be passed
#'
#' Returns:
#'  @return Empty element
#'
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek and Leo Lahti \email{louhos@@googlegroups.com}
#' @keywords internal
set_eurostat_TOC <- function(...) {
   if (!exists(".eurostatTOC", envir = .EurostatEnv)) {
   base <- eurostat_url()
   url <- paste(base, "estat-navtree-portlet-prod/", 
       	 "BulkDownloadListing?sort=1&downfile=table_of_contents_en.txt", 
	 sep = "")
   .eurostatTOC <-  read.table(file = url, sep="\t", header=T, quote="\"", 
   		    	        fill = TRUE, comment.char = "", stringsAsFactors = FALSE)
    assign(".eurostatTOC", .eurostatTOC, envir = .EurostatEnv)
  }
  invisible(0)
}


