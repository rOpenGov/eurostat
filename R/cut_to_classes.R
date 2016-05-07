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
#' @return a vector or a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lp$class <- cut_to_classes(lp$values, n=5, method="jenks",decimals=1)
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