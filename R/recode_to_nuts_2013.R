#' @title Recode geo labels and rename regions from NUTS2016 to NUTS2013 
#' @description Eurostat mixes NUTS2013 and NUTS2016 geographic label codes
#' in the \code{'geo'} column, which creates time-wise comparativity issues.
#' This function recodes the observations where only the coding changed, and
#' marks discontinued regions, and other regions which may or may not be 
#' somehow compared to the historic \code{'NUTS2013'} boundaries.
#' @param dat A Eurostat data frame downloaded with 
#' \code{\link{get_eurostat}}.
#' @author Daniel Antal
#' @return An augmented and potentially relabelled data frame which 
#' contains all formerly \code{'NUTS2013'} definition geo labels in the 
#' \code{'NUTS2016'} vocabulary when only the code changed, but the 
#' boundary did not. It also contains some information on other geo labels
#' that cannot be brought to the current \code{'NUTS2013'} definition. 
#' Furthermore, when the official name of the region changed, it will use
#' the new name (if the otherwise the region boundary did not change.)
#' If not called before, the function will use the helper function
#' \code{\link{harmonize_geo_code}}
#' @importFrom dplyr mutate filter rename arrange case_when
#' @importFrom dplyr left_join inner_join anti_join
#' @examples
#' test_regional_codes <- data.frame ( 
#'   geo = c("FRB", "FRE", "UKN02", "IE022", "FR243", "FRB03"),
#'   time = c(rep(as.Date ("2014-01-01"), 5), as.Date("2015-01-01")), 
#'   values = c(1:6), 
#'   control = c("Changed from NUTS2 to NUTS1", 
#'               "New region NUTS2016 only", 
#'               "Discontinued region NUTS2013", 
#'               "Boundary shift NUTS2013", 
#'               "Recoded in NUTS2013", 
#'               "Recoded in NUTS2016"
#'   )) 
#'  
#' recode_to_nuts_2013(test_regional_codes)
#' @export
 
recode_to_nuts_2013 <- function (dat) {
  
  . <- nuts_level <- geo <- code13 <- code16 <- time <- name <- NULL
  type  <- NULL

  regional_changes_2016 <- load_package_data(dataset = "regional_changes_2016")
  nuts_correspondence   <- load_package_data(dataset = "nuts_correspondence")

  if ( ! all(c("change", "code16", "code13") %in% names (dat)) ) {
    tmp <- harmonize_geo_code(dat)
  } else {
    tmp <- dat
  }
  
  nuts_2013_codes <- unique (regional_changes_2016$code13)
  
  tmp <- tmp %>%
    mutate ( geo = case_when (
      geo    == code13                       ~ geo,
      change == "not in EU - not controlled" ~ geo,
      TRUE   ~ code13
    ))
  
  if ( any (is.na(tmp$geo)) ) {
    warning ( "The following regions have no NUTS2013 geo labels: ", 
              tmp %>%
                filter ( is.na(geo) & (nuts2013 = TRUE) ) %>%
                select (code16) %>%
                unlist() %>%
                unique() %>% 
                paste(., collapse = ", "), "." )
    
  }
  
  names_by_nuts2013 <- regional_changes_2016 %>%
    filter ( !is.na(code13) )
  
  regions_by_nuts2013_names <- tmp %>% 
    select ( -name )  %>%
    inner_join ( names_by_nuts2013,
                 by = c("code13", "code16", "nuts_level", "change") ) 
  
  regions_with_other_names <- tmp %>% 
    anti_join ( regions_by_nuts2013_names, 
                    by = names(tmp) )
  
  rbind ( regions_by_nuts2013_names,
          regions_with_other_names ) %>%
    arrange ( time, geo, code16 ) %>%
    left_join ( nuts_correspondence, 
                by = c("code13", "code16", "nuts_level",
                       "change", "name", "resolution"))
  
}
