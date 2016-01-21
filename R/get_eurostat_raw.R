#' @title Download data from the eurostat database
#' @description Download data from the eurostat database. Downloads datasets
#' from the eurostat database and transforms into tabular format.
#' @param id A code name for the dataset of interested. See the table of
#'  contents of eurostat datasets for more details.
#' @return A dataset in data.frame format. First column contains comma 
#' 	  separated codes of cases. Other columns usually corresponds to 
#'	  years and column names are years with preceding X. Data is in 
#'	  character format as it contains values together with eurostat 
#'	  flags for data.
#' @seealso \code{\link{get_eurostat}}.
#' @details Data is downloaded from
#'  \url{http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing}
#' @references see citation("eurostat")
#' @importFrom utils download.file
#' @importFrom utils read.table
#' @author Przemyslaw Biecek, Leo Lahti and Janne Huovari \email{ropengov-forum@@googlegroups.com}
#' @examples \dontrun{
#' 	       tmp <- eurostat:::get_eurostat_raw("educ_iste")
#' 	       head(tmp)
#'	     }
#' @keywords utilities database
get_eurostat_raw <- function(id) {

  base <- eurostat_url()		   

  url <- paste(base, 
    "estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2F",
    id, ".tsv.gz", sep = "")

  tfile <- tempfile()
  on.exit(unlink(tfile))
  
  # download and read file
  utils::download.file(url, tfile)
  dat <- utils::read.table(gzfile(tfile), sep = "\t", na.strings = ": ", 
                    header = TRUE, stringsAsFactors = FALSE)
  # check validity
  if (ncol(dat) < 2 | nrow(dat) < 1) {
    if (grepl("does not exist or is not readable", dat[1])) {
      stop(id, " does not exist or is not readable")
    } else { 
      stop(paste("Could not download ", id))
    }
  }
    
  dat
}
