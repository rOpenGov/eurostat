#' @title Geospatial data of Europe from Gisco in 1:60 million scale
#' @description Geospatial data of Europe from Gisco in 1:60 million scale 
#' @format sf
#' \describe{
#'   \item{id}{Country code in the Eurostat database}
#'   \item{CNTRY_CODE}{Country code}
#'   \item{NUTS_NAME}{NUTS name in local language}
#'   \item{LEVL_CODE}{NUTS code}
#'   \item{FID}{Country code}
#'   \item{NUTS_ID}{NUTS code}
#'   \item{geo}{NUTS code}
#'   \item{geometry}{geospatial information}
#' }
#' @source \url{http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}
"eurostat_geodata_60" 

# eurostat_geodata_60 <- get_eurostat_geospatial(resolution = 60, nuts_level = "all", output_class = "sf")
# save(eurostat_geodata_60, file = "./data/eurostat_geodata_60.rda")
