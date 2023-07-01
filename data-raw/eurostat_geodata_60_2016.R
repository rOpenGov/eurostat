## code to prepare `eurostat_geodata_60_2016` dataset goes here
library(giscoR)
library(tidyverse)

# Current names internal)
aa <- eurostat::eurostat_geodata_60_2016

from_gisco <- gisco_get_nuts(
  year = 2016, resolution = 60,
  epsg = 4326, update_cache = TRUE,
  verbose = TRUE
)

from_gisco$geo <- from_gisco$NUTS_ID

# End

eurostat_geodata_60_2016 <- from_gisco
unique(sf::st_is_valid(from_gisco))

# Sort by level and alphabetically
eurostat_geodata_60_2016 <- eurostat_geodata_60_2016 %>%
  arrange(LEVL_CODE, NUTS_ID)

usethis::use_data(eurostat_geodata_60_2016, overwrite = TRUE, compress = "xz")
