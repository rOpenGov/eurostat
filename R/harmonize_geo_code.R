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

harmonize_geo_code <- function (dat) {
  
  ## For non-standard evaluation -------------------------------------
  . <- change  <- geo <- code13 <- code16 <- nuts_level <- NULL
  country_code <- n <- values <- time <- name <- resolution <- NULL
  
  dat <- mutate_if ( dat, is.factor, as.character)
  
  ## The data is not loaded into the global environment --------------
  
  regional_changes_2016 <- load_package_data(dataset = "regional_changes_2016")
  nuts_correspondence   <- load_package_data(dataset = "nuts_correspondence")
  
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
  
  "PL2" %in% all_regions_full_metadata$code13
  "PL2" %in% unique ( all_regions_full_metadata$code13)
  "UKN01" %in% nuts_2013_codes
  "UKN01" %in% nuts_2016_codes
  
  any ( is.na(nuts_2013_codes))
  
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
 
  if (! all(tmp_s$nuts_2013 && tmp_s$nuts_2016)) { stop ("Wrong selection of unchanged regions.") }
  
  
  tmp_s2 <- tmp_by_code13 %>%
    semi_join (  tmp_by_code16, 
                 by = names (tmp_by_code16)) # found in both (unchanged and relabelled)
  #must be equal!!!
  
  tmp_a1 <- tmp_by_code16 %>%
    anti_join (  tmp_by_code13, 
                 by = names(tmp_by_code13)) # not found in code13 (new regions)
  if ( ! all(tmp_a2$nuts_2013)) { stop ("Wrong selection of NUTS2013-only regions.") }
  
  
  tmp_a2 <- tmp_by_code13 %>%
    anti_join (  tmp_by_code16, 
                 by = names(tmp_by_code13)) # not found in code16 (changes)
  if ( ! all(tmp_a2$nuts_2013)) { stop ("Wrong selection of NUTS2013-only regions.") }
  
  tmp <- rbind ( tmp_s, tmp_a1, tmp_a2 )
  
  not_found_geo <- unique(dat$geo[! dat$geo %in% tmp$geo ])
  not_eu_regions <- not_found_geo[! substr(not_found_geo,1,2) %in% eu_countries$code]
  
  ## Checking if there are unmatched EU regions-------------------------
  
  not_found_eu_regions <-  not_found_geo[ substr(not_found_geo,1,2) %in% eu_countries$code]
 
  if ( length(not_found_eu_regions)>0) {
    stop ( "Some EU regions were not found in the correspondence table.")
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
  
  tmp2 <- rbind ( tmp, tmp_not_eu)
  

  ## Check if all original rows are handled correctly ------------------
  if (length(dat$geo [! dat$geo %in% tmp2$geo ])>0) {
    message (tmp2 %>% anti_join (dat))
    message (dat %>% anti_join (tmp2))
    stop ("Not all original rows were checked.")
  }

  eu_countries <- load_package_data(dataset = "eu_countries")

  eu_country_vector <-  unique ( substr(eu_countries$code, 1, 2) )
  

  if ( any(tmp2$change == 'not in EU - not controlled') ) {
    
    not_EU_country_vector <- tmp2 %>%
      filter ( tmp2$change == 'not in EU - not controlled' ) %>%
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
              "with alltogether ", not_eu_observations, " observations/rows.")
  }
  
  ## Reorder columns for readability -------------------------------
  
  tmp_left <- tmp2 %>% select ( geo,  time, values, code13, code16, name )
  tmp_right <- tmp2 %>% select ( -geo, -code13, -code16, -time, -values, -name )

  cbind ( tmp_left, tmp_right)
}
