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

  unchanged_regions <- regional_changes_2016 %>% 
    filter ( change == 'unchanged')
  
  changed_regions <- regional_changes_2016 %>% 
    filter ( change != 'unchanged')
  
  ## Changed regions to be looked up by their NUTS2016 codes -----------
  regional_changes_by_2016 <- regional_changes_2016 %>%
    mutate ( geo = code16 ) %>% 
    filter ( !is.na(code13))
  
  nrow(regional_changes_by_2016)
  
  ## adding those that have no equivalent in the previous group
  ## some regions have to be identified by their old and new codes -----
  regional_changes_by_2013 <- regional_changes_2016 %>%
    mutate ( geo = code13 ) %>% 
    filter ( !is.na(code13)) %>%
    anti_join ( regional_changes_by_2016, 
                by = c("code13", "code16", "name", "nuts_level", "change", "geo"))
  
  nrow(regional_changes_by_2013)
  
  ## Region can be found by new or old NUTS code -----
  
  all_regional_changes <- regional_changes_by_2016 %>%
    full_join ( regional_changes_by_2013, 
                by = c("code13", "code16", "name", "nuts_level", "change", "geo"))
  
  
  tmp <- dat %>%
    mutate_if ( is.factor, as.character ) %>%
    left_join ( all_regional_changes, by = 'geo' ) %>%
    mutate ( nuts_level = ifelse (is.na(nuts_level), 
                                  9, nuts_level)) %>%
    mutate ( nuts_level = case_when ( 
      nuts_level < 9                  ~ nuts_level,
      nuts_level == 9 & nchar(geo)==2 ~ 0,
      nuts_level == 9 & nchar(geo)==3 ~ 1,
      nuts_level == 9 & nchar(geo)==4 ~ 2,
      nuts_level == 9 & nchar(geo)==5 ~ 3,
      TRUE ~ NA_real_ ))
  
  if ( all ( tmp$change %in% unique(regional_changes$code16) )) {
    message ( "All observations are coded with NUTS2016 codes" )
    there_are_changes <- FALSE
  }
 
  non_eu <- select ( tmp, geo, code13, code16, change ) %>%
    mutate ( change = ifelse (rowSums(is.na(.))==3, 
                              "not in the EU", change )) %>%
    filter ( change == 'not in the EU' )
  
  tmp <- tmp %>% mutate ( change = ifelse ( geo %in% non_eu$geo, 
                                            'not in the EU', change ))  
  
  
  eu_country_vector <-  eurostat::eu_countries$code
  tmp_country_vector <- unique ( substr(tmp$geo, 1, 2) )
  not_EU_country_vector <- tmp_country_vector [! tmp_country_vector %in% eu_country_vector] 

  if ( length(not_EU_country_vector) > 0 ) {
     ## The correspondence table only covers EU regions.
     message ( "Not checking for regional label consistency in non-EU countries\n",
               "In this data frame: ", not_EU_country_vector )
  }
  
  tmp
  
}
