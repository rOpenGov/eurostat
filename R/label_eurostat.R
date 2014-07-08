#' Get definitions for Eurostat codes
#' 
#' 

label_eurostat <- function(x, dic){
  dic_df <- getEurostatDictionary(dic)
  # in case of column names (not factors), change to upper case
  if (!is.factor(x)) x <- toupper(x)
  y <- plyr:::mapvalues(x, dic_df[,1], dic_df[,2], warn_missing = FALSE)
  y
}

label_eurostat_df <- function(x){
  if (!is.data.frame(x)) stop("x is not data.frame")
  
  y <- as.data.frame(lapply(x[, !(names(x) %in% c("time", "value"))], label_eurostat))
  y
}

lpl <- label_eurostat_df(lp)
