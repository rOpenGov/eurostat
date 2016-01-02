#' @title A conversion of a Eurostat time format to numeric
#' @description A conversion of a Eurostat time format to numeric. A function
#' to convert Eurostat time values to a numeric. Bi-annual, quarterly and
#' monthly data is presented as fraction of the year in beginning of the
#' period.  
#' @param x a charter string with time information in Eurostat time format.
#' @export
#' @return see \code{\link{as.numeric}}.
#' @author Janne Huovari \email{ropengov-forum@@googlegroups.com} 
#' 	                 \url{http://github.com/ropengov/eurostat}
#' @examples \dontrun{
#'    lp <- get_eurostat("namq_aux_lp", time_format = "raw")
#'    lp$time <- eurotime2num(x = lp$time)
#'    
#'    un <- get_eurostat("une_rt_m", time_format = "raw")
#'    un$time <- eurotime2num(x = un$time)
#'    
#'    lpa <- get_eurostat("nama_aux_lp", time_format = "raw")
#'    lpa$time <- eurotime2num(x = lpa$time)
#'    
#'    eur_d <- get_eurostat("ert_bil_eur_d", time_format = "raw")
#'    eur_d$time <- eurotime2num(x = eur_d$time)
#'    }
eurotime2num <- function(x){

  x <- as.factor(x)
  times <- levels(x)

  if (nchar(times[1]) > 7){
    tcode <- substr(times[1], 8, 8) # daily
  } else {
    tcode <- substr(times[1], 5, 5)  # type of time data
    if (tcode == "") tcode <- "Y"    
  }

  
  # check input type  
  if (!(tcode %in% c("Y", "S", "Q", "M", "_"))) {

    # for daily
    if (tcode == "D"){
      warning("Time format is daily data. No numeric conversion was made.")
    # for year intervals
    } else if (tcode == "_") {
      warning("Time format is a year interval. No numeric conversion was made.")
    # for unkown
    } else {
      warning("Unknown time code, ", tcode, ". No numeric conversion was made.\n
              Please fill bug report at https://github.com/rOpenGov/eurostat/issues.")
    }
    
    return(x)   
  }
  
  year <- substr(times, 1, 4)
  subyear <- substr(times, 6, 7)
  subyear[subyear == ""] <- 1

  
  levels(x) <- as.numeric(year) + 
    (as.numeric(subyear) - 1) * 1/c(Y = 1, S = 2, Q = 4, M = 12)[tcode]
  y <- as.numeric(as.character(x))
  y
}
