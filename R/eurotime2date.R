#' Date conversion from Eurostat time format
#' 
#' A function to convert Eurostat time values to objects of class "Date" representing calendar dates.
#' 
#' @param x a charter string with time information in Eurostat format
#' @examples \dontrun{
#'    lp <- get_eurostat("namq_aux_lp")
#'    lp$time <- eurotime2date(x = lp$time)
#'    
#'    un <- get_eurostat("une_rt_m")
#'    un$time <- eurotime2date(x = un$time)
#'    }
eurotime2date <- function(x){
  times <- levels(x)
  year <- substr(times, 1, 4)
  subyear <- substr(times, 5, 7)
  tcode <- substr(subyear[1], 1, 1)  # type of time data
  # for yearly data
  if (tcode == ""){          
    period <- "01"
  # for quarterly
  } else if (tcode == "Q"){
    lookup <- c(Q1 = "01", Q2 = "04", Q3 = "07", Q4 = "10")
    period <- lookup[subyear] 
  # for montly
  } else if (tcode == "M"){
    period <- gsub("M", "", subyear)
  # for unkown
  } else {
    warning("Unknown time code, ", tcode, ". No date conversion was made.\nPlease fill bug report at https://github.com/rOpenGov/eurostat/issues.")
    return(x)
  }
  levels(x) <- paste0(year, "-", period, "-01")
  y <- as.Date(x)
  y
}


