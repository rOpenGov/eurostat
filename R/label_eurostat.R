#' Get definitions for Eurostat codes from Eurostat dictionaries
#' 
#' A string or a factor vector of codes returns a corresponding 
#' vector of definitions. For vectors a dictionary name have to be supplied.
#' For data.frames dictonary names are taken from column names. 
#' "time" and "values" columns are returned as they were, so you can supply 
#' data.frame from \code{\link{get_eurostat}} and get data.frame with 
#' definitions instead of codes.
#' 
#' @param x A vector or a data.frame. 
#' @param dic A string (vector) naming eurostat dictionary or dictionaries.
#'  If \code{NULL} (default) dictionry names taken from column names of 
#'  the data.frame.
#' @param code For data.frames names of the column for which also codes
#'   should be retained. The suffix "_code" is added to code column names.  
#' @export
#' @author Janne Huovari <janne.huovari@@ptt.fi>
#' @return a vector or a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- label_eurostat(lp)
#'    str(lpl)
#'    lpl_code <- label_eurostat(lp, code = "unit")
#'    label_eurostat_vars(names(lp))
#'    label_eurostat_tables("nama_aux_lp")
#'  }

label_eurostat <- function(x, dic = NULL, code = NULL){
  if (is.data.frame(x)){
    y <- x
    for (i in names(y)[!(names(y) %in% c("time", "values"))]){
      y[[i]] <- label_eurostat(y[[i]], i)
    }
    
    #codes added if asked
    if (!is.null(code)){
      code_in <- code %in% names(y)
      if (!all(code_in)) stop("code column name(s) ", shQuote(code[!code_in])," not found on x")
      y_code <- x[, code, drop = FALSE]
      names(y_code) <- paste0(names(y_code), "_code")
      y <- cbind(y_code, y)
    }
  } else {
    if (is.null(dic)) stop("Dictionary information is missing")
    dic_df <- get_eurostat_dic(dic)
    # in case of column names (not factors), change to upper case
    if (!is.factor(x)) x <- toupper(x)
    y <- plyr::mapvalues(x, dic_df[,1], dic_df[,2], warn_missing = FALSE)
  }
  y
}
  
#' @describeIn label_eurostat Get definitions for variable (column) names
#' @export
label_eurostat_vars <- function(x){
  label_eurostat(x, dic = "dimlst")
}

#' @describeIn label_eurostat Get definitions for table names
#' @export
label_eurostat_tables <- function(x){
  label_eurostat(x, dic = "table_dic")
}


