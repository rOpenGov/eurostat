#' @title Download Data from Eurostat Dissemination API
#' @description Download data from the eurostat database through the new
#' dissemination API.
#' @param id A code name for the dataset of interested. See the table of
#'  contents of eurostat datasets for more details.
#' @return A dataset in tibble format. First column contains comma
#' 	  separated codes of cases. Other columns usually corresponds to
#' 	  years and column names are years with preceding X. Data is in
#' 	  character format as it contains values together with eurostat
#' 	  flags for data.
#' @seealso [get_eurostat()].
#' @details Data is downloaded from
#'  <https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing>
#'  and transformed into tabular format.
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
#'
#' @keywords utilities database
get_eurostat_raw2 <- function(id) {
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
    utils::download.file(url, tfile)
  }

  dat <- readr::read_tsv(gzfile(tfile),
    na = ":",
    col_types = readr::cols(.default = readr::col_character())
  )


  # check validity
  if (ncol(dat) < 2 | nrow(dat) < 1) {
    msg <- ". Some datasets (for instance the comext type) are not accessible via the eurostat interface. You can try to search the data manually from the comext database at http://epp.eurostat.ec.europa.eu/newxtweb/ or bulk download facility at http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing or annual Excel files http://ec.europa.eu/eurostat/web/prodcom/data/excel-files-nace-rev.2"

    if (grepl("does not exist or is not readable", dat[1])) {
      stop(id, " does not exist or is not readable", msg)
    } else {
      stop(paste("Could not download ", id, msg))
    }
  }

  dat
}
