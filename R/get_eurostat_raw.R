#' @title Download Data from Eurostat Database
#' @description Download data from the eurostat database.
#' @param id A code name for the dataset of interested. See the table of
#'  contents of eurostat datasets for more details.
#' @return A dataset in tibble format. First column contains comma 
#' 	  separated codes of cases. Other columns usually corresponds to 
#'	  years and column names are years with preceding X. Data is in 
#'	  character format as it contains values together with eurostat 
#'	  flags for data.
#' @seealso \code{\link{get_eurostat}}.
#' @details Data is downloaded from
#'  \url{http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing} and transformed into tabular format.
#' @references see citation("eurostat")
#' @author Przemyslaw Biecek, Leo Lahti and Janne Huovari \email{ropengov-forum@@googlegroups.com}
#' @examples \dontrun{
#' 	       tmp <- eurostat:::get_eurostat_raw("educ_iste")
#' 	       head(tmp)
#'	     }
#' @keywords utilities database
get_eurostat_raw <- function(id) {

  base <- eurostat_url()		   

  url <- paste0(base, 
    "estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2F",
    id, ".tsv.gz")

  tfile <- tempfile()
  on.exit(unlink(tfile))
  
  # download and read file
  utils::download.file(url, tfile)
  
  dat <- readr::read_tsv(gzfile(tfile), na = ":",  
                         col_types = readr::cols(.default = readr::col_character()))
  
  # check validity
  
  if (ncol(dat) < 2 | nrow(dat) < 1) {
    msg <- ". Some datasets are not accessible via the eurostat interface. You can try to search the data manually from the comext database at http://epp.eurostat.ec.europa.eu/newxtweb/ or bulk download facility at http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing or annual Excel files http://ec.europa.eu/eurostat/web/prodcom/data/excel-files-nace-rev.2"  
    if (grepl("does not exist or is not readable", dat[1])) {
    
      stop(id, " does not exist or is not readable", msg)
    } else { 
      stop(paste("Could not download ", id, msg))
    }
  }
    
  dat
}
