#' Get definitions for Eurostat codes
#' 
#' Get definitions for Eurostat codes from Eurostat dictionaries
#' 
#' A string or a factor vector of codes returns  a corresponding 
#' vector of definations. For vectors a dictionary name have to be supplied.
#' For data.frames dictonary names are taken from column names. 
#' "time" and "value" columns are returned as they were, so you can supply 
#' data.frame from \code{\link{get_eurostat}} and get data.frame with 
#' definations instead of codes.
#' 
#' @param x a vector or a data.frame. 
#' @param dic a string (vector) naming eurostat dictionary or dictionaries.
#'  If \code{NULL} (default) dictionry names taken from column names of the data.frame. 
#' @import plyr
#' @export
#' @author Janne Huovari <janne.huovari@@ptt.fi>
#' @return a vector or a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- label_eurostat_vars(lp)
#'    str(lpl)
#'    label_eurostat_vars(names(lp))
#'    label_eurostat_tables("nama_aux_lp")
#'  }

label_eurostat <- function(x, dic = NULL){
  if (is.data.frame(x)){
    y <- x
    for (i in names(y)[!(names(y) %in% c("time", "value"))]){
      y[[i]] <- label_eurostat(y[[i]], i)
    }
  } else {
    if (is.null(dic)) stop("Dictionary information is missing")
    dic_df <- getEurostatDictionary(dic)
    # in case of column names (not factors), change to upper case
    if (!is.factor(x)) x <- toupper(x)
    y <- mapvalues(x, dic_df[,1], dic_df[,2], warn_missing = FALSE)
  }
  y
}
  
#' @describeIn label_eurostat Get definations for variable (column) names
label_eurostat_vars <- function(x){
  label_eurostat(x, dic = "dimlst")
}

#' @describeIn label_eurostat Get definations for table names
label_eurostat_tables <- function(x){
  label_eurostat(x, dic = "table_dic")
}


