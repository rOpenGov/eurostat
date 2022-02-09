#' @title Date Conversion from Eurostat Time Format
#' @description Date conversion from Eurostat time format. A function to
#' convert Eurostat time values to objects of class [Date()]
#' representing calendar dates.
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
#' na_q$time <- eurotime2date(x = na_q$time)
#' unique(na_q$time)
#' }
#'
#' @importFrom lubridate ymd
#'
#' @export
eurotime2date <- function(x, last = FALSE) {
  if (!is.factor(x)) x <- factor(x)
  times <- levels(x)
  year <- substr(times, 1, 4)
  subyear <- substr(times, 5, 7)
  tcode <- substr(subyear[1], 1, 1) # type of time data
  if (tcode != "_" && nchar(times[1]) > 7) {
    days <- substr(times, 8, 10)
    tcode <- substr(days[1], 1, 1) # type of time data if daily
  }

  if (tcode == "") tcode <- "Y"

  day <- "01" # default for day

  # for yearly data
  if (tcode == "Y") {
    period <- "01"
    # for bi-annual
  } else if (tcode == "S") {
    lookup <- c(S1 = "01", S2 = "07")
    period <- lookup[subyear]
    # for quarterly
  } else if (tcode == "Q") {
    lookup <- c(Q1 = "01", Q2 = "04", Q3 = "07", Q4 = "10")
    period <- lookup[subyear]
    # for montly
  } else if (tcode == "M") {
    period <- gsub("M", "", subyear)
    # for daily
  } else if (tcode == "D") {
    period <- gsub("M", "", subyear)
    day <- gsub("D", "", days)
    # for year intervals
  } else if (tcode == "_") {
    warning("Time format is a year interval. No date conversion was made.")
    return(x)
    # for unkown
  } else {
    warning(
      "Unknown time code, ", tcode, ". No date conversion was made.\n
            Please fill bug report at ",
      "https://github.com/rOpenGov/eurostat/issues."
    )
    return(x)
  }

  levels(x) <- paste0(year, "-", period, "-", day)

  # The date as the last date of the period
  if (last == TRUE) {
    shift <- c("Y" = 367, "S" = 186, "Q" = 96, "M" = 32, "D" = 0)[tcode]
    levels(x) <- lubridate::ymd(
      cut(lubridate::ymd(levels(x)) + shift, "month")
    ) - 1
  }
  y <- lubridate::ymd(x)
  y
}
