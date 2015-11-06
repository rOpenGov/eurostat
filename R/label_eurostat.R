#' @title label_eurostat
#' @description Get definitions for Eurostat codes from Eurostat dictionaries.
#' A character or a factor vector of codes returns a corresponding vector of
#' definitions. \code{label_eurostat} labels also for data.frames
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
#' @param code For data.frames names of the column for which also codes
#'   should be retained. The suffix "_code" is added to code column names.  
#' @param eu_order Logical. Should Eurostat ordering used for label levels. 
#'   Affects only factors.
#' @export
#' @author Janne Huovari <janne.huovari@@ptt.fi>
#' @return a vector or a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- label_eurostat(lp)
#'    str(lpl)
#'    lpl_order <- label_eurostat(lp, eu_order = TRUE)
#'    lpl_code <- label_eurostat(lp, code = "unit")
#'    label_eurostat_vars(names(lp))
#'    label_eurostat_tables("nama_aux_lp")
#'  }
label_eurostat <- function(x, dic = NULL, code = NULL, eu_order = FALSE){
  if (is.data.frame(x)){
    y <- x
    for (i in names(y)[!(names(y) %in% c("time", "values"))]){
      y[[i]] <- label_eurostat(y[[i]], i, eu_order = eu_order)
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
    if (is.factor(x)){
      if (eu_order) {
        ord <- dic_order(levels(x), dic_df, "code")
      } else {
        ord <- seq_along(levels(x))
      }
      
      y <- factor(x, levels(x)[ord], 
                  labels = dic_df[[2]][match(levels(x), dic_df[[1]])][ord])
    } else {
      # dics are in upper case, change if x is not
      test_n <- min(length(x), 5)
      if (!all(toupper(x[1:test_n ]) == x[1:test_n])) x <- toupper(x)
      # mapvalues
      y <- dic_df[[2]][match(x, dic_df[[1]])]      
    }

    if (any(is.na(y))) warning("All labels for ", dic, " were not found.")
  }
  y
}
  
#' @describeIn label_eurostat Get definitions for variable (column) names. For
#'  objects other than characters or factors definitions are get for names.
#' @export
label_eurostat_vars <- function(x){
  if(!(is.character(x) | is.factor(x))) x <- names(x)
  label_eurostat(x, dic = "dimlst")
}

#' @describeIn label_eurostat Get definitions for table names
#' @export
label_eurostat_tables <- function(x){
  if(!(is.character(x) | is.factor(x))) stop("x have to be a character or a factor")
  label_eurostat(x, dic = "table_dic")
}

#' Order of variable levels from Eurostat dictionary.
#' 
#' Some variables, like classifications, have logical or conventional ordering. 
#' Eurostat data tables are nor neccessary ordered in this order. 
#' The function \code{dic_order} get the ordering from Eurostat classifications
#' dictionaries.
#' 
#' The function \code{\link{label_eurostat}} can also order factor levels of
#' labels with argument \code{eu_order = TRUE}.
#' 
#' @param x a variable (code or labelled) to get order for.
#' @param dic a name of the dictionary. Correspond a variable name in the 
#'    data.frame from \code{\link{get_eurostat}}. Can be also data.frame from
#'    \code{\link{get_eurostat_dic}}.
#' @param type a type of the x. Could be \code{code} or \code{label}.
#' 
#' @export
#' @return A numeric vector of orders.

dic_order <- function(x, dic, type) {
  if (!is.data.frame(dic)) dic <- get_eurostat_dic(dic)
  
  # code or label
  n_type <- match(type, c("code", "label"))
  if (is.na(n_type)) stop("Invalid type.")
  
  # get order
  y <- order(match(x, dic[[n_type]]))
  if (any(is.na(y))) stop("All orders were not found.")
  y
}
