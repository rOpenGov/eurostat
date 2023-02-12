#' @title Transform Data from the New Dissemination API into Row-Column-Value Format
#' @description Transform raw Eurostat data table downloaded from the new 
#' dissemination API into the row-column-value format (RCV).
#' @param dat 
#' a data_frame from [get_eurostat_raw()].
#' @param time_format 
#' a string giving a type of the conversion of the time column from the 
#' eurostat format. A "date" (default) converts to a [Date()]
#' with a first date of the period. A "date_last" converts to a [Date()] with
#' a last date of the period. A "num" converts to a numeric and "raw"
#' does not do conversion. See [eurotime2date()] and [eurotime2num()].
#' @param select_time 
#' a single character symbol for a time frequency, a vector
#' containing multiple time frequencies, or `NULL` (default).
#' Available options are "A" (annual), "Q" (quarterly), "S"
#' (semester, 1st or 2nd half of the year), "M" (monthly) and "D" (daily).
#' When downloading data from the New Dissemination API, it is now possible
#' to select multiple time frequencies and return them in the same data.frame
#' object.
#' @param stringsAsFactors 
#' if `TRUE` (the default) variables are
#' converted to factors in original Eurostat order. If `FALSE`
#' they are returned as strings.
#' @param keepFlags a logical whether the flags (e.g. "confidential",
#' "provisional") should be kept in a separate column or if they
#' can be removed. Default is `FALSE`
#' @return tibble in the molten format with the last column 'values'.
#' @seealso [get_eurostat()], [convert_time_col2()], [eurotime2date2()]
#' @references See citation("eurostat").
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari and Pyry Kantanen
#'
#' @importFrom stringi stri_extract_first_regex
#' @importFrom tidyr separate pivot_longer
#' @importFrom dplyr filter
#' 
#' @examples 
#' \dontrun{
#' # Example of a dataset with multiple time series
#' get_eurostat("AVIA_GOR_ME", time_format = "date_last", cache = F, bulk_new_style = TRUE)
#' }
#'
#' @keywords internal utilities database
tidy_eurostat2 <- function(dat, 
                           time_format = "date", 
                           select_time = NULL,
                           stringsAsFactors = FALSE,
                           keepFlags = FALSE) {

  # To avoid warnings
  TIME_PERIOD <- values <- NULL

  # Separate codes to columns
  cnames <- strsplit(colnames(dat)[1], split = "[\\,]")[[1]]
  cnames1 <- cnames[-length(cnames)] # for columns
  cnames2 <- cnames[length(cnames)] # for colnames

  # Separe variables from first column
  dat <- tidyr::separate(dat,
    col = colnames(dat)[1],
    into = cnames1,
    sep = ",", 
    convert = FALSE
  )

  # Get variable from column names
  dat <- tidyr::pivot_longer(data = dat,
                              cols = -seq_along(cnames1),
                              names_to = cnames2,
                              values_to = "values")

  # to save memory (and backward compatibility)
  dat <- dplyr::filter(dat, !is.na(values))

  ## separate flags into separate column
  if (keepFlags == TRUE) {
    dat$flags <- as.vector(
      stringi::stri_extract_first_regex(
        dat$values,
        c("(^0n( [A-Za-z]+)*)|[A-Za-z]+")
      )
    )
  }

  # clean time and values
  dat$TIME_PERIOD <- gsub("X", "", dat$TIME_PERIOD)
  dat$values <- as.numeric(gsub("[^0-9.-]+", "", as.character(dat$values)))
  
  # variable columns
  var_cols <- names(dat)[!(names(dat) %in% c("TIME_PERIOD", "values"))]

  # reorder to standard order
  dat <- dat[c(var_cols, "TIME_PERIOD", "values")]

  # columns from var_cols are converted into factors
  # avoid convert = FALSE since it converts T into TRUE instead of TOTAL
  if (stringsAsFactors) {
    dat[, var_cols] <- lapply(
      dat[, var_cols, drop = FALSE],
      function(x) factor(x, levels = unique(x))
    )
  }

  # For multiple time frequency
  freqs <- unique(dat$freq)

  if (!is.null(select_time)) {
    if (length(select_time) > 1) {
      message(
        "Selected multiple time frequencies with select_time parameter: ",
        shQuote(select_time)
      )
    }

    # Filter dataset according to select_time filter
    # This only works when a single frequency is chosen
    if (identical(select_time, "Y")) {
      # Annual with old style notation, "Y" for annual
      dat <- subset(dat, dat$freq == "A")
    } else if (identical(select_time, "A")) {
      # Annual with new notation, "A" for annual
      dat <- subset(dat, dat$freq == "A")
    } else { 
      # Others, subset the data with whatever choices
      dat <- subset(dat, dat$freq %in% select_time)
    }
    # Test if filtered dataset actually contains any data
    if (nrow(dat) == 0) {
      stop(
        "No data selected with select_time:", dQuote(select_time), "\n",
        "Available frequencies: ", shQuote(freqs)
      )
    }
  } else {
    
    if (length(freqs) > 1 & time_format != "raw") {
      message(
        "Data includes several time frequencies. Select a single frequency \n",
        "with select_time or use time_format = \"raw\" to return all data \n",
        "without any filtering. Available frequencies: ", shQuote(freqs), "\n",
        "Returning the dataset with multiple frequencies."
      )
    }
  }

  if (length(select_time) > 1) {
    dat_copy <- data.frame()
    for (i in seq_along(select_time)) {
      dat_subset <- subset(dat, dat$freq == select_time[i])
      dat_subset$TIME_PERIOD <- convert_time_col2(x = dat_subset$TIME_PERIOD,
                                                   time_format = time_format)
      dat_copy <- rbind(dat_copy, dat_subset)
    }
    dat <- dat_copy
  } else {
    # convert time column to Date
    dat$TIME_PERIOD <- convert_time_col2(x = dat$TIME_PERIOD,
                                          time_format = time_format)
  }

  dat
}


#' @title 
#' Time Column Conversions for data from new dissemination API
#' @description 
#' Internal function to convert time column.
#' @param x 
#' A time column (vector) from a downloaded dataset
#' @param time_format 
#' one of the following: `date`, `date_last`, or `num`. 
#' See [tidy_eurostat()] for more information.
#' @keywords internal
convert_time_col2 <- function(x, time_format) {
  if (time_format == "raw") {
    y <- x
  } else {
    x <- factor(x)
    if (time_format == "date") {
      y <- eurotime2date2(x, last = FALSE)
    } else if (time_format == "date_last") {
      y <- eurotime2date2(x, last = TRUE)
    } else if (time_format == "num") {
      y <- eurotime2num2(x)
    } else {
      stop(
        "An unknown time_format argument: ", time_format,
        " Allowed are date, date_last, num and raw"
      )
    }
  }
  y
}
