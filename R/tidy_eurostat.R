# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# All rights reserved.
# This software is part of rOpenGov <ropengov.github.com>

#' Download a dataset from the eurostat database (ec.europa.eu/eurostat).  
#' 
#' @description Download a dataset from the eurostat database. The dataset is transformed into the molten / row-column-value format (RCV).
#' 
#' Arguments:
#'  @param id A code name for the data set of interest. See the table of contents of eurostat datasets for details.
#'  @param time_format a string giving a type of the conversion of the time column from 
#'         the eurostat format. A "date" (default) convers to a \code{\link{Date}} with a first 
#'         date of the period. A "date_last" convers to a \code{\link{Date}} with 
#'         a last date of the period. A "num" convers to a numeric and "raw" 
#'         does not do conversion. See \code{\link{eurotime2date}} and 
#'         \code{\link{eurotime2num}}.
#'
#' Returns:
#'  @return A dataset in the molten format with the last column 'value'. See the melt function from reshape package for more details.
#'
#' @import tidyr
#' @seealso \code{\link{getEurostatTOC}}, \code{\link{get_eurostat_raw}}
#' @details Data is downloaded from \code{http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing} website.
#' @references see citation("eurostat"). 
#' @author Przemyslaw Biecek, Leo Lahti and Janne Huovari \email{louhos@@googlegroups.com} \url{http://github.com/ropengov/eurostat}
#' @examples \dontrun{
#'    tmp <- tidy_eurostat("educ_iste")
#'    head(tmp)
#'    t1 <- tidy_eurostat("tsdtr420")
#'    tmp <- cast(t1, geo ~ time , mean)
#'    tmp2 <- tmp[,-1]
#'    rownames(tmp2) <- tmp[,1]
#'    head(tmp2)
#'    tmp3 <- tmp2[c("UK", "SK", "FR", "PL", "ES", "PT", "LV"),]
#'    matplot(as.numeric(colnames(tmp3)), t(tmp3), type="o", 
#'            pch=19, lty=1, las=1, 
#'	      xlab="", ylab="", yaxt="n")
#'    }
#' @keywords utilities database

tidy_eurostat <-
  function(id, time_format = "date") {
    
    dat <- get_eurostat_raw(id)
    
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
    dat3 <- tidyr::gather_(dat2, cnames2, "value", names(dat2)[-c(1:length(cnames1))])
    
    # remove flags
    dat3$value <- tidyr::extract_numeric(dat3$value)
    colnames(dat3)[length(cnames1) + 1] <- cnames2
    
    # convert time column
    if (time_format == "date"){
      dat3$time <- eurotime2date(dat3$time, last = FALSE)
    } else if (time_format == "date_last"){
      dat3$time <- eurotime2date(dat3$time, last = TRUE)
    } else if (time_format == "num"){
      dat3$time <- eurotime2num(dat3$time)
    } else if (!(time_format == "raw")) {
      stop("An unknown time argument: ", time, " Allowed are date, date_last, num and raw")
    }
    
    dat3
  }
