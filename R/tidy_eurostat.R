#' @title Transform Data into Row-Column-Value Format
#' @description Transform raw Eurostat data table downloaded from the
#' API into a tidy row-column-value format (RCV).
#' @param dat
#' a data_frame from [get_eurostat_raw()].
#' @inheritParams get_eurostat
#' @return tibble in the melted format with the last column 'values'.
#' @seealso [get_eurostat()], [convert_time_col()], [eurotime2date()]
#' @inherit eurostat-package references
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari and Pyry Kantanen
#'
#' @importFrom stringi stri_extract_first_regex stri_replace_all_regex
#' @importFrom stringi stri_replace_all_fixed
#' @importFrom tidyr separate pivot_longer
#' @importFrom dplyr filter
#' @importFrom data.table setDT melt .SD :=
#' @importFrom stats na.omit
#'
#' @examples
#' \dontrun{
#' # Example of a dataset with multiple time series
#' get_eurostat("AVIA_GOR_ME",
#'   time_format = "date_last",
#'   cache = F
#'   )
#' }
#'
#' @keywords internal utilities database
tidy_eurostat <- function(dat,
                          time_format = "date",
                          select_time = NULL,
                          stringsAsFactors = FALSE,
                          keepFlags = FALSE,
                          use.data.table = FALSE) {

  # To avoid warnings
  TIME_PERIOD <- values <- NULL

  # Separate codes to columns
  cnames <- strsplit(colnames(dat)[1], split = "[\\,]")[[1]]
  cnames1 <- cnames[-length(cnames)] # for columns
  cnames2 <- cnames[length(cnames)] # for colnames
  
  # Separate variables from first column
  # OLD CODE
  dat <- tidyr::separate(dat,
                         col = colnames(dat)[1],
                         into = cnames1,
                         sep = ",",
                         convert = FALSE
  )
  if (!use.data.table) {
    
    # Get variable from column names
    # OLD CODE
    dat <- tidyr::pivot_longer(data = dat,
                               cols = -seq_along(cnames1),
                               names_to = cnames2,
                               values_to = "values")
    
    # to save memory (and backward compatibility)
    # OLD CODE
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
    # OLD CODE
    dat$TIME_PERIOD <- gsub("X", "", dat$TIME_PERIOD, fixed = TRUE)
    dat$values <- as.numeric(gsub("[^0-9.-]+", "", as.character(dat$values)))
    
    # variable columns
    var_cols <- names(dat)[!(names(dat) %in% c("TIME_PERIOD", "values"))]
    
    # reorder to standard order
    # OLD CODE
    dat <- dat[c(var_cols, "TIME_PERIOD", "values")]
    
    # columns from var_cols are converted into factors
    # avoid convert = FALSE since it converts T into TRUE instead of TOTAL
    if (stringsAsFactors) {
      dat[, var_cols] <- lapply(
        dat[, var_cols, drop = FALSE],
        function(x) factor(x, levels = unique(x))
      )
    }
  } else if (use.data.table) {
    # NEW CODE: data.table
    # defining dat as data.table object is necessary to use data.table functions
    # dat <- data.table::as.data.table(dat)
    # Coerce data.frame to data.table by reference
    data.table::setDT(dat)
    
    # Use factors by default to reduce RAM use (?)
    dat[, (cnames1) := lapply(.SD, as.factor), .SDcols = cnames1]
    
    # NEW CODE: data.table
    # Use pipe to reduce RAM use (?)
    dat <- data.table::melt(data = dat,
                            measure.vars = setdiff(names(dat), cnames1),
                            variable.name = cnames2,
                            value.name = "values") %>% 
      na.omit(cols = "values")
    
    # NEW CODE: data.table
    # should be using S3 method for data.table here...
    # Problem has been with "vector memory exhausted (limit reached?)"
    # dat <- na.omit(object = dat, cols = "values")
    
    ## separate flags into separate column
    # Use data.table update := for smaller RAM footprint
    if (keepFlags == TRUE) {
      dat[, `:=`(flags = as.vector(
        stringi::stri_extract_first_regex(values, c("(^0n( [A-Za-z]+)*)|[A-Za-z]+"))
        ))]
    }
    
    # clean time and values
    # NEW CODE: use stringi instead of gsub for faster execution
    # Use data.table update := for smaller RAM footprint
    dat[, TIME_PERIOD := stringi::stri_replace_all_fixed(TIME_PERIOD, "X", "")]
    # dat$TIME_PERIOD <- stringi::stri_replace_all_fixed(dat$TIME_PERIOD, "X", "")
    dat[, values := stringi::stri_replace_all_regex(values, "[^0-9.-]+", "")]
    dat[, values := as.numeric(values)]
    # dat$values <- as.numeric(
    #  stringi::stri_replace_all_regex(as.character(dat$values), "[^0-9.-]+", "")
    # )
    
    # variable columns
    # cnames1 is the same as var_cols so cnames1 is used
    # var_cols <- names(dat)[!(names(dat) %in% c("TIME_PERIOD", "values"))]
    # selected_cols <- c(var_cols, "TIME_PERIOD", "values")
    
    # reorder to standard order
    # NEW CODE: data.table
    # either this way
    # dat <- dat[, ..selected_cols]
    # or this way
    # reorder to standard order
    data.table::setcolorder(dat, c(cnames1, "TIME_PERIOD", "values"))
    
    # Turn factors back into characters if stringsAsFactors = FALSE
    # columns from cnames1 (var_cols) are converted into factors
    if (!stringsAsFactors) {
      dat[, (cnames1) := lapply(.SD, as.character), .SDcols = cnames1]
    }

    dat <- tibble::as_tibble(dat)
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

    if (length(freqs) > 1 && time_format != "raw") {
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
      dat_subset$TIME_PERIOD <- convert_time_col(x = dat_subset$TIME_PERIOD,
                                                 time_format = time_format)
      dat_copy <- rbind(dat_copy, dat_subset)
    }
    dat <- dat_copy
  } else {
    # convert time column to Date
    dat$TIME_PERIOD <- convert_time_col(x = dat$TIME_PERIOD,
                                        time_format = time_format)
  }

  # NEW CODE: data.table
  # This is needed if we still want to return tibbles at the end
  # dat <- tibble::as_tibble(dat)
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
convert_time_col <- function(x, time_format) {
  if (time_format == "raw") {
    y <- x
  } else {
    x <- factor(x)
    if (time_format == "date") {
      y <- eurotime2date(x, last = FALSE)
    } else if (time_format == "date_last") {
      y <- eurotime2date(x, last = TRUE)
    } else if (time_format == "num") {
      y <- eurotime2num(x)
    } else {
      stop(
        "An unknown time_format argument: ", time_format,
        " Allowed are date, date_last, num and raw"
      )
    }
  }
  y
}
