#' @title Get Data from Eurostat API in JSON
#' @description Retrieve data from Eurostat API in JSON format.
#' @details
#'   Data to retrieve from
#'   [The Eurostat Web Services](https://ec.europa.eu/eurostat/web/main/data/web-services) 
#'   can be specified with filters. Normally, it is
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
#' @param lang A language used for metadata. Default is `EN`, other options are
#'  `FR` and `DE`.
#' @param type A type of variables, "`code`" (default), "`label`" or "`both`". 
#'   The parameter "`both`" will return a data_frame with named vectors, 
#'   labels as values and codes as names.
#' @param stringsAsFactors if `FALSE` (the default) the variables are
#'        returned as characters. If `TRUE` the variables are converted to 
#'        factors in original Eurostat order.
#' @param ... Other arguments passed on to [httr::GET()]. For example
#'   a proxy parameters, see details.
#' @inheritDotParams httr::GET
#' @return A dataset as an object of `data.frame` class.
#' @export
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari Markus Kainu and Pyry Kantanen
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @examples
#' \dontrun{
#' # Generally speaking these queries would be done through get_eurostat
#' tmp <- get_eurostat_json("nama_10_gdp")
#' yy <- get_eurostat_json("nama_10_gdp", filters = list(
#'   geo = c("FI", "SE", "EU28"),
#'   time = c(2015:2023),
#'   lang = "FR",
#'   na_item = "B1GQ",
#'   unit = "CLV_I10"
#' ))
#' 
#' # TIME_PERIOD filter works also with the new JSON API
#' yy2 <- get_eurostat_json("nama_10_gdp", filters = list(
#'    geo = c("FI", "SE", "EU28"),
#'    TIME_PERIOD = c(2015:2023),
#'    lang = "FR",
#'    na_item = "B1GQ",
#'    unit = "CLV_I10"
#' ))
#'   
#' # An example from get_eurostat
#' dd <- get_eurostat("nama_10_gdp",
#'   filters = list(
#'   geo = "FI",
#'   na_item = "B1GQ",
#'   unit = "CLV_I10"
#' ))
#' }
#' @importFrom httr http_error status_code
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @seealso 
#' [httr::GET()]
#' 
#' Eurostat Data Browser online help: API Statistics - data query:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query}
#' 
#' Eurostat Data Browser online help: migrating from JSON web service to API
#' Statistics: 
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+migrating+from+JSON+web+service+to+API+Statistics}
#' @keywords utilities database
get_eurostat_json <- function(id, 
                              filters = NULL,
                              type = "code",
                              lang = "EN",
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
      if (type == "label") {
        y <- unlist(y, use.names = FALSE)
      } else if (type == "code") {
        y <- names(unlist(y))
      } else if (type == "both") {
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



#' @title Internal function to build json url
#' @description Internal function to build json url
#' @importFrom utils hasName
#' @importFrom httr parse_url build_url
#' @noRd
#' @keywords internal utilities
eurostat_json_url <- function(id, filters = NULL, lang = NULL) {

  # prepare filters for query
  filters2 <- as.list(unlist(filters))
  # Give items names without numbers
  names(filters2) <- rep(names(filters), lapply(filters, length))
  
  # The “format” parameter’s only possible value is "JSON".
  if (!hasName(filters2, "format")) {
    filters2$format <- "JSON"
  }
  
  if (!is.null(lang)) {
    # The Language parameter (“lang”) can have only three values: 
    # "EN" (English), "FR" (French), and "DE" (German).
    if (toupper(lang) %in% c("EN", "FR", "DE")) {
      filters2$lang <- toupper(lang)
    } else {
      message("Unsupported language code used. Using the default language: \"EN\"")
      filters2$lang <- "EN"
    }
  } else {
    # In case the parameter isn’t specified, the default value "EN" is taken.
    message("Using the default language: \"EN\"")
    filters2$lang <- "EN"
  }

  host_url <- "https://ec.europa.eu/eurostat/api/dissemination/"
  service <- "statistics/"
  version <- "1.0/"
  response_type <- "data/"
  datasetCode <- id
  
  # Parse host_url and add relevant information in the standard list
  url_list <- httr::parse_url(host_url)
  # Paste "statistics/1.0/data/{id}" at the end of the fixed part of the URL
  url_list$path <- paste0(url_list$path, 
                          service, 
                          version, 
                          response_type, 
                          datasetCode)
  url_list$query <- filters2

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
