#' @title Conversion of Eurostat Time Format to Numeric
#' @description A conversion of a Eurostat time format to numeric.
#' @details
#' Bi-annual (semester), quarterly, monthly and weekly data can be presented as
#' a fraction of the year in beginning of the period. Conversion of daily data
#' is not supported.
#' @param x a charter string with time information in Eurostat time format.
#' @return see [as.numeric()].
#' @author Janne Huovari <janne.huovari@@ptt.fi>, Pyry Kantanen
#' @family helpers
#' @examplesIf check_access_to_data()
#' \donttest{
#' na_q <- get_eurostat("namq_10_pc", time_format = "raw")
#' na_q$TIME_PERIOD <- eurotime2num(x = na_q$TIME_PERIOD)
#'
#' unique(na_q$TIME_PERIOD)
#' }
#'
#' @export
eurotime2num <- function(x) {
  x <- as.factor(x)
  times <- levels(x)

  if (nchar(times[1]) > 8) {
    # Finds the only format that is longer than YYYY-WNN (weeks, 8 chars)
    # Day/date notation: YYYY-MM-DD, 10 chars
    # tcode <- substr(times[1], 8, 8)
    tcode <- "D"
  } else {
    # Possible tcodes: S, Q, 0 or 1 (months), W
    # tcode: type of time data
    tcode <- substr(times[1], 6, 6)
    # if tcode is empty, the data is probably annual
    if (tcode == "0" || tcode == "1") {
      tcode <- "M"
    } else if (tcode == "") {
      tcode <- "A"
    }
  }

  # check input type
  if (!(tcode %in% c("A", "S", "Q", "M", "W"))) {

    # for daily
    if (tcode == "D") {
      warning("Time format is daily data. No numeric conversion was made.")
    } else {
      # nocov start
      warning(
        paste0(
          "Unknown time code, ", tcode, ". No numeric conversion was made.\n",
          "Please fill bug report at ",
          "https://github.com/rOpenGov/eurostat/issues."
        )
      )
      # nocov end
    }

    return(x)
  }

  year <- substr(times, 1, 4)
  subyear <- substr(times, 6, 8)
  # The only characters that can be present are S, Q and W
  subyear <- gsub("[SQW]", "", subyear)

  subyear[subyear == ""] <- 1

  levels(x) <- as.numeric(year) +
    (as.numeric(subyear) - 1) *
    1 / c(A = 1, S = 2, Q = 4, M = 12, W = 53)[tcode]
  y <- as.numeric(as.character(x))
  y
}
