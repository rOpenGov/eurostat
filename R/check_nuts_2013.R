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
#' @importFrom dplyr mutate filter rename mutate_if case_when
#' @importFrom dplyr left_join full_join anti_join
#' @examples
#'  \dontrun{
#'    dat <- eurostat::tgs00026
#'    check_nuts_2013(dat)
#'  }

check_nuts_2013 <- function (dat) {
  
  ## For non-standard evaluation -------------------------------------
  . <- change  <- geo <- code13 <- code16 <- nuts_level <- NULL
  regional_changes_2016 <- country_code <- NULL
  
  ## The data is not loaded into the global environment --------------
  
  regional_changes_2016 <- load_package_data(dataset = "regional_changes_2016")
  
  unchanged_regions <- regional_changes_2016 %>% 
    filter ( change == 'unchanged' )
  
  changed_regions <- regional_changes_2016 %>% 
    filter ( change != 'unchanged' )
  
  ## Changed regions to be looked up by their NUTS2016 codes -----------
  regional_changes_by_2016 <- regional_changes_2016 %>%
    mutate ( geo = code16 ) %>% 
    filter ( !is.na(code13) )
  
  ## adding those that have no equivalent in the previous group
  ## some regions have to be identified by their old and new codes -----
  regional_changes_by_2013 <- regional_changes_2016 %>%
    mutate ( geo = code13 ) %>% 
    filter ( !is.na(code13) ) %>%
    anti_join ( regional_changes_by_2016, 
                by = c("code13", "code16", "name",
                       "nuts_level", "change", "geo") )
  
  ## Region can be found by new or old NUTS code -----------------------
  
  all_regional_changes <- regional_changes_by_2016 %>%
    full_join ( regional_changes_by_2013, 
                by = c("code13", "code16", "name",
                       "nuts_level",
                       "change", "geo") )
  
  
  tmp <- dat %>%
    mutate_if ( is.factor, as.character ) %>%
    left_join ( all_regional_changes, by = 'geo' ) %>%
    mutate ( nuts_level = ifelse (is.na(nuts_level), 
                                  add_nuts_level(geo),
                                  nuts_level))
  
  if ( all ( tmp$change %in% unique(regional_changes_2016$code16) )) {
    message ( "All observations are coded with NUTS2016 codes" )
    there_are_changes <- FALSE
  }
 
  eu_countries <- load_package_data(dataset = "eu_countries")

  eu_country_vector <-  unique ( substr(eu_countries$code, 1, 2) )
  
  tmp <- tmp %>%
    mutate ( country_code = substr(geo,1,2) ) %>%
    mutate ( change = ifelse ( country_code %in% eu_country_vector, 
                               yes  = change,
                               no = "not in the EU")) %>%
    select ( -country_code )

  if ( any(tmp$change == 'not in the EU') ) {
    
    not_EU_country_vector <- substr(tmp$geo, 1,2)
    not_EU_country_vector <- not_EU_country_vector [ !not_EU_country_vector %in% eu_country_vector]
    ## The correspondence table only covers EU regions.
    message ( "Not checking for regional label consistency in non-EU countries\n",
              "In this data frame non-EU country: ", 
              paste (sort(unique(not_EU_country_vector)),
                     collapse = ", "), "." )
  }
  
  nuts_2016_codes <- unique(regional_changes_2016$code16)
  nuts_2013_codes <- unique(regional_changes_2016$code13)
  
  tmp <- tmp %>%
    mutate ( nuts_2016 = ifelse ( geo %in% nuts_2016_codes, 
                                  TRUE, FALSE),
             nuts_2013 = ifelse ( geo %in% nuts_2013_codes, 
                                  TRUE, FALSE))
  
}
