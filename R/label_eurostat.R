#' @title Get Eurostat Codes
#' @description Get definitions for Eurostat codes from Eurostat dictionaries.
#' @details A character or a factor vector of codes returns a corresponding 
#'    vector of definitions. \code{label_eurostat} labels also data_frames from 
#'    \code{\link{get_eurostat}}. For vectors a dictionary name have to be 
#'    supplied. For data_frames dictonary names are taken from column names. 
#'    "time" and "values" columns are returned as they were, so you can supply 
#'    data_frame from \code{\link{get_eurostat}} and get data_frame with 
#'    definitions instead of codes.
#'    
#'    Some Eurostat dictionaries includes dublicated labels. By default 
#'    dublicated labels cause an error, but they can be fixed automatically 
#'    with \code{fix_duplicated = TRUE}.
#'    
#' @param x A character or a factor vector or a data_frame.
#' @param dic A string (vector) naming eurostat dictionary or dictionaries.
#'    If \code{NULL} (default) dictionry names taken from column names of
#'    the data_frame.
#' @param code For data_frames names of the column for which also code columns
#'     should be retained. The suffix "_code" is added to code column names.
#' @param eu_order Logical. Should Eurostat ordering used for label levels.
#'     Affects only factors.
#' @param lang A character, code for language. Available are "en" (default),
#'     "fr" and "de".
#' @param countrycode A \code{NULL} or a name of the coding scheme for 
#'     the \code{\link[countrycode]{countrycode}} 
#'     to label "geo" variable with countrycode-package. It can be used to
#'     convert to short and long country names in many different languages.
#'     If \code{NULL} (default) eurostat dictionary is used instead.
#' @param countrycode_nomatch What to do when using the countrycode to label a "geo" and
#'     countrycode fails to find a match, for example other than country codes like EU28.
#'     the original code is used with 
#'     a \code{NULL} (default), eurostat dictionary label is used with "eurostat",
#'     and \code{NA} is used with NA. 
#' @param custom_dic a named vector or named list of named vectors to give an own dictionary
#'     for (part of) codes. Names of the vector should be codes and values labels. List
#'     can be used to spesify dictonaries and then list names should be dictionary codes.
#' @param fix_duplicated A logical. If TRUE, the code is added to the
#'     duplicated label values. If FALSE (default) error is given if 
#'     labelling produce duplicates.
#' @export
#' @author Janne Huovari \email{janne.huovari@@ptt.fi}
#' @return a vector or a data_frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_10_lp_ulc")
#'    lpl <- label_eurostat(lp)
#'    str(lpl)
#'    lpl_order <- label_eurostat(lp, eu_order = TRUE)
#'    lpl_code <- label_eurostat(lp, code = "unit")
#'    label_eurostat_vars(names(lp))
#'    label_eurostat_tables("nama_10_lp_ulc")
#'    label_eurostat(c("FI", "DE", "EU28"), dic = "geo")
#'    label_eurostat(c("FI", "DE", "EU28"), dic = "geo", custom_dic = c(DE = "Germany"))
#'    label_eurostat(c("FI", "DE", "EU28"), dic = "geo", countrycode = "country.name",
#'                   custom_dic = c(EU28 = "EU"))
#'    label_eurostat(c("FI", "DE", "EU28"), dic = "geo", countrycode = "country.name")
#'    # In Finnish
#'    label_eurostat(c("FI", "DE", "EU28"), dic = "geo", countrycode = "cldr.short.fi")
#'  }
label_eurostat <-
  function(x,
           dic = NULL,
           code = NULL,
           eu_order = FALSE,
           lang = "en",
           countrycode = NULL,
           countrycode_nomatch = NULL,
           custom_dic = NULL,
           fix_duplicated = FALSE) {
    
    # Check if you have internet connection
    internet_available <- curl::has_internet()
    if (!internet_available) stop("You have no internet connection, please reconnect!")

    # Avoid warnings
    code_name <- NULL
    
    if (is.data.frame(x)) {
      y <- x
      
      mynams <- names(y)[!(names(y) %in% c("time", "values", "flags"))]
      
      for (i in names(y)[!(names(y) %in% c("time", "values", "flags"))]) {
        y[[i]] <- label_eurostat(y[[i]], i,
            eu_order = eu_order,
            lang = lang,
            countrycode = countrycode,
            countrycode_nomatch = countrycode_nomatch,
            custom_dic = custom_dic,
            fix_duplicated = fix_duplicated
          )
      }
      
      # Fix the first two variables
      #nams <- names(y)
      #y <- cbind(as.vector(unlist(x[[1]])),
      #           as.vector(unlist(x[[2]])),
      #           x[, 3:ncol(x)])
      #colnames(y) <- nams
      
      # Codes added if asked
      if (!is.null(code)) {
        code_in <- code %in% names(y)
        if (!all(code_in))
          stop("code column name(s) ", shQuote(code[!code_in]), " not found on x")
        y_code <- x[, code, drop = FALSE]
        names(y_code) <- paste0(names(y_code), "_code")
        y <- cbind(y_code, y)
      }

      return(tibble::as_tibble(y))
      
    } else { 
      if (is.null(dic))
        stop("Dictionary information is missing")
      
      dic_df <- get_eurostat_dic(dic, lang = lang)
      
      if (is.factor(x)) {
        if (eu_order) {
          ord <- dic_order(levels(x), dic_df, "code")
        } else {
          ord <- seq_along(levels(x))
        }
        
        y <- factor(x, levels(x)[ord], 
                    labels = label_eurostat(levels(x), dic = dic,
                                            eu_order = eu_order,
                                            lang = lang,
                                            countrycode = countrycode,
                                            countrycode_nomatch = countrycode_nomatch,
                                            custom_dic = custom_dic,
                                            fix_duplicated = fix_duplicated)[ord]
        )
        
        #return factor
        return(y)
        
      } else if (dic == "geo" & !is.null(countrycode)){
        if (is.null(countrycode_nomatch)){
          y <- countrycode::countrycode(x, origin = "eurostat", destination = countrycode, nomatch = NULL)
        } else if (is.na(countrycode_nomatch)) {
          y <- countrycode::countrycode(x, origin = "eurostat", destination = countrycode, nomatch = NA)
        } else if (countrycode_nomatch == "eurostat") {
          y <- countrycode::countrycode(x, origin = "eurostat", destination = countrycode, nomatch = NA)
          y[is.na(y)] <- label_eurostat(x[is.na(y)], dic = "geo", lang = lang, fix_duplicated = fix_duplicated)
        } else {
          stop("unknown argument ", countrycode_nomatch, " for countrycode_nomatch")
        }
      } else {
        # dics are in upper case, change if x is not
        test_n <- min(length(x), 5)
        if (!all(toupper(x[1:test_n]) == x[1:test_n]))
          x <- toupper(x)
        # test duplicates
        dic_sel <-  dplyr::filter(dic_df, code_name %in% x)
        
        if (anyDuplicated(dic_sel$full_name)) {
          if (fix_duplicated) {
            dup_labels <-
              dic_sel$full_name %in% dic_sel$full_name[duplicated(dic_sel$full_name)]
            modif_dup_labels <- paste(dic_sel$code_name[dup_labels],
                                      dic_sel$full_name[dup_labels],
                                      sep = " ")
            dic_sel$full_name[dup_labels] <- modif_dup_labels
            message(
              "Labels for ",
              dic,
              " includes duplicated labels in the Eurostat dictionary. ",
              "Codes have been added as a prefix for dublicated.\n",
              "Modified labels are: ",
              paste0(modif_dup_labels, collapse = ", ")
            )
          } else {
            stop(
              "Labels for ",
              dic,
              " includes duplicated labels in the Eurostat dictionary. ",
              "Use fix_duplicated = TRUE with label_eurostat() to fix duplicated 
              labels automatically."
            )
          }
        }
        # mapvalues
        y <- dic_sel[[2]][match(x, dic_sel[[1]])]
 
      }
      
      # apply custom_dic
      if (!is.null(custom_dic)){
        if (is.list(custom_dic)) custom_dic <- custom_dic[[dic]]
        y <- dplyr::coalesce(unname(custom_dic[x]), y)
      }
      
      if (any(is.na(y)))
        warning("All labels for ", dic, " were not found.")
      
    }
    

    
    y
    
  }

#' @describeIn label_eurostat Get definitions for variable (column) names. For
#'  objects other than characters or factors definitions are get for names.
#' @export
label_eurostat_vars <- function(x, lang = "en") {
  if (!(is.character(x) | is.factor(x)))
    x <- names(x)
  x <- x[!grepl("values", x)]  # remove values column
  label_eurostat(x, dic = "dimlst", lang = lang)
}

#' @describeIn label_eurostat Get definitions for table names
#' @export
label_eurostat_tables <- function(x, lang = "en") {
  if (!(is.character(x) |
        is.factor(x)))
    stop("x have to be a character or a factor")
  label_eurostat(x, dic = "table_dic", lang = lang)
}
