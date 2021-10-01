#' @title Transform Data into Row-Column-Value Format
#' @description Transform raw Eurostat data table into the row-column-value
#' format (RCV).
#' @param dat a data_frame from [get_eurostat_raw()].
#' @param time_format a string giving a type of the conversion of the
#'                    time column from the eurostat format.
#'                    A "date" (default) converts to a [Date()]
#'                    with a first date of the period. A "date_last"
#'                    converts to a [Date()] with
#'         a last date of the period. A "num" converts to a numeric and "raw"
#'         does not do conversion. See [eurotime2date()] and
#'         [eurotime2num()].
#' @param select_time a character symbol for a time frequency or NULL
#'  (default).
#' @param stringsAsFactors if `TRUE` (the default) variables are
#'         converted to factors in original Eurostat order. If `FALSE`
#'         they are returned as strings.
#' @param keepFlags a logical whether the flags (e.g. "confidential",
#'     "provisional") should be kept in a separate column or if they
#'     can be removed. Default is `FALSE`
#' @return tibble in the molten format with the last column 'values'.
#' @seealso [get_eurostat()]
#' @references See citation("eurostat").
#' @author Przemyslaw Biecek, Leo Lahti and Janne Huovari
#'
#' @importFrom stringi stri_extract_first_regex
#' @import tidyr
#' @import dplyr
#'
#' @keywords internal utilities database
tidy_eurostat <- function(dat, time_format = "date", select_time = NULL,
                          stringsAsFactors = FALSE,
                          keepFlags = FALSE) {

  # To avoid warnings
  time <- values <- NULL

  # Separate codes to columns
  cnames <- strsplit(colnames(dat)[1], split = "[\\,]")[[1]]
  cnames1 <- cnames[-length(cnames)] # for columns
  cnames2 <- cnames[length(cnames)] # for colnames

  # Separe variables from first column
  dat <- tidyr::separate(dat,
    col = colnames(dat)[1],
    into = cnames1,
    sep = ",", convert = FALSE
  )

  # Get variable from column names

  cnames2_quo <- as.name(cnames2)
  dat <- tidyr::gather(dat, !!cnames2_quo, values,
    -seq_along(cnames1),
    convert = FALSE
  )

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
  dat$time <- gsub("X", "", dat$time)
  dat$values <- as.numeric(gsub("[^0-9.-]+", "", as.character(dat$values)))

  # variable columns
  var_cols <- names(dat)[!(names(dat) %in% c("time", "values"))]

  # reorder to standard order
  dat <- dat[c(var_cols, "time", "values")]

  # columns from var_cols are converted into factors
  # avoid convert = FALSE since it converts T into TRUE instead of TOTAL
  if (stringsAsFactors) {
    dat[, var_cols] <- lapply(
      dat[, var_cols, drop = FALSE],
      function(x) factor(x, levels = unique(x))
    )
  }

  # For multiple time frequency
  freqs <- available_freq(dat$time)

  if (!is.null(select_time)) {
    if (length(select_time) > 1) {
      stop(
        "Only one frequency should be selected in select_time. Selected: ",
        shQuote(select_time)
      )
    }

    # Annual
    if (select_time == "Y") {
      dat <- subset(dat, nchar(time) == 4)
      # Others
    } else {
      dat <- subset(dat, grepl(select_time, time))
    }
    # Test if data
    if (nrow(dat) == 0) {
      stop(
        "No data selected with select_time:", dQuote(select_time), "\n",
        "Available frequencies: ", shQuote(freqs)
      )
    }
  } else {
    if (length(freqs) > 1 & time_format != "raw") {
      stop(
        "Data includes several time frequencies. Select frequency with
         select_time or use time_format = \"raw\".
         Available frequencies: ", shQuote(freqs)
      )
    }
  }

  # convert time column
  dat$time <- convert_time_col(dat$time,
    time_format = time_format
  )



  dat
}


#' @title Time Column Conversions
#' @description Internal function to convert time column.
#' @param x A time column (vector)
#' @param time_format see [tidy_eurostat()]
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
    } else if (time_format == "raw") {

    } else {
      stop(
        "An unknown time_format argument: ", time_format,
        " Allowed are date, date_last, num and raw"
      )
    }
  }
  y
}
