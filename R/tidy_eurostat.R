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
#'  @param select_time a character symbol for a time frequence or NULL (default). 
#'
#'  @return data.frame in the molten format with the last column 'values'. 
#'  	    
#' @seealso \code{\link{get_eurostat}}
#' @references See citation("eurostat"). 
#' @author Przemyslaw Biecek, Leo Lahti and Janne Huovari \email{ropengov-forum@@googlegroups.com} \url{http://github.com/ropengov/eurostat}
#' @keywords internal utilities database

tidy_eurostat <-
  function(dat, time_format = "date", select_time = NULL) {
 
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

    
    # selector for mixed time format data
    
    freq_names <- names(dat2)[!(names(dat2) %in% cnames1)]
    
    if (!is.null(select_time)){
      if (length(select_time) > 1) stop(
        "Only one frequency should be selected in select_time. Selected: ", 
        shQuote(select_time))
      # Annual 
      if (select_time == "Y"){
        dat2 <- dat2[, c(cnames1, freq_names[nchar(freq_names) == 5])]
      # Others
      } else {
        dat2 <- dat2[, c(cnames1, grep(select_time, freq_names, value = TRUE))]
      }
      # Test if data
      if (identical(names(dat2), cnames1)) stop(
        "No data selected with select_time:", dQuote(select_time), "\n",
        "Available frequencies: ", shQuote(available_freq(freq_names)))
    } else {
      if (length(available_freq(freq_names)) > 1 & time_format != "raw") stop(
        "Data includes several time frequencies. Select frequency with 
         select_time or use time_format = \"raw\". 
         Available frequencies: ", shQuote(available_freq(freq_names)))
      
    }
    

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
