#' @title Recode geo labels from NUTS2013 to NUTS2016 
#' @description Eurostat mixes NUTS2013 and NUTS2016 geographic label codes
#' in the \code{'geo'} column, which creates time-wise comparativity issues.
#' This function recodes the observations where only the coding changed, and
#' marks discontinued regions, and other regions which may or may not be 
#' somehow compared to current \code{'NUTS2016'} boundaries.
#' @param dat A Eurostat data frame downloaded with \code{\link{get_eurostat}}.
#' @export
#' @author Daniel Antal
#' @return An augmented and potentially relabelled data frame which 
#' contains all formerly \code{'NUTS2013'} definition geo labels in the 
#' \code{'NUTS2016'} vocabulary when only the code changed, but the 
#' boundary did not. It also contains some information on other geo labels
#' that cannot be brought to the current \code{'NUTS2016'} definition.
#' If not called before, the function will use the helper function
#'  \code{\link{check_nuts2013}}
#' @importFrom dplyr mutate filter rename arrange add_count
#' @importFrom dplyr left_join full_join anti_join
#' @importFrom stringr str_sub
#' @examples
#'  \dontrun{
#'    dat <- eurostat::tgs00026 %>%
#'      check_nuts2013() %>%
#'      harmonize_geo_code()
#'      
#'  #If check_nuts2013() is not called, the function will call it.    
#'   dat <- eurostat::tgs00026
#'      harmonize_geo_code(dat)    
#'  }

harmonize_geo_code <- function ( dat ) {
  
  ## For non-standard evaluation -------------------------------------
  change <- tmp <- geo <- nuts_level <- code13 <- code16 <- NULL
  remaining_eu_data <- resolution <- NULL
  
  ## Check if geo information is present ------------------------------
  if ( ! 'geo' %in% names(dat) ) {
    stop ("There is no 'geo' column in the inserted data. This is an error.")  } 

  unchanged_regions <- regional_changes_2016 %>% 
    filter ( change == 'unchanged' ) 
  
  changed_regions <- regional_changes_2016 %>% 
    filter ( change != 'unchanged' )
  
  nuts_2016_codes <- unique (regional_changes_2016$code16)
  nuts_2013_codes <- unique (regional_changes_2016$code13)
  # for easier debugging, this data will be re-assigned in each major
  # step as tmp2, tmp3...  Debugging is particulary difficult, because
  # not only the program code, but the underlying logic may have faults.
  
  if (! all(c("change", "code16", "code13") %in% names (dat)) ) {
    tmp <- dat %>% 
      check_nuts2013() 
  } else {
    tmp <- dat
  }
 
  #Find those codes that are missing from the correct NUTS2016 codes -------
  missing_2016_codes <- nuts_2016_codes [which (! nuts_2016_codes %in% tmp_eu_only$geo )]
  missing_2016_codes <- missing_2016_codes [ which (stringr::str_sub(missing_2016_codes, -3, -1) != "ZZZ")]
  missing_2016_codes <- missing_2016_codes [ which (stringr::str_sub(missing_2016_codes, -2, -1) != "ZZ")]
  
  #Sort them out by NUTS1 and NUTS2 levels 
  missing_nuts1_2016 <- missing_2016_codes [ which (nchar(missing_2016_codes) == 3)]
  missing_nuts2_2016 <- missing_2016_codes [ which (nchar(missing_2016_codes) == 4)]
  
  # Separating row that need to be corrected ----------------------------
  
  labelled_by_nuts_2016 <- tmp %>%
    filter ( geo %in% nuts_2016_codes )  # These are following NUTS2016
  
  join_by_vector <- names ( labelled_by_nuts_2016 %in% tmp )
  
  labelled_by_nuts_2013 <- tmp %>%
    anti_join ( labelled_by_nuts_2016, 
                by = names(tmp)) %>%
    filter ( geo %in% nuts_2013_codes )  # These are following NUTS2013
  
  message ( "There are ", nrow(labelled_by_nuts_2013), " regions that were changed",
            " in the transition to NUTS2016 and\nthe data frame uses their NUTS2013 geo codes.")
 
  labelled_by_other <- tmp %>%
    filter ( ! geo %in% nuts_2013_codes ) %>%
    filter ( ! geo %in% nuts_2016_codes ) %>% 
    mutate ( nuts2016  = FALSE )        # These are not in the correspondence table (non-EU)
  
  message ( "There are ", nrow(labelled_by_other), " regions that are not covered by the correspondence tables.")
  message ( "These are likely to be non-EU regions and their consistency cannot be checked.")
  
  
  if (  nrow ( labelled_by_other) + nrow ( labelled_by_nuts_2013 ) + nrow(labelled_by_nuts_2016) != nrow (dat)) {
    stop ( "Joining error Type I")
  }
 
  ## NUTS regions that are NUTS2013 coded but have NUTS2016 equivalents -----
  can_be_found  <- labelled_by_nuts_2013 %>%
    filter ( !is.na(code16 ) )
  
  recoded_regions <- can_be_found %>%
    filter ( grepl("recoded", change )) %>%
    mutate ( nuts2016 = TRUE )
  
  message ( "There are ", nrow(recoded_regions), " regions that only changed their geo labels.")
  message ( "[", recoded_regions %>%
              filter ( grepl ("relabelled", change)) %>%
              nrow(), " of these changed their names, too.]")
  
  other_cases <- can_be_found %>%
    anti_join ( recoded_regions,
                by = names ( can_be_found ) ) %>%
    mutate ( nuts2016 = FALSE )  # I think these are 'small changes' 
  
  if ( nrow(other_cases) + nrow(recoded_regions) != nrow(can_be_found) ) {
    stop ( "Joining error in NUTS2013 regions that can be found in NUTS2016")
  }
  
  ## Discontinued regions -----------------------------------------------
  
  cannot_be_found <- labelled_by_nuts_2013 %>%
    filter ( is.na(code16) ) %>%
    mutate ( nuts2016 = FALSE )
  
  if ( nrow ( can_be_found ) + nrow(cannot_be_found ) != nrow ( labelled_by_nuts_2013 )) {
    stop ("Joining error in NUTS2013 regions that can or cannot be found.")
  }
  
  ## First join all EU regions ----------------------------------------
  
  eu_joined <- labelled_by_nuts_2016 %>%
    mutate ( nuts2016 = TRUE ) %>%
    full_join ( recoded_regions, by = names ( recoded_regions ) ) %>%
    full_join ( other_cases, by = names ( other_cases )) %>%
    full_join ( cannot_be_found, by = (names ( cannot_be_found ))) 
  
  if ( nrow ( eu_joined %>%
              semi_join ( labelled_by_other, 
                          by = names (eu_joined) ))>0 ) {
    stop ( "Joining error between EU and non-EU regions")
  }
  
  ## Add non-EU regions  ----------------------------------------------
  
  all_regions <- labelled_by_other %>%
    full_join ( eu_joined, by = names ( eu_joined ))
 
  if ( nrow(all_regions %>%
            add_count ( geo, time, values ) %>%
            filter ( n>1 )) > 0 ) {
    stop("Joining error - there are duplicates in the data frame.")
  } 
 
 all_regions %>%
   dplyr::arrange(., time, geo, code16 )
  
}


