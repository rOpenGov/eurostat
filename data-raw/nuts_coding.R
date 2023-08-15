library(readxl)
library(purrr)
library(dplyr)
library(tidyr)
# This file reads in the NUTS correspondence table published by
# Eurostat ---------------------------------------------------

tf <- tempfile(fileext = ".xlsx")
download.file(
  url = "https://ec.europa.eu/eurostat/documents/345175/629341/NUTS2013-NUTS2016.xlsx",
  destfile = tf, mode = "wb"
)

regional_changes_2016 <- readxl::read_excel(tf,
  sheet = "NUTS2013-NUTS2016",
  skip = 1, col_names = TRUE
) %>%
  select(1:12) %>%
  purrr::set_names(., c(
    "rowid", "code13", "code16",
    "country_name", "nuts1_name",
    "nuts2_name", "nuts3_name",
    "change", "nuts_level",
    "sort_countries", "sort_13", "sort_16"
  )) %>%
  mutate(name = case_when(
    !is.na(nuts1_name) ~ nuts1_name,
    !is.na(nuts2_name) ~ nuts2_name,
    !is.na(nuts3_name) ~ nuts3_name,
    !is.na(country_name) ~ country_name,
    TRUE ~ NA_character_
  ))

nuts1_correspondence <- readxl::read_excel(
  tf,
  sheet = "Correspondence NUTS-1",
  skip = 0, col_names = TRUE
) %>%
  purrr::set_names(., c(
    "code13", "code16",
    "name",
    "change", "resolution"
  )) %>%
  mutate_if(is.factor, as.character) %>%
  mutate(nuts_level = 1) %>%
  filter(name != "Centre-Est") # appears to be a duplicate and incorrect row, given that FR7 is also marked as recoded to FRK

warning("FR7 - Centre-Est appears to be an errorneous line and it is removed from the correspondence table.")

nuts2_correspondence <- readxl::read_excel(
  tf,
  sheet = "Correspondence NUTS-2",
  skip = 0, col_names = TRUE
) %>%
  select(1:5) %>%
  purrr::set_names(., c(
    "code13", "code16",
    "name",
    "change", "resolution"
  )) %>%
  filter(is.na(code13) + is.na(code16) < 2) %>%
  mutate(nuts_level = 2)

nuts3_correspondence <- readxl::read_excel(
  tf,
  sheet = "Correspondence NUTS-3",
  skip = 0, col_names = TRUE
) %>%
  select(1:5) %>%
  purrr::set_names(., c(
    "code13", "code16",
    "name",
    "change", "resolution"
  )) %>%
  filter(is.na(code13) + is.na(code16) < 2) %>%
  mutate(nuts_level = 2)


nuts_correspondence <- rbind(
  nuts1_correspondence,
  nuts2_correspondence
) %>%
  rbind(nuts3_correspondence) %>%
  select(code13, code16, name, nuts_level, change, resolution)

nuts_2016_codes <- unique(regional_changes_2016$code16)

## In these cases, the code13 == code16 ------------------------------
unchanged_regions <- regions %>%
  filter(is.na(change)) %>%
  fill(nuts1_name) %>%
  fill(nuts2_name) %>%
  select(code13, code16, name, nuts_level, change) %>%
  mutate(change = "unchanged")

## In these cases code13 != code16 ----------------------------------
changed_regions <- regions %>%
  filter(!is.na(change)) %>%
  fill(nuts1_name) %>%
  fill(nuts2_name) %>%
  select(code13, code16, name, nuts_level, change)

nuts_2016_codes <- unique(regional_changes_2016$code16)[!is.na(regional_changes_2016$code16)]
nuts_2013_codes <- unique(regional_changes_2016$code13)[!is.na(regional_changes_2016$code13)]
all_region_codes <- unique(c(nuts_2016_codes, nuts_2013_codes))

changed_region_codes <- all_region_codes[!all_region_codes %in% unchanged_regions$code16]
changed_region_codes <- sort(changed_region_codes[!is.na(changed_region_codes)])

regions_in_correspondence <- unique(c(nuts_correspondence$code13, nuts_correspondence$code16))
regions_in_correspondence <- sort(regions_in_correspondence[!is.na(regions_in_correspondence)])

if (length(
  changed_region_codes[!changed_region_codes %in% regions_in_correspondence]
) > 0) {
  message("Problem with the following regional geo labels:")
  message(changed_region_codes[!changed_region_codes %in% regions_in_correspondence])
  stop("They cannot be found in the correspondence table")
}


## Consistency check ----------------------------------------
## The name field is inconsistent in two sheets, at least FR7 is not consistent
regions_in_correspondence <- regions_in_correspondence[!is.na(regions_in_correspondence)]

nuts2013_in_changed <- unique(changed_regions$code13)
nuts2013_in_changed <- nuts2013_in_changed[!is.na(nuts2013_in_changed)]

nuts2016_in_changed <- unique(changed_regions$code16)
nuts2016_in_changed <- nuts2016_in_changed[!is.na(nuts2016_in_changed)]

all(nuts2013_in_changed %in% regions_in_correspondence)
all(nuts2016_in_changed %in% regions_in_correspondence)

nuts2013_in_changed[!nuts2013_in_changed %in% regions_in_correspondence]
nuts2016_in_changed[!nuts2016_in_changed %in% regions_in_correspondence]

## Consistency II ----------------------------------------------------

all_nuts_codes <- unique(c(nuts_2013_codes, nuts_2016_codes))

only_in_correspondence <- regions_in_correspondence[regions_in_correspondence %in% all_nuts_codes]

only_13 <- nuts_correspondence %>%
  filter(code13 %in% only_in_correspondence)

only_16 <- nuts_correspondence %>%
  filter(code16 %in% only_in_correspondence)

only <- full_join(only_13, only_16) # they are unique


## Changed regions to be looked up by their NUTS2016 codes -----------
regional_changes_by_2016 <- nuts_correspondence %>%
  mutate(geo = code16) %>%
  filter(!is.na(code16))

## adding those that have no equivalent in the previous group
## some regions have to be identified by their old and new codes -----
regional_changes_by_2013 <- nuts_correspondence %>%
  mutate(geo = code13) %>%
  filter(!is.na(code13))

## Region can be found by new or old NUTS code -----------------------

all_regional_changes <- regional_changes_by_2016 %>%
  full_join(regional_changes_by_2013,
    by = c(
      "code13", "code16", "name", "nuts_level",
      "change", "resolution", "geo"
    )
  )


all_regional_changes %>%
  add_count(code13, code16, name, nuts_level, change, resolution, geo) %>%
  filter(n > 1)

## Regional changes ------------------------------------------------

regional_changes_2016 <- rbind(changed_regions, unchanged_regions)

discontinued_regions <- changed_regions %>%
  filter(change == "discontinued")


## ----------------------------------------------------------------
message("Save changed regions")
usethis::use_data(regional_changes_2016,
  nuts_correspondence,
  overwrite = TRUE,
  internal = FALSE
)
