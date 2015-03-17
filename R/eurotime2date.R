#' Date conversion from Eurostat time format
#' 
#' A function to convert Eurostat time values to objects of class \code{\link{Date}} representing calendar dates.
#' 
#' @param x a charter string with time information in Eurostat time format.
#' @param last a logical. If \code{FALsE} (default) the date  is 
#'        the first date of the period (month, quarter or year). If \code{TRUE} the date is the last date of
#'        the period.
#' @export
#' @return an object of class \code{\link{Date}}.
#' @author Janne Huovari \email{ropengov-forum@@googlegroups.com} \url{http://github.com/ropengov/eurostat}
#' @examples \dontrun{
#'    lp <- get_eurostat("namq_aux_lp", time_format = "raw")
#'    lp$time <- eurotime2date(x = lp$time)
#'    
#'    un <- get_eurostat("une_rt_m", time_format = "raw")
#'    un$time <- eurotime2date(x = un$time)
#'    
#'    lpa <- get_eurostat("nama_aux_lp", time_format = "raw")
#'    lpa$time <- eurotime2date(x = lpa$time)
#'    }
eurotime2date <- function(x, last = FALSE){
  times <- levels(x)
  year <- substr(times, 1, 4)
  subyear <- substr(times, 5, 7)
  tcode <- substr(subyear[1], 1, 1)  # type of time data
  if (tcode == "") tcode <- "Y"
  
  # for yearly data
  if (tcode == "Y"){          
    period <- "01"
    # for bi-annual
  } else if (tcode == "S"){
    lookup <- c(S1 = "01", S2 = "07")
    period <- lookup[subyear] 
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
  
  # The date as the last date of the period
  if (last == TRUE) {
    shift <- c("Y" = 367, "S" = 186, "Q" = 96, "M" = 32)[tcode]  
    levels(x) <- as.Date(cut(as.Date(levels(x)) + shift, "month")) - 1
  }
  y <- as.Date(x)
  y
}
