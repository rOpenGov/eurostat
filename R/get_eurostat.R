#' @title Read Eurostat Data
#' 
#' @description 
#' Download data sets from Eurostat \url{https://ec.europa.eu/eurostat}
#'
#' @param id 
#' A code name for the dataset of interest.
#' See [search_eurostat()] or details for how to get code.
#' @param filters 
#' A list of filters to get only a part of the dataset from server. 
#' The default parameter `NULL` (or "none") gets the whole dataset. 
#' Names of list objects are Eurostat variable codes and they can vary from one
#' dataset to another. Values are vectors of observation codes. See more 
#' information on filters and limitations per query via API from 
#' in [get_eurostat_json()] documentation.
#' @param time_format 
#' a string giving a type of the conversion of the time
#' column from the eurostat format. A "date" (default) converts to
#' a [Date()] with a first date of the period.
#' A "date_last" converts to a [Date()] with
#' a last date of the period. A "num" converts to a numeric and "raw"
#' does not do conversion. See [eurotime2date()] and
#' [eurotime2num()].
#' @param type 
#' A type of variables, "code" (default) or "label".
#' @param select_time 
#' a character symbol for a time frequency or NULL,
#' which is used by default as most datasets have just one time
#' frequency. For datasets with multiple time
#' frequencies, select one or more of the desired frequencies with:
#' "Y" (or "A") = annual, "S" = semi-annual / semester, "Q" = quarterly, 
#' "M" = monthly, "W" = weekly. For all frequencies in same data 
#' frame `time_format = "raw"` should be used.
#' @param cache 
#' a logical whether to do caching. Default is `TRUE`.
#' @param update_cache 
#' a logical whether to update cache. Can be set also with
#' options(eurostat_update = TRUE)
#' @param cache_dir 
#' a path to a cache directory. The directory must exist.
#' The `NULL` (default) uses and creates
#' 'eurostat' directory in the temporary directory defined by base R
#' [tempdir()]. The cache directory can also be set with
#' [set_eurostat_cache_dir()].
#' @param compress_file 
#' a logical whether to compress the
#' RDS-file in caching. Default is `TRUE`.
#' @param stringsAsFactors 
#' if `FALSE` (the default) the variables are
#' returned as characters. If `TRUE` the variables are converted to 
#' factors in original Eurostat order.
#' @param keepFlags 
#' a logical whether the flags (e.g. "confidential",
#' "provisional") should be kept in a separate column or if they
#' can be removed. Default is `FALSE`. For flag values see:
#' <https://ec.europa.eu/eurostat/data/database/information>.
#' Also possible non-real zero "0n" is indicated in flags column.
#' Flags are not available for eurostat API, so `keepFlags`
#' can not be used with a `filters`.
#' @inheritDotParams get_eurostat_json
#' @export
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#' 
#' When citing data, please indicate that the data source is Eurostat. If the
#' re-use of data involves modification to the data or text, state this clearly.
#' For more detailed information and exceptions regarding commercial use,
#' see [Eurostat policy on copyright and free re-use of data](https://ec.europa.eu/eurostat/web/main/about/policies/copyright).
#'
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari, Markus Kainu and Pyry Kantanen
#' @details Datasets are downloaded from
#' [the Eurostat SDMX 2.1 API](https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API) 
#' in TSV format  or from The Eurostat Web Services
#' [JSON API](https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query).
#' If only the table `id` is given, the whole table is downloaded from the
#' SDMX API. If any `filters` are given JSON API is used.
#'
#' The bulk download facility is the fastest method to download whole datasets.
#' It is also often the only way as the JSON API has limitation of maximum
#' 50 sub-indicators at time and whole datasets usually exceeds that. Also,
#' it seems that multi frequency datasets can only be retrieved via
#' bulk download facility and the `select_time` is not available for
#' JSON API method.
#'
#' If your connection is thru a proxy, you probably have to set proxy parameters
#' to use JSON API, see [get_eurostat_json()].
#'
#' By default datasets are cached to reduce load on Eurostat services and 
#' because some datasets can be rather large.
#' Cache files are stored in a temporary directory by default or in
#' a named directory (See [set_eurostat_cache_dir()]).
#' The cache can be emptied with [clean_eurostat_cache()].
#'
#' The `id`, a code, for the dataset can be searched with
#' the [search_eurostat()] or from the Eurostat database
#' <https://ec.europa.eu/eurostat/data/database>. The Eurostat
#' database gives codes in the Data Navigation Tree after every dataset
#' in parenthesis.
#' @return 
#' a tibble. 
#' 
#' One column for each dimension in the data, the time column for a time 
#' dimension and the values column for numerical values. Eurostat data does 
#' not include all missing values and a treatment of missing values depend 
#' on source. In bulk download facility missing values are dropped if all 
#' dimensions are missing on particular time. In JSON API missing values are 
#' dropped only if all dimensions are missing on all times. The data from
#' bulk download facility can be completed for example with [tidyr::complete()].
#' @seealso [search_eurostat()], [label_eurostat()]
#' @examplesIf check_access_to_data()
#' \dontrun{
#' k <- get_eurostat("nama_10_lp_ulc")
#' k <- get_eurostat("nama_10_lp_ulc", time_format = "num")
#' k <- get_eurostat("nama_10_lp_ulc", update_cache = TRUE)
#'
#' k <- get_eurostat("nama_10_lp_ulc",
#'   cache_dir = file.path(tempdir(), "r_cache")
#' )
#' options(eurostat_update = TRUE)
#' k <- get_eurostat("nama_10_lp_ulc")
#' options(eurostat_update = FALSE)
#'
#' set_eurostat_cache_dir(file.path(tempdir(), "r_cache2"))
#' k <- get_eurostat("nama_10_lp_ulc")
#' k <- get_eurostat("nama_10_lp_ulc", cache = FALSE)
#' k <- get_eurostat("avia_gonc", select_time = "Y", cache = FALSE)
#'
#' dd <- get_eurostat("nama_10_gdp",
#'   filters = list(
#'     geo = "FI",
#'     na_item = "B1GQ",
#'     unit = "CLV_I10"
#'   )
#' )
#' 
#' # A dataset with multiple time series in one
#' dd2 <- get_eurostat("AVIA_GOR_ME",
#'   select_time = c("A", "M", "Q"),
#'   time_format = "date_last"
#' )
#' 
#' # An example of downloading whole dataset from JSON API
#' dd3 <- get_eurostat("AVIA_GOR_ME", 
#'   filters = list()
#' )
#' 
#' # Filtering a dataset from a local file
#' dd3_filter <- get_eurostat("AVIA_GOR_ME",
#'   filters = list(
#'     tra_meas = "FRM_BRD"
#'   )
#' )
#' 
#' }
#' 
#' @importFrom digest digest
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom dplyr filter
#' @importFrom rlang !! sym
#' 
get_eurostat <- function(id, 
                         time_format = "date", 
                         filters = NULL,
                         type = "code",
                         select_time = NULL,
                         cache = TRUE, 
                         update_cache = FALSE, 
                         cache_dir = NULL,
                         compress_file = TRUE,
                         stringsAsFactors = FALSE,
                         keepFlags = FALSE,
                         ...) {
  
  # Check if you have access to ec.europe.eu.
  # If dataset is cached, access to ec.europe.eu is not needed
  # Therefore this is a warning, not a stop
  if (!check_access_to_data()) {
    warning("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
  }

  # Warning for situations where keepFlags == TRUE and filter arguments are provided
  if (keepFlags && !is.null(filters) || keepFlags && identical(filters, "none")) {
    warning("The keepFlags argument of the get_eurostat function
             can be used only without filters. No Flags returned.")
    keepFlags <- FALSE
  }
  
  # For use later on
  data_superset_exists <- FALSE
  null_value <- NULL
  
  # For better code clarity, use only NULL in code
  if (identical(filters, "none")) {
    filters <- NULL
  }

    if (cache) {
      
      # check option for update
      update_cache <- update_cache | getOption("eurostat_update", FALSE)
      
      # get cache directory
      cache_dir <- eur_helper_cachedir(cache_dir)
      
      cache_list <- file.path(
        cache_dir,
        paste0(
          "cache_list",
          ".json"
        )
      )
      
      # cache file connection
      cache_list_conn <- file(cache_list, "a")
      
      # Sort filters alphabetically ####
      # Subsetting with NULL turns list("") (List of 1) to list() (List of 0)
      # This needs to be looked into, even if it's useful, it's unexpected
      # if structure below prevents subsetting when names(filters) is NULL
      if (!is.null(names(filters))) {
        filters <- filters[sort(names(filters), decreasing = FALSE)]
      }
      
      # Set items inside each individual filter to alphabetical order
      for (i in seq_along(filters)) {
        if (length(filters[i]) > 1) {
          filters[i] <- sort(filters[i])
        }
      }
      
      query <- list(
        list(
          id = id,
          time_format = time_format,
          filters = filters,
          type = type,
          select_time = select_time,
          stringsAsFactors = stringsAsFactors,
          keepFlags = keepFlags,
          source = ifelse(is.null(filters), "bulk", "json")
          )
      )
      
      if (is.null(filters)) {
        query_unfiltered <- list(
          list(
            id = id, 
            time_format = time_format, 
            filters = NULL, 
            type = type,
            select_time = select_time,
            stringsAsFactors = stringsAsFactors,
            keepFlags = keepFlags,
            source = "bulk"
          )
        )
      } else {
        # This is to make it possible to filter local dataset
        # The only way to return a whole dataset from JSON API is to use
        # empty list with filters argument
        query_unfiltered <- list(
          list(
            id = id, 
            time_format = time_format, 
            filters = list(), 
            type = type,
            select_time = select_time,
            stringsAsFactors = stringsAsFactors,
            keepFlags = keepFlags,
            source = "json"
          )
        )
      }
      
      query_hash <- digest::digest(query, algo = "md5")
      query_hash_unfiltered <- digest::digest(query_unfiltered, algo = "md5")
      names(query) <- digest::digest(query, algo = "md5")
      
      # Make a JSON string with predefined order
      # Order is defined by the order of arguments in function documentation
      # Append .json file if the query has not been printed before
      if (!any(grepl(query_hash, readLines(cache_list)))) {
        if (length(readLines(cache_list)) == 0) {
          # close previous connection with mode "a"
          close(cache_list_conn)
          cache_list_conn <- file(cache_list, "w")
          json_query <- jsonlite::toJSON(
            list(
              query
              ),
            pretty = TRUE,
            null = "null")
          
          writeLines(text = json_query,
                     con = cache_list_conn,
                     sep = "\n")
          
        } else if (length(readLines(cache_list)) != 0) {
          # read previously saved queries and save them
          cache_list_history <- jsonlite::fromJSON(cache_list)
          # close previous connection with mode "a"
          close(cache_list_conn)
          # open a new connection with mode "w" that wipes the file
          cache_list_conn <- file(cache_list, "w")
          cache_list_history <- c(cache_list_history, query)

          json_query <- jsonlite::toJSON(
            cache_list_history,
            pretty = TRUE,
            null = "null"
            )

          writeLines(text = paste0(json_query),
                     con = cache_list_conn,
                     sep = "\n")
        }
      }
      
      close(cache_list_conn)
      
     if (!identical(query_hash, query_hash_unfiltered) && any(grepl(query_hash_unfiltered, readLines(cache_list)))) {
        message("Dataset query is not in cache_list.json but the whole dataset is...")
        data_superset_exists <- TRUE
      } else {
        message("Dataset query already saved in cache_list.json...")
      }
      
      # cache filename
      cache_file <- file.path(
        cache_dir,
        paste0(
          query_hash,
          ".rds"
        )
      )
      
      # bulk cache filename
      cache_file_bulk <- file.path(
        cache_dir,
        paste0(
          query_hash_unfiltered,
          ".rds"
        )
      )
    }
  
  
    # Download always files from server if any of the following is TRUE
    # cache = FALSE -> no caching, always downloading
    # update_cache = TRUE -> if we want to update a static cache, redownload
    # cache_file does not exist -> no cache file, no reading from cache
    # 
    # if cache = FALSE or update or new: download else read from cache
    if (!cache || update_cache || (!file.exists(cache_file) && !file.exists(cache_file_bulk))) {
      if (is.list(filters)) {
        
        # JSON API Download
        y <- get_eurostat_json(id, 
                               filters,
                               type = type,
                               stringsAsFactors = stringsAsFactors, ...
        )
        y$time <- convert_time_col(factor(y$time), time_format = time_format)
        
        # Bulk download
      } else if (is.null(filters)) {

          # Download from new dissemination API in TSV file format
          y_raw <- try(get_eurostat_raw(id), silent = TRUE)
          if ("try-error" %in% class(y_raw)) {
            stop(paste("get_eurostat_raw fails with the id", id))
          }
          # If download from new dissemination API is successful
          # Then tidy the dataset with tidy_eurostat function
          y <- tidy_eurostat(y_raw, 
                             time_format, 
                             select_time,
                             stringsAsFactors = stringsAsFactors,
                             keepFlags = keepFlags
          )
        
        if (identical(type, "code")) {
          y <- y
        } else if (identical(type, "label")){
          y <- label_eurostat(y)
        } else if (identical(type, "both")) {
          stop("type = \"both\" can be only used with JSON API. Set filters argument")
        } else {
          stop("Invalid type.")
        }
      }
    } else if (file.exists(cache_file_bulk) && data_superset_exists) {
      # Maybe filtering a dataset that was potentially downloaded from bulk
      # download facilities is not a good idea...? Should the source be indicated in
      # json file?
      
      message(paste("Reading cache file", cache_file_bulk, "and filtering it"))
      y_raw <- readRDS(cache_file_bulk)
      for (i in seq_along(filters)) {
        y_raw <- dplyr::filter(y_raw,
                               !!rlang::sym(names(filters)[i]) == filters[i])
      }
      y <- y_raw
    } else if (file.exists(cache_file)) {
      cf <- path.expand(cache_file)
      message(paste("Reading cache file", cf))
      y <- readRDS(cache_file)
      message(paste("Table ", id, " read from cache file: ", cf))
    }
    
    # if update or new: save
    if (cache && (update_cache || !file.exists(cache_file))) {
      saveRDS(y, file = cache_file, compress = compress_file)
      message("Table ", id, " cached at ", path.expand(cache_file))
    }
    
    y
}

