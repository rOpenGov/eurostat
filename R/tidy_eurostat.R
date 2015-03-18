#' Transform raw Eurostat data table into the row-column-value format (RCV).
#' 
#' @param dat a data.frame from \code{\link{get_eurostat_raw}}.
#' @param time_format a string giving a type of the conversion of the 
#'                    time column from the eurostat format. 
#' 		      A "date" (default) convers to a \code{\link{Date}} 
#'		      with a first date of the period. A "date_last" 
#'		      convers to a \code{\link{Date}} with 
#'         a last date of the period. A "num" convers to a numeric and "raw" 
#'         does not do conversion. See \code{\link{eurotime2date}} and 
#'         \code{\link{eurotime2num}}.
#'
#'  @return data.frame in the molten format with the last column 'values'. 
#'  	    
#' @import tidyr
#' @seealso \code{\link{get_eurostat}}
#' @references See citation("eurostat"). 
#' @author Przemyslaw Biecek, Leo Lahti and Janne Huovari \email{ropengov-forum@@googlegroups.com} \url{http://github.com/ropengov/eurostat}
#' @keywords internal utilities database

tidy_eurostat <-
  function(dat, time_format = "date") {
 
    # Separate codes to columns
    cnames <- strsplit(colnames(dat)[1], split="\\.")[[1]]
    cnames1 <- cnames[-length(cnames)]
    cnames2 <- cnames[length(cnames)]
    dat2 <- tidyr::separate_(dat, col = colnames(dat)[1], 
                       into = cnames1, 
                       sep = ",", convert = FALSE)
    # columns from cnames1 are converted into factors
    # avoid convert = FALSE since it converts T into TRUE instead of TOTAL
    for (cname in cnames1) dat2[,cname] <- factor(dat2[,cname], levels = unique(dat2[,cname]))
    
    # To long format
    names(dat2) <- gsub("X", "", names(dat2))
    dat3 <- tidyr::gather_(dat2, cnames2, "values", names(dat2)[-c(1:length(cnames1))])
    
    # remove flags
    dat3$values <- tidyr::extract_numeric(dat3$values)
    colnames(dat3)[length(cnames1) + 1] <- cnames2
    
    # convert time column
    if (time_format == "date"){
      dat3$time <- eurotime2date(dat3$time, last = FALSE)
    } else if (time_format == "date_last"){
      dat3$time <- eurotime2date(dat3$time, last = TRUE)
    } else if (time_format == "num"){
      dat3$time <- eurotime2num(dat3$time)
    } else if (!(time_format == "raw")) {
      stop("An unknown time argument: ", time, 
      	       " Allowed are date, date_last, num and raw")
    }
    
    dat3
  }
