#' @title Add the statistical aggregation level to data frame
#' @description Eurostat regional statistics contain country, and various
#' regional level information.  In many cases, for example, when mapping,
#' it is useful to filter out national level data from NUTS2 level regional data,
#' for example. 
#' @param dat A data frame or tibble returned by \code{\link{get_eurostat}}.
#' @param geo_labels A geographical label, defaults to \code{geo}.
#' @export
#' @importFrom dplyr mutate case_when
#' @author Daniel Antal
#' @return a new numeric variable nuts_level with the numeric value of
#' NUTS level 0 (country), 1 (greater region),
#' 2 (region), 3 (small region).
#' @examples
#'  {
#'    dat = data.frame (
#'         geo    = c("FR", "IE04", "DEB1C"), 
#'         values = c(1000, 23, 12)
#'    )
#'    
#'    add_nuts_level(dat)
#'  }

add_nuts_level <- function (dat, geo_labels = "geo") {
  
  if ( any(c("character", "factor") %in% class(dat)) ) {
      input <- 'label'
      geo <- dat 
      dat <- data.frame( geo = as.character(geo), 
                         stringsAsFactors = FALSE)
    } else { 
      input <- "not_label" 
      }
  

  if ( "data.frame" %in% class(dat) ) {
    if ( ! geo_labels %in% names(dat) ) {
      stop ( "Regional labelling variable '",
             geo_labels,
             "' is not found in the data frame.")
    }
    
    dat <- dat %>% 
      mutate ( nuts_level = case_when (
        nchar(as.character(geo)) == 2  ~ 0,
        nchar(as.character(geo)) == 3  ~ 1,
        nchar(as.character(geo)) == 4  ~ 2,
        nchar(as.character(geo)) == 5  ~ 3,
        TRUE ~ NA_real_
      ))
  } 
 
  if ( input == "label" ) {
    as.numeric(dat$nuts_level)
  } else dat
  
}
