<<<<<<< HEAD
#' @title Cuts the values column into classes and polishes the labels
#' @description 
#' @param x A numeric vector \code{values} 
#' @param n A string (vector) naming eurostat dictionary or dictionaries.
#'  If \code{NULL} (default) dictionry names taken from column names of 
#'  the data.frame.
#' @param method For data.frames names of the column for which also code columns
#'   should be retained. The suffix "_code" is added to code column names.  
#' @param manual Logical. Should ...
#' @param manual_breaks 
#' @param decimals 
#' @export
#' @author Markus Kainu <markuskainu@@gmail.com>
=======
#' @title Cut a value column into classes and polishes the labels
#' @description Get definitions for Eurostat codes from Eurostat dictionaries.
#' A character or a factor vector of codes returns a corresponding vector of
#' definitions. \code{label_eurostat} labels also data.frames
#' from \code{\link{get_eurostat}}.
#' For vectors a dictionary name have to be supplied.
#' For data.frames dictonary names are taken from column names. 
#' "time" and "values" columns are returned as they were, so you can supply 
#' data.frame from \code{\link{get_eurostat}} and get data.frame with 
#' definitions instead of codes.
#' @param x A character or a factor vector or a data.frame. 
#' @param dic A string (vector) naming eurostat dictionary or dictionaries.
#'  If \code{NULL} (default) dictionry names taken from column names of 
#'  the data.frame.
#' @param code For data.frames names of the column for which also code columns
#'   should be retained. The suffix "_code" is added to code column names.  
#' @param eu_order Logical. Should Eurostat ordering used for label levels. 
#'   Affects only factors.
#' @param lang A character, code for language. Available are "en" (default), 
#'        "fr" and "de".
#' @export
#' @author Janne Huovari <janne.huovari@@ptt.fi>
>>>>>>> 0a2e28c0fa0ba9750e49739c9a7998fef19be93d
#' @return a vector or a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
<<<<<<< HEAD
#'    lp$class <- cut_to_classes(lp$values, n=5, method="jenks",decimals=1)
=======
#'    lpl <- label_eurostat(lp)
#'    str(lpl)
#'    lpl_order <- label_eurostat(lp, eu_order = TRUE)
#'    lpl_code <- label_eurostat(lp, code = "unit")
#'    label_eurostat_vars(names(lp))
#'    label_eurostat_tables("nama_aux_lp")
>>>>>>> 0a2e28c0fa0ba9750e49739c9a7998fef19be93d
#'  }
cut_to_classes <- function(x, n=5,method="jenks",manual=FALSE,manual_breaks = NULL,decimals=0) {
  
  library(stringr)
  library(classInt)
  if (manual) {
    levs <- as.data.frame(levels(cut(x, 
                                     breaks=manual_breaks,
                                     include.lowest=T,
                                     dig.lab=5)))
  } else {
    levs <- as.data.frame(levels(cut(x, 
                                     breaks=data.frame(classIntervals(x,n=n,method=method)[2])[,1],
                                     include.lowest=T,
                                     dig.lab=5)))
  } 
  names(levs) <- "orig"
  levs$mod <- str_replace_all(levs$orig, "\\[", "")
  levs$mod <- str_replace_all(levs$mod, "\\]", "")
  levs$mod <- str_replace_all(levs$mod, "\\(", "")
  levs$lower <- gsub(",.*$","", levs$mod)
  levs$upper <- gsub(".*,","", levs$mod)
  
  levs$lower <- factor(levs$lower)
  levs$lower <- round(as.numeric(levels(levs$lower))[levs$lower],decimals)
  levs$lower <- prettyNum(levs$lower, big.mark=" ")
  
  levs$upper <- factor(levs$upper)
  levs$upper <- round(as.numeric(levels(levs$upper))[levs$upper],decimals)
  levs$upper <- prettyNum(levs$upper, big.mark=" ")
  
  levs$labs <- paste(levs$lower,levs$upper, sep=" ~< ")
  
  labs <- as.character(c(levs$labs))
  if (manual) {
    y <- cut(x, breaks = manual_breaks,
             include.lowest=T,
             dig.lab=5, labels = labs)
    rm(manual_breaks)
  } else {
    y <- cut(x, breaks = data.frame(classIntervals(x,n=n,method=method)[2])[,1],
             include.lowest=T,
             dig.lab=5, labels = labs)
  }
  y <- as.character(y)
  #if (is.na(y)) {
  y[is.na(y)] <- "No Data"
  y <- factor(y, levels=c("No Data",labs[1:n]))
  y
}