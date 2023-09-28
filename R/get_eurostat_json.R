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
#'   returns a 10 last observations. See "Filtering datasets" section below
#'   for more detailed information about filters.
#'
#'   To use a proxy to connect, proxy arguments can be
#'   passed to [httr2::req_perform()] via [httr2::req_proxy()] - see latter
#'   function documentation for parameter names that can be passed with `...`. 
#'   A non-functional example:
#'   `get_eurostat_json(id, filters, proxy = TRUE, url = "127.0.0.1", port = 80)`.
#'
#'   When retrieving data from Eurostat JSON API the user may encounter errors.
#'   For end user convenience, we have provided a ready-made internal dataset
#'   `sdmx_http_errors` that contains descriptive labels and descriptions about
#'   the possible interpretation or cause of each error. These messages are
#'   returned if the API returns a status indicating a HTTP error
#'   (400 or greater).
#'
#'   The Eurostat implementation seems to be based on SDMX 2.1, which is the
#'   reason we've used SDMX Standards guidelines as a supplementary source
#'   that we have included in the dataset. What this means in practice is that
#'   the dataset contains error codes and their mappings that are not mentioned
#'   in the Eurostat website. We hope you never encounter them.
#'
#' @param proxy Use proxy, TRUE or FALSE (default).
#' @inheritParams get_eurostat
#' @inheritDotParams httr2::req_proxy
#' @inherit get_eurostat references
#' 
#' @return A dataset as an object of `data.frame` class.
#' @author
#' Przemyslaw Biecek, Leo Lahti, Janne Huovari Markus Kainu and Pyry Kantanen

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
#' @importFrom httr2 request req_user_agent req_retry req_perform req_proxy 
#' @importFrom httr2 resp_body_json resp_content_type resp_is_error req_error
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom stringr str_glue
#' @importFrom httr2 %>% 
#' 
#' @inheritSection eurostat-package Data source: Eurostat API Statistics (JSON API)
#' @inheritSection eurostat-package Filtering datasets
#' @inheritSection eurostat-package Eurostat: Copyright notice and free re-use of data
#' @inheritSection eurostat-package Citing Eurostat data
#' @inheritSection eurostat-package Disclaimer: Availability of filtering functionalities
#' 
#' @seealso
#' [httr2::req_proxy()]
#'
#' @keywords utilities database
#' @export
get_eurostat_json <- function(id,
                              filters = NULL,
                              type = "code",
                              lang = "en",
                              stringsAsFactors = FALSE,
                              proxy = FALSE,
                              ...) {

  ## Special products that must be built to matrix
  ## User is prompted to halt and use iotables::iotables_download()
  user_want_stop <- special_id_values(id)
  if (user_want_stop) {
    return(NULL)
  }

  # Check if you have access to ec.europe.eu.
  if (!check_access_to_data()) {
    # nocov start
    message("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
    # nocov end
  }

  # construct url
  url <- eurostat_json_url(id = id, filters = filters, lang = lang)
  # set user agent with version
  # ua <- httr::user_agent(paste0("eurostat_",
  # packageDescription("eurostat", fields = "Version")))
  # ua <- httr::user_agent("https://github.com/rOpenGov/eurostat")
  
  if (proxy == TRUE) {
    # Check if "..." has arguments needed for proxy
    args <- list(...)
    dot_url <- dot_port <- dot_username <- dot_password <- NULL
    if("url" %in% names(args)) dot_url <- args$url
    if("port" %in% names(args)) dot_port <- as.numeric(args$port)
    if("username" %in% names(args)) dot_username <- args$username
    if("password" %in% names(args)) dot_port <- args$password
    if("auth" %in% names(args)) {
      dot_auth <- args$auth
    } else {
      dot_auth <- "basic"
    }
  
    resp <- httr2::request(url) %>% 
      httr2::req_user_agent(string = "https://github.com/rOpenGov/eurostat") %>% 
      httr2::req_proxy(url = dot_url,
                       port = dot_port,
                       username = dot_username,
                       password = dot_password,
                       auth = dot_auth) %>% 
      httr2::req_retry(max_tries = 3, max_seconds = 60) %>% 
      httr2::req_error(is_error = function(resp) FALSE) %>%
      httr2::req_perform()
  }
  resp <- httr2::request(url) %>% 
    httr2::req_user_agent(string = "https://github.com/rOpenGov/eurostat") %>% 
    httr2::req_retry(max_tries = 3, max_seconds = 60) %>% 
    httr2::req_error(is_error = function(resp) FALSE) %>% 
    httr2::req_perform()

  # RETRY GET 3 times
  # resp <- httr::RETRY(verb = "GET",
  #                     url = url,
  #                     times = 3,
  #                     terminate_on = c(404),
  #                     ua)

  # Source: httr vignette "Best practices for API packages" [httr_vignette]
  if (httr2::resp_content_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  # parse JSON data into R object (as per [httr_vignette])
  # assume that content encoding is utf8
  result <- httr2::resp_body_json(
      resp = resp,
      simplifyVector = TRUE)

  if (httr2::resp_is_error(resp)) {

    # These objects are only needed if there is an error
    json_data_frame <- as.data.frame(result)
    status <- json_data_frame$error.status
    id <- json_data_frame$error.id
    label <- json_data_frame$error.label

    # sdmx_http_errors is stored in R/sysdata.rda
    # same data in extdata/sdmx_to_http_error_mapping.csv file
    faultstring <- sdmx_http_errors$sdmx.faultstring[which(sdmx_http_errors$sdmx.faultcode == id & sdmx_http_errors$http.status_code == status)]
    status_code_label <- sdmx_http_errors$http.status_code.label[grep(status, sdmx_http_errors$http.status_code)][1]

    if (status == 416) {
      stop(stringr::str_glue("Too many categories have been requested. Maximum is 50.\n",
                             "HTTP status: {status} ({status_code_label})\n",
                             "  Error id: {id} ({faultstring})\n",
                             "  Error label from API: {label}")
      )
    } else {
      stop(stringr::str_glue("\n",
                             "HTTP status: {status} ({status_code_label})\n",
                             "  Error id: {id} ({faultstring})\n",
                             "  Error label from API: {label}")
      )
    }
  }

  if (resp$status_code == 200 && length(result$value) == 0) {

    # nocov start
    msg <- paste(" Please also note that some datasets are not accessible via",
                 "the eurostat API interface. You can try to search the data",
                 "manually from the comext database at",
                 "https://ec.europa.eu/eurostat/comext/newxtweb/ or explore",
                 "data at https://ec.europa.eu/eurostat/web/main/data/database")
    # nocov end

    stop(paste("HTTP status: 200, but the dataset didn't have any values.\n",
               " Editing the query parameters may resolve the issue.\n",
               msg)
    )
  }

  #status <- httr::status_code(resp)

  # check status and get json
  jdat <- result
  # no need to download same data twice
  # jdat <- jsonlite::fromJSON(url, simplifyVector = TRUE)

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


#' @title Internal function to build json url
#' @description Internal function to build json url
#' @importFrom utils hasName
#' @importFrom httr2 url_parse url_build
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

  filters2$lang <- check_lang(lang)

  host_url <- "https://ec.europa.eu/eurostat/api/dissemination/"
  service <- "statistics/"
  version <- "1.0/"
  response_type <- "data/"
  datasetCode <- id

  # Parse host_url and add relevant information in the standard list
  url_list <- httr2::url_parse(host_url)
  # Paste "statistics/1.0/data/{id}" at the end of the fixed part of the URL
  url_list$path <- paste0(url_list$path,
                          service,
                          version,
                          response_type,
                          datasetCode)
  url_list$query <- filters2

  url <- httr2::url_build(url_list)
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
