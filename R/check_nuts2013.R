#' @title Check NUTS region codes that changed with the \code{NUTS2016} definition
#' @description Eurostat mixes \code{NUTS2013} and \code{NUTS2016} geographic
#' label codes in the \code{'geo'} column, which creates time-wise comparativity issues.
#' This function checks if you data is affected by this problem and gives
#' information on what to do.
#' @param dat A Eurostat data frame downloaded with \code{\link{get_eurostat}}
#' @export
#' @author Daniel Antal
#' @return An augmented data frame or a message about potential coding
#' errors. For filtering, it marks \code{'non_EU'} and \code{'unchanged'}
#' regions. Observations with codes ending on \code{'ZZ'} or \code{'XX'} are
#' removed from the returned data table, because these are non-territorial
#' observations or they are outside of the EU.
#' @importFrom  dplyr left_join mutate filter rename mutate_if
#' @examples
#'  \dontrun{
#'    dat <- eurostat::tgs00026
#'    check_nuts2013(dat)
#'  }

check_nuts2013 <- function (dat) {
  
  ## For non-standard evaluation -------------------------------------
  change  <- geo <- code13 <- code16 <- NULL 
  data("regional_changes_2016")
 
  unchanged_regions <- regional_changes_2016 %>% 
    filter ( change == 'unchanged')
  
  changed_regions <- regional_changes_2016 %>% 
    filter ( change != 'unchanged')
  
  tmp <- dat  %>%
    mutate_if ( is.factor, as.character ) %>%
    left_join (  regional_changes_2016 %>% 
                  select ( code16, change ) %>%
                  dplyr::rename ( geo = code16 ),
                by = 'geo')
  
  there_are_changes <- FALSE
  
  if ( any (is.na(tmp$change)) ) {
    tmp <- dat  %>%
      mutate_if ( is.factor, as.character ) %>%
      left_join (  regional_changes_2016 %>% 
                     select ( code13, change ) %>%
                     dplyr::rename ( geo = code13 ),
                   by = 'geo')
    
    there_are_changes <- TRUE
  }
  
  eu_country_vector <-  eurostat::eu_countries$code
  tmp_country_vector <- unique ( substr(tmp$geo, 1, 2) )
  not_EU_country_vector <- tmp_country_vector [! tmp_country_vector %in% eu_country_vector] 

  if ( length(not_EU_country_vector) > 0 ) {
     ## The correspondence table only covers EU regions.
     message ( "Not checking for regional label consistency in non-EU countries\n",
               "In this data frame: ", not_EU_country_vector )
  }
  
  if ( any( stringr::str_sub(tmp$geo, -2,-1) %in% c('ZZ', 'XX')) ) {
    
    warning ( "Regional codes ending with ZZ or XX are extra-territorial", 
              "\n to the EU and they are removed from the data frame.")
    
  }
    
  tmp %>%
    mutate ( change  = ifelse (  geo %in% not_EU_country_vector , 
                                 'not_EU', change )) %>%
    filter ( stringr::str_sub(geo, -3,-1) != "ZZZ", 
             stringr::str_sub(geo, -2,-1) != "ZZ", 
             stringr::str_sub(geo, -3,-1) != "XXX", 
             stringr::str_sub(geo, -2,-1) != "XX" ) %>%
    mutate_if ( is.factor, as.character ) 
  
}
