#' @title Geospatial data of Europe from Gisco in 1:60 million scale from year 2016
#' @description Geospatial data of Europe from Gisco in 1:60 million scale from year 2016 
#' @format sf
#' \describe{
#'   \item{id}{Country code in the Eurostat database}
#'   \item{CNTRY_CODE}{Country code}
#'   \item{NUTS_NAME}{NUTS name in local language}
#'   \item{LEVL_CODE}{NUTS code}
#'   \item{FID}{Country code}
#'   \item{NUTS_ID}{NUTS code}
#'   \item{geometry}{geospatial information}
#'   \item{geo}{NUTS code}
#' }
#' @source \url{http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}
"eurostat_geodata_60_2016" 

## -- 2016
# library(sf)
# library(httr)
# 
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_03M_2016_4326_LEVL_0.geojson")
# n0 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_03M_2016_4326_LEVL_1.geojson")
# n1 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_03M_2016_4326_LEVL_2.geojson")
# n2 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_03M_2016_4326_LEVL_3.geojson")
# n3 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# eurostat_geodata_60_2016 <- rbind(n0,n1,n2,n3)
# eurostat_geodata_60_2016$geo <- eurostat_geodata_60_2016$NUTS_ID
# save(eurostat_geodata_60_2016, file = "./data/eurostat_geodata_60_2016.rda")


## -- 2013
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2013_4258_LEVL_0.geojson")
# n0 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2013_4258_LEVL_1.geojson")
# n1 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2013_4258_LEVL_2.geojson")
# n2 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2013_4258_LEVL_3.geojson")
# n3 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# eurostat_geodata_60_2013 <- rbind(n0,n1,n2,n3)
# save(eurostat_geodata_60_2013, file = "./data/eurostat_geodata_60_2013.rda")

## --2010
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2010_4258_LEVL_0.geojson")
# n0 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2010_4258_LEVL_1.geojson")
# n1 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2010_4258_LEVL_2.geojson")
# n2 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2010_4258_LEVL_3.geojson")
# n3 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# eurostat_geodata_60_2010 <- rbind(n0,n1,n2,n3)
# save(eurostat_geodata_60_2010, file = "./data/eurostat_geodata_60_2010.rda")

## --2006
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2006_4258_LEVL_0.geojson")
# n0 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2006_4258_LEVL_1.geojson")
# n1 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2006_4258_LEVL_2.geojson")
# n2 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# resp <- GET("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v1/geojson/NUTS_RG_60M_2006_4258_LEVL_3.geojson")
# n3 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)
# eurostat_geodata_60_2006 <- rbind(n0,n1,n2,n3)
# save(eurostat_geodata_60_2006, file = "./data/eurostat_geodata_60_2006.rda")
