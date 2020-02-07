#' @title Recode geo labels and rename regions from NUTS2013 to NUTS2016 
#' @description Eurostat mixes NUTS2013 and NUTS2016 geographic label codes
#' in the \code{'geo'} column, which creates time-wise comparativity issues.
#' This function recodes the observations where only the coding changed, and
#' marks discontinued regions, and other regions which may or may not be 
#' somehow compared to current \code{'NUTS2016'} boundaries.
#' @param dat A Eurostat data frame downloaded with 
#' \code{\link{get_eurostat}}.
#' @author Daniel Antal
#' @return An augmented and potentially relabelled data frame which 
#' contains all formerly \code{'NUTS2013'} definition geo labels in the 
#' \code{'NUTS2016'} vocabulary when only the code changed, but the 
#' boundary did not. It also contains some information on other geo labels
#' that cannot be brought to the current \code{'NUTS2016'} definition. 
#' Furthermore, when the official name of the region changed, it will use
#' the new name (if the otherwise the region boundary did not change.)
#' If not called before, the function will use the helper function
#'  \code{\link{check_nuts_2013}} and  \code{\link{harmonize_geo_code}}
#' @importFrom dplyr mutate filter rename arrange case_when
#' @importFrom dplyr left_join inner_join anti_join semi_join
#' @importFrom tidyselect all_of
#' @examples
#'  \dontrun{
#'   eurostat::tgs00026 %>%
#'      check_nuts2013() %>%
#'      harmonize_geo_code() %>%
#'      recode_to_nuts_2016() 
#'      
#'  #If check_nuts2013() is not called, the function will call it.    
#'   eurostat::tgs00026 %>%
#'      recode_to_nuts_2016()    
#'  }
#' @export
 
recode_to_nuts_2016 <- function (dat) {
  
  . <- nuts_level <- geo <- code13 <- code16 <- time <- name <- NULL
  type <- nuts_correspondence <- regional_changes_2016 <- NULL

  regional_changes_2016 <- load_package_data(dataset = "regional_changes_2016")
  nuts_correspondence <- load_package_data(dataset = "nuts_correspondence")

  if ( ! all(c("change", "code16", "code13") %in% names (dat)) ) {
    tmp <- harmonize_geo_code(dat)
  } else {
    tmp <- dat
  }
  
  nuts_2016_codes <- unique (regional_changes_2016$code16)
  
  tmp <- tmp %>%
    mutate ( geo = case_when (
      !is.na(geo)                   ~ geo,
      change     == "not in the EU" ~ geo,
      TRUE ~ code16
    ))
  
  if ( any (is.na(tmp$geo) && (nuts2016 = TRUE)) ) {
    warning ( "The following regions have no geo labels:", 
              tmp %>%
                filter ( is.na(geo) && (nuts2016 = TRUE) ) %>%
                as.character(geo) )
    
  }
  
  names_by_nuts2016 <- regional_changes_2016 %>%
    filter ( !is.na(code16) )
  
  regions_by_nuts2016_names <- tmp %>% 
    select ( -name )  %>%
    inner_join ( names_by_nuts2016,
                 by = c("code13", "code16", "nuts_level", "change") ) 
  
  regions_with_other_names <- tmp %>% 
    anti_join ( regions_by_nuts2016_names, 
                    by = tidyselect::all_of(names(tmp)) )
  
  rbind ( regions_by_nuts2016_names,
          regions_with_other_names ) %>%
    arrange ( time, geo, code16 ) %>%
    left_join ( nuts_correspondence, 
                by = c("code13", "code16", "nuts_level", "change", "name"))
  
}
