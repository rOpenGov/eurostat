#' @title Date Conversion from New Eurostat Time Format
#' @description
#' Date conversion from Eurostat time format. A function to
#' convert Eurostat time values to objects of class [Date()]
#' representing calendar dates.
#' @details
#' Available patterns are YYYY (year), YYYY-SN (semester), YYYY-QN (quarter),
#' YYYY-MM (month), YYYY-WNN (week) and YYYY-MM-DD (day).
#' @param x a charter string with time information in Eurostat time format.
#' @param last a logical. If `FALSE` (default) the date  is
#'        the first date of the period (month, quarter or year). If `TRUE`
#'        the date is the last date of the period.
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @return an object of class [Date()].
#' @author Janne Huovari <janne.huovari@@ptt.fi>
#' @family helpers
#' @seealso [lubridate::ymd()]
#' @examplesIf check_access_to_data()
#' \donttest{
#' na_q <- get_eurostat("namq_10_pc", time_format = "raw")
#' na_q$TIME_PERIOD <- eurotime2date(x = na_q$TIME_PERIOD)
#' unique(na_q$TIME_PERIOD)
#' }
#'
#' \dontrun{
#' # Test for weekly data
#' get_eurostat(
#'   id = "lfsi_abs_w",
#'   select_time = c("W"),
#'   time_format = "date"
#'   )
#' }
#'
#' @importFrom lubridate ymd
#' @importFrom ISOweek ISOweek2date
#' @importFrom dplyr inner_join
#'
#' @export
eurotime2date <- function(x, last = FALSE) {
  if (!is.factor(x)) x <- factor(x)
  unique_times <- levels(x)
  year <- substr(unique_times, 1, 4)
  # 5th character is always "-", if there is one
  #from "YYYY-QN" the following line would extract "QN", from "YYYY-WNN" "WNN"
  subyear <- substr(unique_times, 6, 8)
  # the first character tells the type of the date
  tcode <- substr(subyear[1], 1, 1)
  if (tcode != "_" && nchar(unique_times[1]) > 8) {
    days <- substr(unique_times, 8, 10) #extract -DD from YYYY-MM-DD
    tcode <- substr(days[1], 1, 1) # tcode for daily data is "-"
  }

  if (tcode == "") tcode <- "Y"

  day <- "01" # default for day

  if (tcode == "Y") {
    # for yearly data
    period <- "01"
  } else if (tcode == "S") {
    # for bi-annual ("semester") data
    lookup <- c(S1 = "01", S2 = "07")
    period <- lookup[subyear]
  } else if (tcode == "Q") {
    # quarterly data
    lookup <- c(Q1 = "01", Q2 = "04", Q3 = "07", Q4 = "10")
    period <- lookup[subyear]
  } else if (tcode == "0" || tcode == "1") {
    # monthly data
    period <- gsub("M", "", subyear)
  } else if (tcode == "W") {
    # weekly data
    # We need period to be of format "WNN", e.g. W01 for 1st week of the year
    period <- subyear
  } else if (tcode == "-") {
    # daily data
    period <- gsub("M", "", subyear)
    day <- gsub("D", "", days)
  } else {
    # nocov start
    warning(
      "Unknown time code, ", tcode, ". No date conversion was made.\n
            Please fill bug report at ",
      "https://github.com/rOpenGov/eurostat/issues."
    )
    return(x)
    # nocov end
  }

  # The date as the last date of the period
  if (tcode == "W") {
    # in some datasets week number can be larger than 53, e.g. 99
    # ISOweek2date does not support such week numbers -> they are coerced
    # to W01-1 or W01-7
    if (any(substr(period, 2, 3) > 53)) {
      warning(paste("Some TIME_PERIOD fields have invalid week values (> 53).",
                    "Coercing invalid fields to format YYYY-W01",
                    "(the first week of the year). If you wish to handle",
                    "weeks with invalid values manually please use",
                    "parameter time_format = 'raw' in get_eurostat."))
      invalid_w_numbers <- which(substr(period, 2, 3) > 53)
      period[invalid_w_numbers] <- "W01"
    }

    # Range is 1-7 here, not 01-07. 1 = Monday, 2 = Tuesday etc.
    day <- ifelse(last == TRUE, 7, 1)
    levels(x) <- paste0(year, "-", period, "-", day)
    unique_dates <- unique(x)
    column_names <- c("orig", "date")
    d <- data.frame(
      matrix(
        nrow = length(unique_dates),
        ncol = length(column_names)
      )
    )
    colnames(d) <- column_names
    d$orig <- unique_dates
    d$date <- ISOweek::ISOweek2date(unique_dates)

    # NEW CODE: data.table
    # d <- as.data.table(d)
    # x <- as.data.table(x)

    x <- as.data.frame(x)
    colnames(x) <- "orig"

    # NEW CODE: data.table
    # y <- x[d, on = "orig"]$date

    y <- dplyr::inner_join(x, d, by = "orig")
    y <- y$date
    return(y)
  }

  levels(x) <- paste0(year, "-", period, "-", day)

  # For times other than weeks
  if (last == TRUE && tcode != "W") {
    shift <- c(
      "Y" = 367, "S" = 186, "Q" = 96, "0" = 32, "1" = 32, "D" = 0
    )[tcode]

    levels(x) <- lubridate::ymd(
      cut(lubridate::ymd(levels(x)) + shift, "month")
    ) - 1
  }
  y <- lubridate::ymd(x)
  y
}
