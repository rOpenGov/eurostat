library ( readxl )
library ( purrr )
library ( dplyr )
library ( tidyr )
#This file reads in the NUTS correspondence table published by 
#Eurostat ---------------------------------------------------

tf <- tempfile(fileext = ".xlsx")
download.file(url = 'https://ec.europa.eu/eurostat/documents/345175/629341/NUTS2013-NUTS2016.xlsx', 
              destfile = tf,  mode = 'wb'  )

regions <- readxl::read_excel( tf,
                   sheet = 'NUTS2013-NUTS2016', 
                   skip = 1, col_names = T) %>%
  select (1:12) %>%
  purrr::set_names(., c("rowid", "code13", "code16", 
                        "country_name", 'nuts1_name', 
                        'nuts2_name', 'nuts3_name',
                        'change', 'nuts_level',
                        'sort_countries','sort_13' , 'sort_16')
                   ) %>%
  mutate ( name = case_when ( 
    !is.na(nuts1_name)   ~ nuts1_name, 
    !is.na(nuts2_name)   ~ nuts2_name,
    !is.na(nuts3_name)   ~ nuts3_name, 
    !is.na(country_name) ~ country_name,
    TRUE ~ NA_character_))

nuts1_correspondence <- readxl::read_excel( 
  #file.path('data-raw', 'NUTS2013-NUTS2016.xlsx'),
  #file.path('.', 'NUTS2013-NUTS2016.xlsx'),
  file.path(tf),    
  sheet = 'Correspondence NUTS-1', 
  skip = 0 , col_names = T) %>%
  purrr::set_names ( ., c("code13", "code16", 
                           "name", 
                           "change", "resolution")) %>%
  mutate_if ( is.factor, as.character ) %>%
  mutate ( nuts_level = 1 )


nuts2_correspondence <- readxl::read_excel( 
  #file.path('data-raw', 'NUTS2013-NUTS2016.xlsx'),
  file.path(tf),      
  sheet = 'Correspondence NUTS-2', 
  skip = 0 , col_names = T) %>%
  select ( 1:5 ) %>%
  purrr::set_names ( ., c("code13", "code16", 
                          "name",
                          "change", "resolution")) %>%
  filter ( is.na(code13) + is.na(code16) < 2) %>%
  mutate ( nuts_level = 2 )

nuts_correspondence <- rbind ( 
  nuts1_correspondence, 
  nuts2_correspondence ) %>%
  select ( code13, code16, name, nuts_level, change, resolution )

nuts_2016_codes <- unique (regions$code16)

##In these cases, the code13 == code16
unchanged_regions <- regions %>%
  filter ( is.na(change)) %>%
  fill ( nuts1_name ) %>%
  fill ( nuts2_name ) %>%
  select ( code13, code16, name, nuts_level, change  ) %>%
  mutate ( change = 'unchanged')

## In these cases code13 != code16
changed_regions <- regions %>%
  filter ( !is.na(change)) %>%
  fill ( nuts1_name ) %>%
  fill ( nuts2_name ) %>%
  select ( code13, code16, name, nuts_level, change )

## Regional changes

regional_changes_2016 <- rbind ( changed_regions, unchanged_regions )

discontinued_regions  <- changed_regions %>%
  filter ( change == "discontinued")

message("Save changed regions")
usethis::use_data(regional_changes_2016,
                  nuts_correspondence, overwrite = TRUE, 
                  internal = FALSE)

