#' @title Download Geospatial Data from GISGO
#' @description Downloads either a simple features (sf), SpatialPolygonDataFrame or a
#'    data_frame preprocessed using
#'    \code{broom::tidy()}.
#' @param output_class A string. Class of object returned, 
#' either \code{sf} \code{simple features}, \code{df} (\code{data_frame}) or
#'    \code{spdf} (\code{SpatialPolygonDataFrame})
#' @param resolution Resolution of the geospatial data. One of
#'    "60" (1:60million),
#'    "20" (1:20million)
#'    "10" (1:10million)
#'    "03" (1:3million) or
#'    "01" (1:1million).
#' @param nuts_level Level of NUTS classification of the geospatial data. One of
#'    "0", "1", "2", "3" or "all" (mimics the original behaviour)
#' @param year NUTS release year. One of
#'    "2003", "2006", "2010", "2013" or "2016"
#' @param cache a logical whether to do caching. Default is \code{TRUE}. Affects 
#'        only queries from the bulk download facility.
#' @param update_cache a locigal whether to update cache. Can be set also with
#'        options(eurostat_update = TRUE)
#' @param cache_dir a path to a cache directory. The directory have to exist.
#'        The \code{NULL} (default) uses and creates
#'        'eurostat' directory in the temporary directory from
#'        \code{\link{tempdir}}. Directory can also be set with
#'        \code{option} eurostat_cache_dir.
#' @export
#' @details The data source URL is \url{http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}.
#' @author Markus Kainu <markuskainu@gmail.com>
#' @return a sf, data_frame or SpatialPolygonDataFrame.
#' @examples
#'   sf <- get_eurostat_geospatial(output_class = "sf", resolution = "60", nuts_level = "all")
#'   df <- get_eurostat_geospatial(output_class = "df", resolution = "20", nuts_level = "0")
#'   spdf <- get_eurostat_geospatial(output_class = "spdf", resolution = "10", nuts_level = "3")
#'  
get_eurostat_geospatial <- function(output_class="sf",resolution="60",
                                    nuts_level = "all", year = "2016",
                                    cache = TRUE, update_cache = FALSE,
				    cache_dir = NULL){
  # Check if you have internet connection
  internet_available <- curl::has_internet()
  if (!internet_available) stop("You have no internet connection, please reconnect!")
  
  eurostat_geodata_60_2016 <- NULL
  LEVL_CODE <- NULL
  data("eurostat_geodata_60_2016", envir = environment(), package = "eurostat")

  # Check resolution is of correct format
  resolution <- as.character(resolution)
  resolution <- gsub("^0+", "", resolution)
  if (!as.numeric(resolution) %in% c(1, 3, 10, 20, 60)) {
    stop("Resolution should be one of 01, 1, 03, 3, 10, 20, 60")
  }
  resolution <- gsub("^1$", "01", resolution)
  resolution <- gsub("^3$", "03", resolution)
  
  # Check output_class is of correct format
  if (!output_class %in% c("sf", "df", "spdf")) {
    stop("output_class should be one of 'sf', 'df' or 'spdf'")
  }
  
  # Check year is of correct format
  year <- as.character(year)
  if (!as.numeric(year) %in% c(2003, 2006, 2010, 2013, 2016)) {
    stop("Year should be one of 2003, 2006, 2010, 2013 or 2016")
  }
  
  if (as.numeric(year) == 2003 & as.numeric(resolution) == 60) {
    stop("NUTS 2003 is not provided at 1:60 million resolution. Try 1:1 million, 1:3 million, 1:10 million or 1:20 million")
  }

#   message("
# COPYRIGHT NOTICE
# 
# When data downloaded from this page 
# <http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
# is used in any printed or electronic publication, 
# in addition to any other provisions 
# applicable to the whole Eurostat website, 
# data source will have to be acknowledged 
# in the legend of the map and 
# in the introductory page of the publication 
# with the following copyright notice:
# 
# - EN: (C) EuroGeographics for the administrative boundaries
# - FR: (C) EuroGeographics pour les limites administratives
# - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
# 
# For publications in languages other than 
# English, French or German, 
# the translation of the copyright notice 
# in the language of the publication shall be used.
# 
# If you intend to use the data commercially, 
# please contact EuroGeographics for 
# information regarding their licence agreements.
#       ")
  
  if (resolution == "60" && year == 2016){
    
    if (nuts_level %in% c("all")){
      shp <- eurostat_geodata_60_2016 
    }
    if (nuts_level == "0") shp <- filter(eurostat_geodata_60_2016, LEVL_CODE == 0)
    if (nuts_level == "1") shp <- filter(eurostat_geodata_60_2016, LEVL_CODE == 1)
    if (nuts_level == "2") shp <- filter(eurostat_geodata_60_2016, LEVL_CODE == 2)
    if (nuts_level == "3") shp <- filter(eurostat_geodata_60_2016, LEVL_CODE == 3)
    
    if (output_class == "df"){
      nuts_sp <- as(shp, "Spatial")
      nuts_sp$id <- row.names(nuts_sp)
      nuts_ff <- broom::tidy(nuts_sp)
      shp <- left_join(nuts_ff,nuts_sp@data)
    }
    if (output_class == "spdf"){
      shp <- as(shp, "Spatial")
    }
    
  } else {
  
  if (cache){
  
    # check option for update
    update_cache <- update_cache | getOption("eurostat_update", FALSE)
    
    # get cache directory
    if (is.null(cache_dir)){
      cache_dir <- getOption("eurostat_cache_dir", NULL)
      if (is.null(cache_dir)){
        cache_dir <- file.path(tempdir(), "eurostat")
        if (!file.exists(cache_dir)) dir.create(cache_dir)
      }
    } else {
      if (!file.exists(cache_dir)) {
        stop("The folder ", cache_dir, " does not exist")
      }
    }
    
    # cache filename
    cache_file <- file.path(cache_dir,
                            paste0(
                              output_class, resolution, nuts_level, year, ".RData")
    )
  }
  
  # if cache = FALSE or update or new: dowload else read from cache
  if (!cache || update_cache || !file.exists(cache_file)){
  
    if (nuts_level %in% c("0","all")){
      url <- paste0("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_",resolution,"M_",year,"_4326_LEVL_0.geojson")
      resp <- GET(url)
      if (httr::http_error(resp)) { 
        stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
      } else {
        nuts0 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)  
        } 
    }
    if (nuts_level %in% c("1","all")){
      url <- paste0("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_",resolution,"M_",year,"_4326_LEVL_1.geojson")
      resp <- GET(url)
      if (httr::http_error(resp)) {
        stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
      } else {
        nuts1 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)  
        }
    }    
    if (nuts_level %in% c("2","all")){
      resp <- GET(paste0("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_",resolution,"M_",year,"_4326_LEVL_2.geojson"))
      if (httr::http_error(resp)) { 
        stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
      } else {
        nuts2 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)  
        }
    }
    if (nuts_level %in% c("3","all")){
      resp <- GET(paste0("http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_",resolution,"M_",year,"_4326_LEVL_3.geojson"))
      if (httr::http_error(resp)) { 
        stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
      } else {
        nuts3 <- st_read(content(resp, as="text"), stringsAsFactors = FALSE, quiet = TRUE)    
        }
    }
    
    if (nuts_level %in% c("all")){
      shp <- rbind(nuts0,nuts1,nuts2,nuts3)
    }
    
    if (nuts_level == "0") shp <- nuts0
    if (nuts_level == "1") shp <- nuts1
    if (nuts_level == "2") shp <- nuts2
    if (nuts_level == "3") shp <- nuts3
    
    if (output_class == "df"){
      nuts_sp <- as(shp, "Spatial")
      nuts_sp$id <- row.names(nuts_sp)
      nuts_ff <- broom::tidy(nuts_sp)
      shp <- left_join(nuts_ff,nuts_sp@data)
    }
    if (output_class == "spdf"){
      shp <- as(shp, "Spatial")
    }
    
  }
  }

  if (resolution != "60" & year != 2016){
  if (cache & file.exists(cache_file)) {
    cf <- path.expand(cache_file)
    message(paste("Reading cache file", cf))
    load(file = cache_file)
    if (output_class == "sf") message(paste("sf at resolution 1:", resolution, " from year ",year," read from cache file: ", cf))
    if (output_class == "df") message(paste("data_frame at resolution 1:", resolution, " from year ",year," read from cache file: ", cf))
    if (output_class == "spdf") message(paste("SpatialPolygonDataFrame at resolution 1:", resolution, " from year ",year," read from cache file: ", cf))
  }
  
  # if update or new: save
  if (cache && (update_cache || !file.exists(cache_file))){
    save(shp, file = cache_file)
    if (output_class == "sf") message(paste("sf at resolution 1:", resolution, " cached at: ", path.expand(cache_file)))
    if (output_class == "df") message(paste("data_frame at resolution 1:", resolution, " cached at: ", path.expand(cache_file)))
    if (output_class == "spdf") message(paste("SpatialPolygonDataFrame at resolution 1:", resolution, " cached at: ", path.expand(cache_file)))
  }
  }
  
  if (resolution == "60" & year == 2016){
    if (output_class == "sf") message(paste("sf at resolution 1:60 read from local file"))
    if (output_class == "df") message(paste("data_frame at resolution 1:60 read from local file"))
    if (output_class == "spdf") message(paste("SpatialPolygonDataFrame at resolution 1:60 read from local file"))
    
  }
  
#   message("
# # --------------------------
# HEADS UP!!
# 
# Function get_eurostat_geospatial now returns the data in 'sf'-class (simple features) 
# by default which is different from previous behaviour's 'SpatialPolygonDataFrame'. 
# 
# If you prefer either 'SpatialPolygonDataFrame' or 
# fortified 'data_frame' (for ggplot2::geom_polygon), 
# please specify it explicitly to 'output_class'-argument!
# 
# # --------------------------          
#           ")
  
  # Adding a `geo` column for easier joins with dplyr 
  shp$geo <- shp$NUTS_ID
  return(shp)

}
