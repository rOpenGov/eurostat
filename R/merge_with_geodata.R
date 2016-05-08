<<<<<<< HEAD
#' @title Get preprocessed spatial data from CISGO and merge with 
#' @description Get preprocessed data.frame 
#' definitions for Eurostat codes from Eurostat dictionaries.
=======
#' @title Merge with preprocessed spatial data from CISGO
#' @description Get definitions for Eurostat codes from Eurostat dictionaries.
>>>>>>> 0a2e28c0fa0ba9750e49739c9a7998fef19be93d
#' A character or a factor vector of codes returns a corresponding vector of
#' definitions. \code{label_eurostat} labels also data.frames
#' from \code{\link{get_eurostat}}.
#' For vectors a dictionary name have to be supplied.
#' For data.frames dictonary names are taken from column names. 
#' "time" and "values" columns are returned as they were, so you can supply 
#' data.frame from \code{\link{get_eurostat}} and get data.frame with 
#' definitions instead of codes.
<<<<<<< HEAD
#' @param data A character or a factor vector or a data.frame. 
#' @param geocol A string (vector) naming eurostat dictionary or dictionaries.
#'  If \code{NULL} (default) dictionry names taken from column names of 
#'  the data.frame.
#' @param res For data.frames names of the column for which also code columns
#'   should be retained. The suffix "_code" is added to code column names.  
#' @export
#' @author Markus Kainu <markuskainu@@gmail.com>
#' @return a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- merge_with_geodata(lp, geocol="geo", res=60)
#'    str(lpl)
=======
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
>>>>>>> 0a2e28c0fa0ba9750e49739c9a7998fef19be93d
#'  }
#'  

merge_with_geodata <- function(data,geocol="geo",res=60){
  load(url(paste0("http://data.okf.fi/ropengov/avoindata/eurostat_geodata/rdata/NUTS_2013_",
                  res,
                  "M_SH_DF.RData")))
  map.df <- get(paste0("NUTS_2013_",res,"M_SH_DF"))
  d <- merge(data,map.df,by.x=geocol,by="NUTS_ID",all.x=TRUE)
  d <- d[order(d$order),] 
  return(d)
}