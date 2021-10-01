#' @title Get Data from Eurostat API in JSON
#' @description Retrieve data from Eurostat API in JSON format.
#' @details
#'   Data to retrieve from
#'   [The
#'   Eurostat Web Services](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services) can be specified with filters. Normally, it is
#'   better to use JSON query through [get_eurostat()], than to use
#'   [get_eurostat_json()] directly.
#'
#'   Queries are limited to 50 sub-indicators at a time. A time can be
#'   filtered with fixed "time" filter or with "sinceTimePeriod" and
#'   "lastTimePeriod" filters. A `sinceTimePeriod = 2000` returns
#'   observations from 2000 to a last available. A `lastTimePeriod = 10`
#'   returns a 10 last observations.
#'
#'   To use a proxy to connect, a [httr::use_proxy()] can be
#'   passed to [httr::GET()]. For example
#'   `get_eurostat_json(id, filters,
#'   config = httr::use_proxy(url, port, username, password))`.
#'
#' @param id A code name for the dataset of interested. See the table of
#'   contents of eurostat datasets for more details.
#' @param filters A named list of filters. Names of list objects are Eurostat
#'   variable codes and values are vectors of observation codes. If `NULL`
#'   (default) the whole dataset is returned. See details for more on filters
#'   and limitations per query.
#' @param lang A language used for metadata (en/fr/de).
#' @param type A type of variables, "code" (default), "label" or "both". The
#'   "both" will return a data_frame with named vectors, labels as values and
#'   codes as names.
#' @param stringsAsFactors if `TRUE` (the default) variables are converted
#'   to factors in original Eurostat order. If `FALSE` they are returned as
#'   a character.
#' @param ... Other arguments passed on to [httr::GET()]. For example
#'   a proxy parameters, see details.
#'   .
#' @inheritDotParams httr::GET
#' @return A dataset as a data_frame.
#' @export
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari and Markus Kainu
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @examples
#' # nama_gdp_c has been discontinued since 2/2018 and this example has ceased working.
#' \dontrun{
#' tmp <- get_eurostat_json("cdh_e_fos")
#' yy <- get_eurostat_json(id = "nama_gdp_c", filters = list(
#'   geo = c("EU28", "FI"),
#'   unit = "EUR_HAB",
#'   indic_na = "B1GM"
#' ))
#' }
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @seealso [httr::GET()]
#' @keywords utilities database
get_eurostat_json <- function(id, filters = NULL,
                              type = c("code", "label", "both"),
                              lang = c("en", "fr", "de"),
                              stringsAsFactors = FALSE,
                              ...) {

  ## Special products that must be built to matrix
  ## User gets message to use iotables::iotables_download() and halt this operation.
  user_want_stop <- special_id_values(id)
  if (user_want_stop) {
    return(NULL)
  }

  # Check if you have access to ec.europe.eu.
  if (!check_access_to_data()) {
    message("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
  } else {

    # get response
    # url <- try(eurostat_json_url(id = id, filters = filters, lang = lang))
    # if (class(url) == "try-error") { stop(paste("The requested data set cannot be found with the following specifications to get_eurostat_json function: ", "id: ", id, "/ filters: ", filters, "/ lang: ", lang))  }
    url <- eurostat_json_url(id = id, filters = filters, lang = lang)

    # resp <- try(httr::GET(url, ...))
    # if (class(resp) == "try-error") { stop(paste("The requested url cannot be found within the get_eurostat_json function:", url))  }
    resp <- httr::RETRY("GET", url, terminate_on = c(404))
    if (httr::http_error(resp)) {
      stop(paste("The requested url cannot be found within the get_eurostat_json function:", url))
    }

    status <- httr::status_code(resp)

    # check status and get json

    msg <- ". Some datasets are not accessible via the eurostat
          interface. You can try to search the data manually from the comext
  	  database at http://epp.eurostat.ec.europa.eu/newxtweb/ or bulk
  	  download facility at
  	  http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing
  	  or annual Excel files
  	  http://ec.europa.eu/eurostat/web/prodcom/data/excel-files-nace-rev.2"

    if (status == 200) {
      jdat <- jsonlite::fromJSON(url)
    } else if (status == 400) {
      stop(
        "Failure to get data. Probably invalid dataset id. Status code: ",
        status, msg
      )
    } else if (status == 500) {
      stop("Failure to get data. Probably filters did not return any data
         or data exceeded query size limitation. Status code: ", status, msg)
    } else if (status == 416) {
      stop(
        "Too many categories have been requested. Maximum is 50.",
        status, msg
      )
    } else {
      stop("Failure to get data. Status code: ", status, msg)
    }

    # get json data
    # dims <- jdat[[1]]$dimension # Was called like this in API v1.1
    dims <- jdat$dimension # Switched to this with API v2.1
    # ids <- dims$id # v1.1
    ids <- jdat$id # v2.1

    dims_list <- lapply(dims[rev(ids)], function(x) {
      y <- x$category$label
      if (type[1] == "label") {
        y <- unlist(y, use.names = FALSE)
      } else if (type[1] == "code") {
        y <- names(unlist(y))
      } else if (type[1] == "both") {
        y <- unlist(y)
      } else {
        stop("Invalid type ", type)
      }
    })

    variables <- expand.grid(dims_list,
      KEEP.OUT.ATTRS = FALSE,
      stringsAsFactors = stringsAsFactors
    )

    # dat <- data.frame(variables[rev(names(variables))], values = jdat[[1]]$value) # v1.1
    dat <- as.data.frame(variables[rev(names(variables))])
    vals <- unlist(jdat$value, use.names = FALSE)
    dat$values <- rep(NA, nrow(dat))
    inds <- 1 + as.numeric(names(jdat$value)) # 0-indexed
    if (!length(vals) == length(inds)) {
      stop("Complex indexing not implemented.")
    }
    dat$values[inds] <- vals



    tibble::as_tibble(dat)
  }
}



# Internal function to build json url
eurostat_json_url <- function(id, filters, lang) {

  # prepare filters for query
  filters2 <- as.list(unlist(filters))
  names(filters2) <- rep(names(filters), lapply(filters, length))

  # prepare url
  url_list <- list(
    scheme = "http",
    hostname = "ec.europa.eu",
    path = file.path(
      "eurostat/wdds/rest/data/v2.1/json",
      lang[1], id
    ),
    query = filters2
  )

  # Data pulled from API v1.1 has different structure than v.2.1
  # names(jdat2)
  # [1] "version"   "label"     "href"      "source"    "updated"   "status"
  # [7] "extension" "class"     "value"     "dimension" "id"        "size"
  # names(jdat1[[1]])
  # [1] "wsVersion"      "code"           "language"       "title"
  # [5] "subTitle"       "description"    "lastUpdateDate" "status"
  # [9] "value"          "dimension"

  class(url_list) <- "url"
  url <- httr::build_url(url_list)
  url
}
# Internal function to give warning if symmetric input-output tables need to download into strict matirx formats.
special_id_values <- function(id) {
  siot_id_codes <- c(
    "naio_10_cp1700", "naio_10_pyp1700",
    "naio_10_cp1750", "naio_10_pyp1750",
    "naio_10_cp15", "naio_10_cp16",
    "naio_10_cp1610", "naio_10_pyp1610",
    "naio_10_cp1620", "naio_10_pyp1620",
    "naio_10_cp1630", "naio_10_pyp1630"
  )
  if (id %in% siot_id_codes) {
    message(
      "The requested product id is a special input-output matrix.",
      "\nTo keep the matrix structure for further use, download it with iotables::iotables_download().\nThe iotables package is an extension for such cases to the eurostat package."
    )
    answer <- readline(prompt = "Do you want to stop downloading now? [y/n] ")
    if (tolower(answer) == "y") TRUE else FALSE
  } else {
    # By default evaluates to FALSE and no interruption happens
    FALSE
  }
}

# Internal function to give warning if sub-national geo codes need validation
is_regional_nuts_present <- function(dat, geo) {
  potentional_regional_codes <- unique(dat$geo)[nchar(unique(dat$geo)) > 2]

  potentional_regional_codes <- potentional_regional_codes[!substr(potentional_regional_codes, 1, 2) %in% c("EU", "EA")]

  if (length(potentional_regional_codes) > 0) {
    types_found <- paste(sort(unique(validate_geo_code(potentional_regional_codes, nuts_year = 2021))), collapse = ", ")
    message(
      "The following sub-national geographical codes present in the dataset:\n", types_found,
      "\nRegional and metropolitian area boundaries, codes and names are changing frequently.",
      "\nSee ?validate_geo_code, ?validate_nuts_regions and ?recode_nuts or the",
      "\n'Mapping Regional Data, Mapping Metadata Problems' vignette for a tutorial."
    )
  }
}
