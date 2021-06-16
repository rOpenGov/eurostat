#' @title Harmonize NUTS region codes that changed with the \code{NUTS2016} definition
#' @description Eurostat mixes \code{NUTS2013} and \code{NUTS2016} geographic
#' label codes in the \code{'geo'} column, which creates time-wise comparativity issues.
#' This function checks if you data is affected by this problem and gives
#' information on what to do.
#' @param dat A Eurostat data frame downloaded with \code{\link{get_eurostat}}
#' @export
#' @author Daniel Antal
#' @return An augmented data frame that explains potential problems and 
#' possible solutions.
#' @importFrom dplyr mutate filter rename mutate_if case_when distinct
#' @importFrom dplyr left_join full_join anti_join add_count semi_join
#' @examples
#'  \dontrun{
#'    dat <- eurostat::tgs00026
#'    harmonize_geo_code(dat)
#'  }
#'  
#' @importFrom dplyr mutate filter rename mutate_if case_when distinct
#' @importFrom dplyr left_join full_join anti_join add_count semi_join
#' @importFrom utils data
#' @importFrom magrittr %>%
#'  
#' @export

harmonize_geo_code <- function (dat) {
  
  ## For non-standard evaluation -------------------------------------
  . <- change  <- geo <- code13 <- code16 <- nuts_level <- NULL
  country_code <- n <- values <- time <- name <- resolution <- NULL
  
  dat <- mutate_if ( dat, is.factor, as.character)
  
  ## The data is not loaded into the global environment ---------------
  
  #regional_changes_2016 <- eurostat:::load_package_data(dataset = "regional_changes_2016")
  #nuts_correspondence   <- eurostat:::load_package_data(dataset = "nuts_correspondence")

  nuts_correspondence <- regional_changes_2016 <- eu_countries <- NULL

  utils::data("nuts_correspondence", package = "eurostat", envir = environment())
  utils::data("regional_changes_2016", package = "eurostat", envir = environment())
  utils::data("eu_countries", package = "eurostat", envir = environment())  
  
  ## Creating constants -----------------------------------------------
  regions_in_correspondence <- unique(c(nuts_correspondence$code13, nuts_correspondence$code16))
  regions_in_correspondence <- sort(regions_in_correspondence [!is.na(regions_in_correspondence)])

  unchanged_regions <- regional_changes_2016 %>% 
    filter ( change == 'unchanged' )
  
  # The Eurostat correspondence table had a duplicate entry.  It may
  # re-occur later and this code may help finding it.
  # nuts_correspondence_duplicates <- nuts_correspondence %>%
  #  filter ( !is.na(code13 )) %>%
  #  add_count ( code13 ) %>% filter ( n > 1 )
  
  ## Changed regions to be looked up by their NUTS2016 codes -----------
  regional_changes_by_2016 <- nuts_correspondence %>%
    mutate ( geo = code16 ) %>% 
    filter ( !is.na(code16) ) %>%
    select ( -geo ) %>%
    distinct ( code13, code16, name, nuts_level, change, resolution) 
  
  # Regions may be duplicated in case their NUTS2016 and NUTS2013 are the same
  
  ## adding those that have no equivalent in the previous group
  ## some regions have to be identified by their old and new codes -----
  regional_changes_by_2013 <- nuts_correspondence %>%
    mutate ( geo = code13 ) %>% 
    filter ( !is.na(code13) ) %>%
    select ( -geo ) %>%
    distinct ( code13, code16, name, nuts_level, change, resolution)
  
  ## Join the regions by both NUTS definitions -----------------------
  
  all_regional_changes <- regional_changes_by_2016 %>%
    full_join ( regional_changes_by_2013, 
                by = c("code13", "code16", "name", "nuts_level",
                       "change", "resolution"))
  
  
  ## Check for potential duplicates ----------------------------------
  duplicates <- all_regional_changes %>% 
    add_count ( code13, code16  ) %>%
    filter ( n > 1 )
  
  if ( nrow(duplicates) > 0 ) {
    stop ("There are duplicates in the correspondence table.")
  }

  all_regions_full_metadata <- unchanged_regions %>%
    mutate ( resolution = NA_character_ ) %>% 
    rbind ( all_regional_changes ) 
  
  nuts_2013_codes <- unique (all_regions_full_metadata$code13)#[!is.na(all_regions_full_metadata$code13)]
  nuts_2016_codes <- unique (all_regions_full_metadata$code16)#[!is.na(all_regions_full_metadata$code16)]
  nuts_2013_codes <- nuts_2013_codes[!is.na(nuts_2013_codes)]
  nuts_2016_codes <- nuts_2016_codes[!is.na(nuts_2016_codes)]

  tmp_by_code16 <- dat %>%
    mutate ( geo = as.character(geo)) %>%
    filter ( geo %in% all_regions_full_metadata$code16 ) %>%
    left_join (  all_regions_full_metadata %>%
                  dplyr::rename ( geo = code16 ), 
                by = "geo") %>%
    mutate ( code16 = geo ) %>%
    mutate ( nuts_2016 = geo %in% nuts_2016_codes ) %>%
    mutate ( nuts_2013 = geo %in% nuts_2013_codes )
  
  tmp_by_code13 <- dat %>%
    mutate ( geo = as.character(geo)) %>%
    filter ( geo %in% all_regions_full_metadata$code13 ) %>%
    left_join (  all_regions_full_metadata %>%
                  dplyr::rename ( geo = code13 ), 
                by = "geo") %>%
    mutate ( code13 = geo ) %>%
    mutate ( nuts_2016 = geo %in% nuts_2016_codes, 
             nuts_2013 = geo %in% nuts_2013_codes)
  
  message ( "In this data frame ", nrow(tmp_by_code16), 
            " observations are coded with the current NUTS2016\ngeo labels and ", 
            nrow ( tmp_by_code13), " observations/rows have NUTS2013 historical labels.")
  
  tmp_s <- tmp_by_code16 %>%
    semi_join (  tmp_by_code13, 
                 by = names ( tmp_by_code13)) # found in both (unchanged and relabelled)
 
  if (! all(tmp_s$nuts_2013 & tmp_s$nuts_2016)) { stop ("Wrong selection of unchanged regions.") }
  
  
  tmp_s2 <- tmp_by_code13 %>%
    semi_join (  tmp_by_code16, 
                 by = names (tmp_by_code16)) # found in both (unchanged and relabelled)
  #must be equal!!!
  
  tmp_a1 <- tmp_by_code16 %>%
    anti_join (  tmp_by_code13, 
                 by = names(tmp_by_code13)
                 ) # not found in code13 (new regions)
  if ( any(tmp_a1$nuts_2013) ) { 
    stop ("Wrong selection of NUTS2013-only regions.") }
 
  tmp_a2 <- tmp_by_code13 %>%
    anti_join (  tmp_by_code16, 
                 by = names(tmp_by_code13)
                 ) # not found in code16 (changes)
  if ( any(tmp_a2$nuts_2016) ) { 
    stop ("Wrong selection of NUTS2013-only regions.") }
  
  tmp2 <- rbind ( tmp_s, tmp_a1, tmp_a2 )
  
  not_found_geo <- unique(dat$geo[! dat$geo %in% tmp2$geo ])
  not_eu_regions <- not_found_geo[! substr(not_found_geo,1,2) %in% eu_countries$code]
  
  ## Checking if there are unmatched EU regions-------------------------
  
  not_found_eu_regions <-  not_found_geo[ substr(not_found_geo,1,2) %in% eu_countries$code]
 
  if ( length(not_found_eu_regions)>0 ) {
       if ( any( not_found_eu_regions %in% c("SI02", "SI01",
                                             "EL1", "EL2", 
                                             "UKI1", "UK2"))) {
      message ( "Some or all of these regions use codes earlier than NUTS2013 definition.")
       }
    
    if ( any(grepl("XX", not_found_eu_regions ))) {
      message ( "Some or all of these regions use data that cannot be connected to a regional unit.")
    }
  
    tmp_not_found <- dat %>%
      filter ( geo %in% not_found_eu_regions ) %>%
      mutate ( nuts_level = nchar(geo)-2, 
               name   = NA_character_,
               code13 = NA_character_, 
               code16 = NA_character_,
               nuts_2016 = FALSE, 
               nuts_2013 = FALSE) %>%
      mutate ( code13 = case_when ( 
        geo == "EL1"  ~ "EL5", 
        geo == "EL2"  ~ "EL6", 
        geo == "SI01" ~ "SI03", 
        geo == "SI02" ~ "SI04", 
        geo %in% c("UKI1", "UKI2") ~ NA_character_,
        substr(geo,3,4) == "XX" ~ geo,
        TRUE ~ NA_character_ )) %>% 
      mutate ( code16 = case_when ( 
        geo == "EL1" ~  "EL5", 
        geo == "EL2"  ~ "EL6", 
        geo == "SI01" ~ "SI03", 
        geo == "SI02" ~ "SI04",
        geo %in% c("UKI1", "UKI2") ~ NA_character_,
        substr(geo,3,4) == "XX" ~ geo,
        TRUE ~ NA_character_) ) %>%
      mutate ( name = dplyr::case_when ( 
        geo == "SI01" ~ "Vzhodna Slovenija", 
        geo == "SI02" ~ "Zahodna Slovenija",
        geo == "EL1" ~ "Voreia Ellada",
        geo == "EL2" ~ "Kentriki Ellada",
        geo %in% c("UKI1", "UKI2") ~ NA_character_,
        substr(geo,3,4) == "XX" ~ "data not related to any territorial unit",
        TRUE ~ NA_character_)) %>%
      mutate ( change  = dplyr::case_when ( 
        geo %in% c("UKI1", "UKI2") ~ "split in 2013 (NUTS2010 coding)",
        geo %in% c("EL1", "EL2")   ~ "boundary shift in 2013 (NUTS2010 coding)", 
        geo %in% c("SI01", "SI02") ~ "boundary shift in 2013 (NUTS2010 coding)", 
        substr(geo,3,4) == "XX" ~ "data not related to any territorial unit",
        TRUE ~ NA_character_ )) %>%
      mutate ( resolution = "You should control these changes and see how they affect your data.")
    
    still_not_found_vector <- tmp_not_found %>%
      filter ( is.na(code16)) %>%
      select (geo) %>% unlist () %>%
      unique() 
    
    if ( length(still_not_found_vector)>0) {
      warning ( "The following geo labels were not found in the correspondence table:", 
                paste(still_not_found_vector, collapse = ", "), ".")
    }

    tmp2 <- rbind ( tmp2, tmp_not_found )
    
  }
  
  ## Adding columns for non-EU regions ----------------------------------
  tmp_not_eu <- dat %>%
    filter ( geo %in% not_eu_regions ) %>%
    mutate ( nuts_level = nchar(geo)-2, 
             change = "not in EU - not controlled", 
             resolution = "check with national authorities", 
             name = NA_character_,
             code13 = NA_character_, 
             code16 = NA_character_,
             nuts_2016 = FALSE, 
             nuts_2013 = FALSE)
  
  tmp3 <- rbind ( tmp2, tmp_not_eu )
  

  ## Check if all original rows are handled correctly ------------------
  if ( length(dat$geo [! dat$geo %in% tmp3$geo ])>0 ) {
    
    unique ( dat$geo [! dat$geo %in% tmp3$geo ])
    
    message (tmp3 %>% anti_join (dat))
    message (dat %>% anti_join (tmp3))
    stop ("Not all original rows were checked.")
  }

  #eu_countries <- load_package_data(dataset = "eu_countries")
  utils::data(eu_countries, package ="eurostat", envir = environment())
  eu_country_vector <-  unique ( substr(eu_countries$code, 1, 2) )
  

  if ( any(tmp3$change == 'not in EU - not controlled') ) {
    
    not_EU_country_vector <- tmp3 %>%
      filter ( change == 'not in EU - not controlled' ) %>%
      select ( geo ) 
    
    not_eu_observations <- nrow (not_EU_country_vector)
    
    not_EU_country_vector <- not_EU_country_vector %>%
      unlist() %>% substr(., 1,2) %>% sort () %>%
      unique ()
     ## The correspondence table only covers EU regions.
    message ( "Not checking for regional label consistency in non-EU countries.\n",
              "In this data frame not controlled countries: ", 
              paste (not_EU_country_vector,
                     collapse = ", "), " \n", 
              "with altogether ", not_eu_observations, " observations/rows.")
  }
  
  ## Reorder columns for readability -------------------------------
  
  tmp_left  <- tmp3 %>% select ( geo,  time, values, code13, code16, name )
  tmp_right <- tmp3 %>% select ( -geo, -code13, -code16, -time, -values, -name )

  cbind ( tmp_left, tmp_right)
}
