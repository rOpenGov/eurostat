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
#' @importFrom dplyr left_join mutate filter rename full_join
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
    filter ( change == 'unchanged')
  
  changed_regions <- regional_changes_2016 %>% 
    filter ( change != 'unchanged')
  
  nuts_2016_codes <- unique (regional_changes_2016$code16)
  # for easier debugging, this data will be re-assigned in each major
  # step as tmp2, tmp3...  Debugging is particulary difficult, because
  # not only the program code, but the underlying logic may have faults.
  
  tmp <- dat %>% 
    check_nuts2013()
  
  tmp_eu_only <- tmp  %>%
    filter ( change != "not_eu") # leave out non-EU regions.
  
  #Find those codes that are missing from the correct NUTS2016 codes
  missing_2016_codes <- nuts_2016_codes [which (! nuts_2016_codes %in% tmp_eu_only$geo )]
  missing_2016_codes <- missing_2016_codes [ which (stringr::str_sub(missing_2016_codes, -3, -1) != "ZZZ")]
  missing_2016_codes <- missing_2016_codes [ which (stringr::str_sub(missing_2016_codes, -2, -1) != "ZZ")]
  
  #Sort them out by NUTS1 and NUTS2 levels 
  missing_nuts1_2016 <- missing_2016_codes [ which (nchar(missing_2016_codes) == 3)]
  missing_nuts2_2016 <- missing_2016_codes [ which (nchar(missing_2016_codes) == 4)]
  
  # Separating labels that need to be corrected into tmp3 ----------------
  
  correctly_labelled_unchanged <- tmp %>%
    filter ( change == 'unchanged' )
  
  tmp_changed <- tmp %>%
    filter ( change != 'unchanged') 
  
  correctly_labelled_changed <- tmp_changed  %>% 
    filter ( geo %in% changed_regions$code16 )
  
  message ( "There are ", nrow(correctly_labelled_changed), " regions that were changed",
            " in the transition to NUTS2016 and\nthe data frame correctly represents their geo codes.")
  
  ## Finding incorrectly labelled NUTS1 geo labels --------------------
  incorrectlly_labelled_nuts1 <-  tmp_changed  %>%
    filter ( geo %in% changed_regions$code13 ) %>%
    filter ( nchar (as.character(geo)) == 3) 
  
  n_obsolete_nuts1 <- nrow ( incorrectlly_labelled_nuts1 )
  
  incorrectly_labelled_nuts1_2013 <- incorrectlly_labelled_nuts1 %>%
    left_join ( nuts_correspondence %>%
                  filter ( nuts_level == 1 ) %>%
                  mutate ( geo = code13 ) %>%
                  filter ( !is.na(geo)) %>%
                  select ( geo, code13, code16, change, resolution ), 
                by = c('geo', 'change'))
  
  discontinued_nuts1_regions <- incorrectly_labelled_nuts1_2013 %>%
    filter ( change == "discontinued")
  
  if ( n_obsolete_nuts1 > 0 ) {
    
    message ( "There are ", nrow ( n_obsolete_nuts1 ), 
              " observations that have an obsolete NUTS1 geo code." )
    
    message ( "Out of these ", nrow(discontinued_nuts1_regions), 
              " observations are in discontinued NUTS1 regions which cannot be ", 
              "\n attributed to the current NUTS2016 boundaries.")
    }
  
  incorrectly_labelled_nuts1_2013 <- incorrectly_labelled_nuts1_2013 %>%
    filter ( change != "discontinued")   %>%
    mutate ( problem_code = geo ) %>%
    mutate ( geo =  code16 )
  
  recoded_nuts1_2013 <- incorrectly_labelled_nuts1_2013 %>%
    filter ( change  == "recoded")
  
  not_recoded_nuts1_2013 <- incorrectly_labelled_nuts1_2013 %>%
    filter ( change  != "recoded")
  
  
  ## NUTS1 labels that are missing and which are found ------------------
  nuts1_missings <- missing_nuts1_2016  [ which ( missing_nuts1_2016 %in% incorrectly_labelled_nuts1_2013$geo)] 
  
  found_nuts1 <- incorrectly_labelled_nuts1_2013 %>%
    filter (  geo %in% missing_nuts1_2016  )
  
  if ( n_obsolete_nuts1 > 0 ) {
  message ( length(unique(found_nuts1$geo)), 
            " incorrectly labelled NUTS1 regions could be re-labelled")
  }
  ## Finding incorrectly labelled NUTS2 geo labels --------------------
  
  incorrectlly_labelled_nuts2 <-  tmp_changed  %>%
    filter ( geo %in% changed_regions$code13 ) %>%
    filter ( nchar (as.character(geo)) == 4) 
  
  n_obsolete_nuts2 <- nrow ( incorrectlly_labelled_nuts2 )
   
  incorrectly_labelled_nuts2_2013 <- incorrectlly_labelled_nuts2 %>%
    left_join ( nuts_correspondence %>%
                  filter ( nuts_level == 2 ) %>%
                  mutate ( geo = code13 ) %>%
                  filter ( !is.na(geo)) %>%
                  select ( geo, code13, code16, change, resolution ), 
                by = c('geo', 'change'))
  
  discontinued_nuts2_regions <- incorrectly_labelled_nuts2_2013 %>%
    filter ( change == "discontinued")
  
  if ( n_obsolete_nuts2 > 0 ) {
    
    message ( "There are ", n_obsolete_nuts2,
              " observations that have an obsolete NUTS2 geo code." )
    
    message ( "Out of these ", nrow(discontinued_nuts2_regions), 
                " observations are in discontinued NUTS2 regions which cannot be ", 
                "\n attributed to the current NUTS2016 boundaries.")
  }
  
  incorrectly_labelled_nuts2_2013 <- incorrectly_labelled_nuts2_2013 %>%
    filter ( change != "discontinued") %>%
    mutate ( problem_code = geo ) %>%
    mutate  ( geo =  code16)
  
  recoded_nuts2_2013 <- incorrectly_labelled_nuts2_2013 %>%
    filter ( change  == "recoded")
  
  not_recoded_nuts2_2013 <- incorrectly_labelled_nuts2_2013 %>%
    filter ( change  != "recoded")
  
  if ( n_obsolete_nuts2 > 0 ) {
    message ( "There are ", nrow(recoded_nuts2_2013), 
              " observations in NUTS2 regions that have new geo labels,\n", 
              "but their boundary did not change. These observations are", 
              " relabelled to the\nNUTS2016 definition.")
  }
  
  found_nuts2 <- recoded_nuts2_2013 %>%
    filter (  geo %in% missing_nuts2_2016  )

  ## If there are no corrections to made at all, return the original data frame ------------
  if ( length(unique(found_nuts2$geo)) + length(unique(found_nuts1$geo)) == 0) {
    message ( "There is no data found that can be further arranged.\nThe data is returned in its original format.")
    return (dat)
  } 
  
  ## If there are changes to be made, make them from here ------------------
  join_by <- names ( correctly_labelled_unchanged ) 
  join_by <- join_by [which ( join_by %in% names(correctly_labelled_changed) )]
  
  join_by2 <-  names ( correctly_labelled_unchanged )
  join_by2 <- join_by2 [which ( join_by2 %in% names(found_nuts1))]
  
  ## Add unchanged regions and changed, but correctly labelled ones
  so_far_joined <- full_join ( correctly_labelled_unchanged, 
                               correctly_labelled_changed, 
                               by = join_by ) %>%
    full_join ( found_nuts1, by = join_by2 ) 
  
  ## Add NUTS1 regions that were recoded, if there are any
  if ( nrow(found_nuts1)>0  ) {
    join_by3 <-  names ( so_far_joined )
    join_by3 <- join_by3 [which ( join_by3 %in% names(found_nuts1))] 
    
    so_far_joined <- so_far_joined  %>%
      full_join ( found_nuts2, by = join_by3 )
  }
  
  
  ## Add NUTS2 regions that were recoded, if there are any
  if ( nrow(found_nuts2)>0  ) {
    join_by4 <-  names ( so_far_joined )
    join_by4 <- join_by4 [which ( join_by4 %in% names(found_nuts2))] 
    
    so_far_joined <- so_far_joined  %>%
      full_join ( found_nuts2, by = join_by4 )
  }
  
  not_recoded <- rbind (  not_recoded_nuts2_2013, not_recoded_nuts2_2013 )
  


  ## The following geo codes will be changed using rules -------------
  additive_rules  <- c("FR24",
                          "FR26","FR43",
                          "FR23","FR25",
                          "FR22","FR30",
                          "FR21","FR41","FR42",
                          "FR51",
                          "FR52",
                          "FR53", "FR61", "FR63",
                          "FR62", "FR81",
                          "FR7",
                          "FR82",
                          "FR83",
                          "FRA", 
                          "PL11","PL33",
                          "PL3", 
                          "PL12", 
                          "IE023", "IE024", "IE025", 
                          "LT00", "LT00A", 
                          "UKM2",  
                          "UKM31", "UKM34", "UKM35", "UKM36",
                          "UKM24", "UKM32", "UKM33", "UKM37", "UKM38", 
                          "HU102", "HU101"
  )
  
  if ( nrow( not_recoded ) > 0 ) {
    message ( "There are ", nrow (remaining_eu_data), 
              " that could not be resolved with relabelling.")
    so_far_joined  <- rbind ( so_far_joined, not_recoded  ) 
    
    if ( sum ( additive_rules %in% not_recoded$problem_code ) > 0 ) {
      message ( "Out of these ", sum ( additive_rules %in% not_recoded$problem_code ), 
                " boundary changes that can be resolved by additive\ncorrespondence rules.")
    }
  }
  
  discontinued_nuts_regions <-   rbind ( discontinued_nuts1_regions, 
          discontinued_nuts2_regions)  
  
  if ( nrow (discontinued_nuts_regions) > 0 ) {
    so_far_joined  <- so_far_joined %>% 
      rbind (  discontinued_nuts_regions %>%
                 mutate ( problem_code = NA_character_ ) 
               ) 
  }
  
 so_far_joined
  
}


