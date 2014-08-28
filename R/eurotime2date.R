
#' @param x a charter string with time information in Eurostat format

eurotime2date <- function(x){
  x <- as.character(x)
  year <- substr(x, 1, 4)
  tcode <- substr(x[1], 5, 5)
  
  suby <- substr(x, 6, 7)
  period <- c("1" = "01", "2" = "04", "3" = "07", "4" = "10")[suby]
  y <- paste0(year, "-", period, "-01")
  y <- as.Date(y)
  y
}


