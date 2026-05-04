## code to prepare `eurostat_geodata_60_2016` dataset goes here
library(giscoR)
library(tidyverse)

# Current names internal)
from_gisco <- gisco_get_nuts(
  year = 2024, resolution = 60,
  epsg = 4326, update_cache = TRUE,
  verbose = TRUE
)

from_gisco$geo <- from_gisco$NUTS_ID
from_gisco$id <- from_gisco$NUTS_ID

# End

eurostat_geodata_60_2024 <- from_gisco
unique(sf::st_is_valid(from_gisco))

# Sort by level and alphabetically
eurostat_geodata_60_2024 <- eurostat_geodata_60_2024 %>%
  arrange(LEVL_CODE, NUTS_ID)

# Arrange names in proper order
sfcol <- attr(eurostat_geodata_60_2024, "sf_column")
rest <- c(
  "id", "LEVL_CODE", "NUTS_ID", "CNTR_CODE", "NAME_LATN",
  "NUTS_NAME", "MOUNT_TYPE", "URBN_TYPE", "COAST_TYPE",
  "FID", "geo"
)

reorder <- intersect(unique(c(rest, sfcol)), names(eurostat_geodata_60_2024))
eurostat_geodata_60_2024 <- eurostat_geodata_60_2024[, reorder]

usethis::use_data(eurostat_geodata_60_2024, overwrite = TRUE, compress = "xz")
