#' @title Get Eurostat Data
#'
#' @description
#' Download data sets from Eurostat \url{https://ec.europa.eu/eurostat}
#'
#' @param id
#' A unique identifier / code for the dataset of interest. If code is not
#' known [search_eurostat()] function can be used to search Eurostat table
#' of contents.
#' @param filters
#' A named list of filters. Names of list objects are Eurostat
#' variable codes and values are vectors of observation codes. If `NULL`
#' (default) the whole dataset is returned. See details for more information 
#' on filters and limitations per query.
#' @param time_format
#' a string giving a type of the conversion of the time column from the
#' eurostat format. The default argument "`date`" converts to a [Date()] class
#' with the date being the first day of the period. A "`date_last`" argument 
#' converts the dataset date to a [Date()] class object with the difference 
#' that the exact date is the last date of the period. Period can be year,
#' semester (half year), quarter, month, or week (See [eurotime2date()] for 
#' more information).
#' Argument "`num`" converts the date into a numeric (integer) meaning that
#' the first day of the year 2000 is close to 2000.01 and the last day of the
#' year is close to 2000.99 (see [eurotime2num()] for more information). 
#' Using the argument "`raw`" preserves the dates as they were in the original
#' Eurostat data.
#' @param type
#' A type of variables, "`code`" (default), "`label`" or "`both`".
#' The parameter "`both`" will return a data_frame with named vectors,
#' labels as values and codes as names.
#' @param select_time
#' a character symbol for a time frequency or `NULL`,
#' which is used by default as most datasets have just one time
#' frequency. For datasets with multiple time
#' frequencies, select one or more of the desired frequencies with:
#' "Y" (or "A") = annual, "S" = semi-annual / semester, "Q" = quarterly,
#' "M" = monthly, "W" = weekly. For all frequencies in same data
#' frame `time_format = "raw"` should be used.
#' @param lang 2-letter language code, default is "`en`" (English), other 
#' options are "`fr`" (French) and "`de`" (German). Used for labeling datasets.
#' @param cache
#' a logical whether to do caching. Default is `TRUE`.
#' @param update_cache
#' a logical whether to update cache. Can be set also with
#' `options(eurostat_update = TRUE)`
#' @param cache_dir
#' a path to a cache directory. `NULL` (default) uses and creates
#' 'eurostat' directory in the temporary directory defined by base R
#' [tempdir()] function. The user can set the cache directory to an existing
#' directory by using this argument. The cache directory can also be set with
#' [set_eurostat_cache_dir()] function.
#' @param compress_file
#' a logical whether to compress the RDS-file in caching. Default is `TRUE`.
#' @param stringsAsFactors
#' if `TRUE` (the default) variables are converted to factors in the original 
#' Eurostat order. If `FALSE` they are returned as strings.
#' @param keepFlags
#' a logical whether the flags (e.g. "confidential",
#' "provisional") should be kept in a separate column or if they
#' can be removed. Default is `FALSE`. For flag values see:
#' <https://ec.europa.eu/eurostat/data/database/information>.
#' Also possible non-real zero "0n" is indicated in flags column.
#' Flags are not available for eurostat API, so `keepFlags`
#' can not be used with a `filters`.
#' @param use.data.table Use faster data.table functions? Default is FALSE. 
#' On Windows requires that RTools is installed.
#' @inheritDotParams get_eurostat_json
#' 
#' @inherit eurostat-package references
#'
#' @inheritSection eurostat-package Eurostat: Copyright notice and free re-use of data
#' @inheritSection eurostat-package Filtering datasets
#' @inheritSection eurostat-package Citing Eurostat data
#' @inheritSection eurostat-package Disclaimer: Availability of filtering functionalities
#' @inheritSection eurostat-package Strategies for handling large datasets more efficiently
#'
#' @author
#' Przemyslaw Biecek, Leo Lahti, Janne Huovari, Markus Kainu and Pyry Kantanen
#' 
#' @details
#' Datasets are downloaded from
#' [the Eurostat SDMX 2.1 API](https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API)
#' in TSV format or from The Eurostat
#' [API Statistics JSON API](https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query).
#' If only the table `id` is given, the whole table is downloaded from the
#' SDMX API. If any `filters` are given JSON API is used instead.
#'
#' The bulk download facility is the fastest method to download whole datasets.
#' It is also often the only way as the JSON API has limitation of maximum
#' 50 sub-indicators at time and whole datasets usually exceeds that. Also,
#' it seems that multi frequency datasets can only be retrieved via
#' bulk download facility and the `select_time` is not available for
#' JSON API method.
#'
#' If your connection is through a proxy, you may have to set proxy parameters
#' to use JSON API, see [get_eurostat_json()].
#'
#' By default datasets are cached to reduce load on Eurostat services and
#' because some datasets can be quite large.
#' Cache files are stored in a temporary directory by default or in
#' a named directory (See [set_eurostat_cache_dir()]).
#' The cache can be emptied with [clean_eurostat_cache()].
#'
#' The `id`, a code, for the dataset can be searched with
#' the [search_eurostat()] or from the Eurostat database
#' <https://ec.europa.eu/eurostat/data/database>. The Eurostat
#' database gives codes in the Data Navigation Tree after every dataset
#' in parenthesis.
#' 
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
#' 
#' @seealso
#' [search_eurostat()], [label_eurostat()]
#' 
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
#' @export
get_eurostat <- function(id,
                         time_format = "date",
                         filters = NULL,
                         type = "code",
                         select_time = NULL,
                         lang = "en",
                         cache = TRUE,
                         update_cache = FALSE,
                         cache_dir = NULL,
                         compress_file = TRUE,
                         stringsAsFactors = FALSE,
                         keepFlags = FALSE,
                         use.data.table = FALSE,
                         ...) {

  # Check if you have access to ec.europe.eu.
  # If dataset is cached, access to ec.europe.eu is not needed
  # Therefore this is a warning, not a stop
  if (!check_access_to_data()) {
    # nocov start
    warning("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
    # nocov end
  }
  
  # For better code clarity, use only NULL in code
  if (is.character(filters) && identical(tolower(filters), "none")) {
    filters <- NULL
  } else if (is.character(filters) && !identical(tolower(filters), "null")) {
    message("Non-standard filters argument. Using argument 'filters = NULL'")
    filters <- NULL
  }

  # Inform user with message if keepFlags == TRUE cannot be delivered
  if (keepFlags && !is.null(filters)) {
    message("The keepFlags argument of the get_eurostat function
             can be used only without filters. No Flags returned.")
    keepFlags <- FALSE
  }
  
  # Sanity check
  type <- tolower(type)
  time_format <- tolower(time_format)
  lang <- check_lang(lang)

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

    # Sort items inside each individual filter to alphabetical order
    for (i in seq_along(filters)) {
      if (length(filters[i]) > 1) {
        filters[i] <- sort(filters[i])
      }
    }

    # Turn query into lists with predefined order
    # Order is defined by the order of arguments in function documentation
    query <- list(
      list(
        id = id,
        time_format = time_format,
        filters = filters,
        type = type,
        select_time = select_time,
        stringsAsFactors = stringsAsFactors,
        keepFlags = keepFlags,
        source = ifelse(is.null(filters), "bulk", "json"),
        download_date = Sys.Date()
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
          source = "bulk",
          download_date = Sys.Date()
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
          source = "json",
          download_date = Sys.Date()
        )
      )
    }

    query_hash <- digest::digest(query, algo = "md5")
    query_hash_unfiltered <- digest::digest(query_unfiltered, algo = "md5")
    names(query) <- digest::digest(query, algo = "md5")
    cache_list_current <- readLines(cache_list)

    if (any(grepl(query_hash, cache_list_current))) {
      # Check if the same query has already been made
      message("Dataset query already saved in cache_list.json...")
    } else if (!any(grepl(query_hash, cache_list_current))) {
      # If query was not made, append cache_list with new json query
      if (length(cache_list_current) == 0) {
        # close previous connection with mode "a"
        close(cache_list_conn)
        cache_list_conn <- file(cache_list, "w")

        json_query <- jsonlite::toJSON(
          query,
          pretty = TRUE,
          null = "null"
        )

        writeLines(text = json_query,
                   con = cache_list_conn,
                   sep = "\n")

      } else if (length(cache_list_current) != 0) {
        # read previously saved queries and save them
        cache_list_history <- jsonlite::fromJSON(cache_list)
        # close previous connection with mode "a"
        close(cache_list_conn)
        # open a new connection with mode "w" that wipes the file
        cache_list_conn <- file(cache_list, "w")
        cache_list_history_and_query <- c(cache_list_history, query)

        json_query <- jsonlite::toJSON(
          cache_list_history_and_query,
          pretty = TRUE,
          null = "null"
        )

        writeLines(
          text = paste0(json_query),
          con = cache_list_conn,
          sep = "\n"
        )
      }
    }

    close(cache_list_conn)

    # If query_hash and query_hash_unfiltered are not identical
    # it means that it makes sense to see if a superset of the data exists
    data_superset_exists <- FALSE

    # Re-read cache_list file if there were any changes
    cache_list_current <- readLines(cache_list)

    if (!identical(query_hash, query_hash_unfiltered) &&
          any(grepl(query_hash_unfiltered, cache_list_current))) {
      message("Dataset query not in cache_list.json but the whole dataset is")
      data_superset_exists <- TRUE
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
  # cache = FALSE
  #   -> no caching, always downloading
  # update_cache = TRUE
  #   -> want to update a cache -> redownload
  # suitable cache_file AND cache_file_bulk do not exist
  #   -> no cache files -> no reading from cache -> download
  if (!cache || update_cache ||
        (!file.exists(cache_file) && !file.exists(cache_file_bulk))) {
    if (is.list(filters)) {
      # If filters value is some type of a list
      #   -> Download from Eurostat Web Service (replaces "JSON API")

      y <- get_eurostat_json(
        id,
        filters,
        type,
        lang,
        stringsAsFactors,
        ...
      )
      y$time <- convert_time_col(factor(y$time), time_format = time_format)

    } else if (is.null(filters)) {
      # If filters value is NULL
      #   -> Download from SDMX 2.1 REST API (replaces old "Bulk download")

      y <- try(get_eurostat_raw(id, use.data.table = use.data.table), silent = TRUE)
      if ("try-error" %in% class(y)) {
        stop(paste("get_eurostat_raw fails with the id", id))
      }

      # If download from SDMX 2.1 REST API is successful
      #   -> tidy the dataset with tidy_eurostat function

      y <- tidy_eurostat(
        y,
        time_format,
        select_time,
        stringsAsFactors = stringsAsFactors,
        keepFlags = keepFlags, use.data.table = use.data.table
      )

      if (identical(type, "code")) {
        # do nothing
        # y <- y
      } else if (identical(type, "label")) {
        y <- label_eurostat(y, lang)
      } else if (identical(type, "both")) {
        stop(paste("type = \"both\" can be only used with JSON API.",
                   "Set filters argument"))
      } else {
        stop("Invalid type.")
      }
    }
  } else if (file.exists(cache_file_bulk) && data_superset_exists) {
    # Somewhat redundant as data_superset_exists checks cache_list.json
    # which lists files downloaded and saved to cache but maybe in some
    # situations the cached file could go missing? Not very likely though

    message(paste("Reading cache file", cache_file_bulk, "and filtering it"))
    y <- readRDS(cache_file_bulk)
    for (i in seq_along(filters)) {
      y <- dplyr::filter(y,
                             !!rlang::sym(names(filters)[i]) == filters[i])
    }
    # y <- y_raw
  } else if (file.exists(cache_file)) {
    cf <- path.expand(cache_file)
    message(paste("Reading cache file", cf))
    y <- readRDS(cache_file)
    message(paste("Table ", id, " read from cache file: ", cf))
  }

  # if update_cache = TRUE or cache file does not yet exist
  #   -> save cache file to cache directory
  if (cache && (update_cache || !file.exists(cache_file))) {
    saveRDS(y, file = cache_file, compress = compress_file)
    message("Table ", id, " cached at ", path.expand(cache_file))
  }

  y
}

#' @title Get all datasets in a folder
#' @description
#' Loops over all files in a Eurostat database folder, downloads the data and
#' assigns the datasets to environment.
#' @details
#' The datasets are assigned into .EurostatEnv by default, using dataset codes
#' as object names. The datasets are downloaded from SDMX API as TSV files,
#' meaning that they are returned without filtering. No filters can be
#' provided using this function.
#' 
#' Please do not attempt to download too many datasets or the whole database
#' at once. The number of datasets that can be downloaded at once is hardcoded 
#' to 20. The function also asks the user for confirmation if the number of 
#' datasets in a folder is more than 10. This is by design to discourage
#' straining Eurostat API.
#' @param code Folder code from Eurostat Table of Contents.
#' @param env Name of the environment where downloaded datasets are assigned.
#' Default is .EurostatEnv. If NULL, datasets are returned as a list object.
#' 
#' @inheritSection eurostat-package Data source: Eurostat Table of Contents
#' @inheritSection eurostat-package Data source: Eurostat SDMX 2.1 Dissemination API
#' 
#' @author Pyry Kantanen
#' 
#' @inherit set_eurostat_toc seealso
#' 
#' @importFrom stringr str_glue
#' @importFrom utils menu
#' 
#' 
#' @export
get_eurostat_folder <- function(code, env = .EurostatEnv) {
  
  # Limit after which the function prompts the user whether they really want
  # to proceed
  soft_limit <- 10
  # Limit that cannot be crossed with this function
  hard_limit <- 20
  
  toc <- get_eurostat_toc()
  if (toc[["type"]][which(toc[["code"]] == code)] != "folder") {
    warning("The code you provided is not a folder.")
    return(invisible())
  }
  children <- toc_list_children(code)
  # Filter out potential subfolders
  children <- children[which(children$type %in% c("dataset", "table")), ]
  
  if (nrow(children) == 0) {
    warning("The folder code you provided did not have any items.")
    return(invisible())
  }

  if (nrow(children) > hard_limit) {
    warning(stringr::str_glue(
      "The number of datasets in folder ({nrow(children)}) is too large. ",
      "Please use some other method for retrieving datasets."
    ))
    return(invisible())
  }

  if (nrow(children) > soft_limit) {
    title_msg <- stringr::str_glue(
      "The number of items in the folder is more than {soft_limit}. ",
      "Do you wish to proceed?")
    switch(menu(c("Yes", "No"), title = title_msg) + 1,
           cat("Nothing done\n"),
           message("Proceeding to download datasets in folder..."),
           return(invisible()))
  }
  
  if (!is.null(env)) {
    for (i in seq_len(nrow(children))) {
      dataset <- get_eurostat(children$code[i], cache = TRUE)
      assign(children$code[i], dataset, envir = env)
      message(
        stringr::str_glue(
          "Dataset {i} / {nrow(children)} assigned to environment\n\n")
      )
    }
    return(invisible())
  } else {
    list_of_datasets <- list()
    for (i in seq_len(nrow(children))) {
      dataset <- get_eurostat(children$code[i], cache = TRUE)
      list_of_datasets[[i]] <- dataset
      # names(list_of_datasets[i]) <- children$code[i]
      message(
        stringr::str_glue(
          "Dataset {i} / {nrow(children)} assigned to a list\n\n")
      )
    }
    names(list_of_datasets) <- children[["code"]]
    return(list_of_datasets)
  }
}

#' @title Get Eurostat data interactive
#' @description
#' A simple interactive helper function to go through the steps of downloading 
#' and/or finding suitable eurostat datasets. 
#' 
#' @details
#' This function is intended to enable easy exploration of different eurostat
#' package functionalities and functions. In order to not drown the end user
#' in endless menus this function does not allow for setting 
#' all possible [get_eurostat()] function arguments. It is possible to set
#' `time_format`, `type`, `lang`, `stringsAsFactors`, `keepFlags`, and
#' `use.data.table` in the interactive menus. 
#' 
#' In some datasets setting these parameters may result in a 
#' "Error in label_eurostat" error, for example: 
#' "labels for XXXXXX includes duplicated labels in the Eurostat dictionary". 
#' In these cases, and with other more complex queries, please
#' use [get_eurostat()] function directly.
#' 
#' @param code 
#' A unique identifier / code for the dataset of interest. If code is not
#' known [search_eurostat()] function can be used to search Eurostat table
#' of contents.
#' 
#' @seealso [get_eurostat()]
#' @importFrom stringr str_glue
#' @importFrom utils capture.output
#' @export
get_eurostat_interactive <- function(code = NULL) {
  # Interactive function, not feasible to test
  # nocov start
  lang_selection <- switch(
    menu(c("English", "French", "German"), title = "Select language") + 1,
    return(invisible()),
    "en",
    "fr",
    "de"
  )
  
  if (is.null(code)) {
    
    search_term <- readline(prompt = "Enter search term for data: ")
    results <- search_eurostat(pattern = search_term, lang = lang_selection)
    code_and_title <- paste0("[", results$code, "] ", results$title)
    if (nrow(results) > 0) {
       choice <- menu(choices = code_and_title, title = "Which dataset would you like to download?")
       if (choice == 0) {
         # message("Nothing done\n")
         return(invisible())
       }
    } else {
      stop(paste("No data found with given search term:", search_term))
    }
    code <- results$code[choice]
  }
  
  download_selection <- switch(
    menu(choices = c("Yes", "No"), 
         title = "Download the dataset?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )
  # Set manual_selection to FALSE here to make it possible to print code
  # for downloading dataset later
  manual_selection <- FALSE
  
  if (download_selection) {
    manual_selection <- switch(
      menu(choices = c("Default", "Manually selected"), 
           title = "Would you like to use default download arguments or set them manually?") + 1,
      return(invisible()),
      FALSE,
      TRUE
    )
    
    if (manual_selection) {
      time_format_selection <- switch(
        menu(choices = c("Convert to date, first day of the period (2000-04-01) (default)",
                         "Convert to date, last day of the period (2000-06-30)",
                         "Convert to numeric (2000.25)",
                         "Use raw data (2000-Q2)")) + 1,
        "date",
        "date",
        "date_last",
        "num",
        "raw"
      )
      
      type_selection <- switch(
        menu(choices = c("Return categorical variables as short codes (default)",
                         "Return categorical variables in labeled (long) format"),
             title = "Note: The option 'both' is supported only when using the JSON API.") + 1,
        "code",
        "code",
        "label"
      )
      
      stringsAsFactors_selection <- switch(
        menu(choices = c("Return categorical data as characters (default)",
                         "Convert categorical data into factors"),
             title = "Converting text data into factors may help reduce time used in data processing, reduce RAM usage and cache file size") + 1,
        FALSE,
        FALSE,
        TRUE
      )
      
      keepFlags_selection <- switch(
        menu(choices = c("Do not return flags, just remove them (default)",
                         "Return flags in separate column")) + 1,
        FALSE,
        FALSE,
        TRUE
      )
      
      use.data.table_selection <- switch(
        menu(choices = c("Do not use data.table functions (default",
                         "Use data.table functions"),
             title = "Using data.table functions may help reduce time used in data processing and reduce RAM usage. It is advisable especially when dealing with large datasets.") + 1,
        FALSE,
        FALSE,
        TRUE
      )
      eurostat_data <- tryCatch({
        get_eurostat(id = code,
                     time_format = time_format_selection,
                     type = type_selection,
                     lang = lang_selection,
                     stringsAsFactors = stringsAsFactors_selection,
                     keepFlags = keepFlags_selection,
                     use.data.table = use.data.table_selection)
      }, error=function(error_message) {
        message("\nEncountered the following error message while attempting to modify the downloaded data:\n")
        message(error_message)
        message("\nUsing default options for downloading data...\n")
        # Use scoping assignment here to influence code print below
        time_format_selection <<- "date"
        type_selection <<- "code"
        lang_selection <<- lang_selection
        stringsAsFactors_selection <<- FALSE
        keepFlags_selection <<- FALSE
        use.data.table_selection <<- FALSE
        get_eurostat(id = code,
                     time_format = time_format_selection,
                     type = type_selection,
                     lang = lang_selection,
                     stringsAsFactors = stringsAsFactors_selection,
                     keepFlags = keepFlags_selection,
                     use.data.table = use.data.table_selection)
      })
    } else if (!manual_selection) {
      eurostat_data <- get_eurostat(id = code)
    }
  }
  
  tempfile_for_sinking <- tempfile()
  
  # eurostat_data <- get_eurostat(id = code)
  print_citation <- switch(
    menu(choices = c("Yes", "No"), 
         title = "Print dataset citation?") + 1,
    return(invisible()), 
    TRUE, 
    FALSE
  )
  
  if (print_citation) {
    citation <- get_bibentry(code, lang = lang_selection)
    capture.output(cat("##### DATASET CITATION:\n\n"), file = tempfile_for_sinking, append = TRUE)
    capture.output(print(citation), file = tempfile_for_sinking, append = TRUE)
    capture.output(cat("\n"), file = tempfile_for_sinking, append = TRUE)
  }
  
  print_code <- switch(
    menu(choices = c("Yes", "No"), 
         title = "Print code for downloading dataset?") + 1,
    return(invisible()), 
    TRUE,
    FALSE
  )
  
  if (print_code == TRUE && manual_selection == TRUE) {
    capture.output(cat("##### DOWNLOAD PARAMETERS:\n\n"))
    capture.output(print(stringr::str_glue(paste0("get_eurostat(id = '{code}', time_format = '{time_format_selection}', ",
                                                  "type = '{type_selection}', lang = '{lang_selection}', ",
                                                  "stringsAsFactors = {stringsAsFactors_selection}, ",
                                                  "keepFlags = {keepFlags_selection}, ",
                                                  "use.data.table = {use.data.table_selection})"))), file = tempfile_for_sinking, append = TRUE)
    capture.output(cat("\n"))
  } else if (print_code == TRUE && manual_selection == FALSE) {
    capture.output(cat("##### DOWNLOAD PARAMETERS:\n\n"), file = tempfile_for_sinking, append = TRUE)
    capture.output(print(stringr::str_glue("get_eurostat(id = '{code}')")), file = tempfile_for_sinking, append = TRUE)
    capture.output(cat("\n"), file = tempfile_for_sinking, append = TRUE)
  }
  
  if (exists("eurostat_data")) {
    print_code <- switch(
      menu(choices = c("Yes", "No"), 
           title = "Print dataset fixity checksum?") + 1,
      return(invisible()),
      TRUE,
      FALSE
    )
    
    if (print_code) {
      capture.output(cat("##### FIXITY CHECKSUM:\n\n"), file = tempfile_for_sinking, append = TRUE)
      capture.output(print(stringr::str_glue("Fixity checksum (md5) for dataset {code}: {eurostat:::fixity_checksum(eurostat_data, algorithm = 'md5')}")), file = tempfile_for_sinking, append = TRUE)
      capture.output(cat("\n"), file = tempfile_for_sinking, append = TRUE)
    }
  }
  
  if (exists("eurostat_data")) {
    cat(readLines(tempfile_for_sinking), sep = "\n")
    return(eurostat_data)
  } else {
    cat(readLines(tempfile_for_sinking), sep = "\n")
    return(invisible())
  }
  # nocov end
}
