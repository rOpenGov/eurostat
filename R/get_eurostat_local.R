#' @title Read Local SDMX-CSV files
#' @description Read compressed or uncompressed SDMX-CSV files
#' @details
#' This implementation is experimental. It uses only data.table methods to read
#' and wrangle data files.
#' 
#' Download datasets in sdmx-csv format from [https://ec.europa.eu/eurostat/databrowser/bulk?lang=en]
#' 
#' @inheritParams get_eurostat
#' @importFrom data.table fread
#' @export

get_eurostat_local <- function(file,
                         time_format = "date",
                         type = "code",
                         lang = "en",
                         select_time = NULL,
                         stringsAsFactors = FALSE,
                         keepFlags = FALSE,
                         legacy.data.output = FALSE) {
  file_attrs <- parse_filename(file)
  
  if (file_attrs$filetype == "csv.gz"){
    # decompress and read
    # dat <- readr::read_csv(gzfile(file),
    #                        na = "",
    #                        progress = TRUE,
    #                        col_types = readr::cols(.default = readr::col_character())
    # )
    dat <- data.table::fread(file = file,
                             na.strings = "",
                             header = TRUE,
                             colClasses = "character",
                             stringsAsFactors = stringsAsFactors)
  } else if (file_attrs$filetype == "csv") {
    # read
    dat <- data.table::fread(file = file,
                             na.strings = "",
                             header = TRUE,
                             colClasses = "character",
                             stringsAsFactors = stringsAsFactors)
  } else {
    stop("Invalid file")
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
  
  y <- tidy_eurostat_sdmx_csv(
    dat,
    time_format,
    select_time,
    keepFlags = keepFlags
  )
  
  if (identical(type, "code")) {
    # do nothing
    # y <- y
  } else if (identical(type, "label")) {
    agency <- build_agencyID(file_attrs$agency)
    y <- label_eurostat_sdmx(y, lang, id = file_attrs$code, agency = agency)
  } else if (identical(type, "both")) {
    stop(paste("type = \"both\" can be only used with JSON API.",
               "Set filters argument"))
  } else {
    stop("Invalid type.")
  }
  
  if (legacy.data.output) {
    y <- legacy_data_format(y)
  }
  
  y <- tibble::as_tibble(y)
  return(y)
}

parse_filename <- function(file){
  string = file
  # If file path contains folders, or slashes
  if (grepl("/", string)){
    # Find last instance of "/"
    last_slash_index <- max(unlist(gregexpr("/", string)))
    string <- substr(string, start = last_slash_index + 1, stop = nchar(string))
  }
  # Initialize list object to return
  x <- list()
  split_string <- unlist(strsplit(string, "_"))
  # Get agency name
  x$agency <- split_string[1]
  
  # Get ID
  x$code <- paste(split_string[2:(length(split_string)-1)], collapse = "_")
  
  # Get file type and language
  filetype_and_language <- unlist(strsplit(split_string[length(split_string)], "\\."))
  x$lang <- filetype_and_language[1]
  x$filetype <- paste(filetype_and_language[2:length(filetype_and_language)], collapse = ".")
  
  return(x)
  
}