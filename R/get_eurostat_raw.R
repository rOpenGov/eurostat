#' @title Download Data from Eurostat Dissemination API
#' @description Download data from the eurostat database through the new
#' dissemination API.
#' @inheritParams get_eurostat
#' @return A dataset in tibble format. First column contains comma
#' 	  separated codes of cases. Other columns usually corresponds to
#' 	  years and column names are years with preceding X. Data is in
#' 	  character format as it contains values together with eurostat
#' 	  flags for data.
#' @seealso 
#' [get_eurostat()]
#' 
#' @inheritSection eurostat-package Data source: Eurostat SDMX 2.1 Dissemination API
#' @inheritSection eurostat-package Eurostat: Copyright notice and free re-use of data
#' @inheritSection eurostat-package Citing Eurostat data
#' @inheritSection eurostat-package Disclaimer: Availability of filtering functionalities
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari and Pyry Kantanen
#' @examplesIf check_access_to_data()
#' \donttest{
#' eurostat:::get_eurostat_raw("educ_iste")
#' }
#'
#' @importFrom readr read_tsv cols col_character
#' @importFrom utils download.file
#' @importFrom tibble as_tibble
#' @importFrom curl curl_download
#' @importFrom data.table fread
#'
#' @keywords utilities database
get_eurostat_raw <- function(id, use.data.table = FALSE) {
  base <- getOption("eurostat_url")

  url <- paste0(
    base,
    "api/dissemination/sdmx/2.1/data/",
    id,
    "?format=TSV&compressed=true"
  )

  tfile <- tempfile()
  on.exit(unlink(tfile))

  if (.Platform$OS.type == "windows") {
    curl::curl_download(url = url, destfile = tfile)
  } else {
    # R Packages (2e): Restore state with base::on.exit()
    # timeout = 120 should in most cases be enough for even the biggest datasets
    op <- options(timeout = 120)
    on.exit(options(op), add = TRUE)
    utils::download.file(url, tfile)
  }
  
  if (!use.data.table) {
    # OLD CODE
    dat <- readr::read_tsv(gzfile(tfile),
      na = ":",
      progress = TRUE,
      col_types = readr::cols(.default = readr::col_character())
    )
  } else if (use.data.table) {
    # NEW CODE: data.table
    dat <- data.table::fread(cmd = paste("gzip -dc", tfile),
                             na.strings = ":",
                             header = TRUE,
                             colClasses = "character")
    
    # OLD CODE
    # data.table object does not need to be converted into a tibble at this 
    # point as it will handled by data.table functions in tidy_eurostat.    
    # dat <- tibble::as_tibble(dat)
  }

  # check validity
  if (ncol(dat) < 2 || nrow(dat) < 1) {
    # nocov start
    msg <- paste0(
      ". Some datasets (for instance the comext type) are not ",
      "accessible via the eurostat interface. You can try to ",
      "search the data manually from the comext database at ",
      "http://epp.eurostat.ec.europa.eu/newxtweb/ ",
      "or bulk download facility at ",
      "http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing ",
      "or annual Excel files at ",
      "http://ec.europa.eu/eurostat/web/prodcom/data/excel-files-nace-rev.2"
    )
    # nocov end

    if (grepl("does not exist or is not readable", dat[1])) {
      stop(id, " does not exist or is not readable", msg)
    } else {
      stop(paste("Could not download ", id, msg))
    }
  }

  dat
}
