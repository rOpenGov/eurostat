#' @title Download Geospatial Data from CISGO
#' @description Downloads either a simple features (sf), SpatialPolygonDataFrame or a data_frame preprocessed using
#'    \code{broom::tidy()}.
#' @param output_class A string. Class of object returned, 
#' either \code{sf} \code{simple features}, \code{df} (\code{data_frame}) or
#'    \code{spdf} (\code{SpatialPolygonDataFrame})
#' @param resolution Resolution of the geospatial data. One of
#'    "60" (1:60million), "20" (1:20million), "10" (1:10million), "01" (1:1million),
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
#' @author Markus Kainu <markuskainu@@gmail.com>
#' @return a sf, data_frame or SpatialPolygonDataFrame.
#' @examples
#'  \dontrun{
#'    library(sf)
#'    library(dplyr)
#'    lp <- get_eurostat_geospatial(output_class = "sf", resolution = "60")
#'    lp %>%  select(NUTS_ID) %>%  plot()
#'    lp <- get_eurostat_geospatial(output_class = "spdf", resolution = "60")
#'    spplot(lp, "STAT_LEVL_")
#'    # or
#'    lp <- get_eurostat_geospatial(output_class = "df", resolution = "60")
#'    ggplot(lp, aes(x=long,y=lat,group=group,fill=STAT_LEVL_),color="white") + geom_polygon()
#'  }
#'  
get_eurostat_geospatial <- function(output_class="sf",resolution="60", 
                                    cache = TRUE, update_cache = FALSE, cache_dir = NULL){
  
  # Check resolution is of correct format
  resolution <- as.character(resolution)
  resolution <- gsub("^0+", "", resolution)
  if (!as.numeric(resolution) %in% c(1, 10, 20, 60)) {
    stop("Resolution should be one of 01, 1, 10, 20, 60")
  }
  resolution <- gsub("^1$", "01", resolution)
  
  
  message("
COPYRIGHT NOTICE

When data downloaded from this page 
<http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
is used in any printed or electronic publication, 
in addition to any other provisions 
applicable to the whole Eurostat website, 
data source will have to be acknowledged 
in the legend of the map and 
in the introductory page of the publication 
with the following copyright notice:

- EN: (C) EuroGeographics for the administrative boundaries
- FR: (C) EuroGeographics pour les limites administratives
- DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen

For publications in languages other than 
English, French or German, 
the translation of the copyright notice 
in the language of the publication shall be used.

If you intend to use the data commercially, 
please contact EuroGeographics for 
information regarding their licence agreements.
          ")
  
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
                              output_class, resolution, ".RData")
    )
  }
  
  # if cache = FALSE or update or new: dowload else read from cache
  if (!cache || update_cache || !file.exists(cache_file)){
    
    if (output_class == "sf"){
      load(url(paste0("https://github.com/rOpenGov/eurostat_geodata/raw/master/rdata/NUTS_RG_",
                      resolution,
                      "M_2013_sf.RData")))
    }
    if (output_class == "df"){
      load(url(paste0("https://github.com/rOpenGov/eurostat_geodata/raw/master/rdata/NUTS_RG_",
                      resolution,
                      "M_2013_df.RData")))
      shp <- shp[order(shp$order),] 
    }
    if (output_class == "spdf"){
      load(url(paste0("https://github.com/rOpenGov/eurostat_geodata/raw/master/rdata/NUTS_RG_",
                      resolution,
                      "M_2013_spdf.RData")))
    }
    
  }
  
  if (cache & file.exists(cache_file)) {
    cf <- path.expand(cache_file)
    message(paste("Reading cache file", cf))
    # y <- readRDS(cache_file)
    load(file = cache_file)
    if (output_class == "sf") message(paste("sf at resolution 1:", resolution, " read from cache file: ", cf))
    if (output_class == "df") message(paste("data_frame at resolution 1:", resolution, " read from cache file: ", cf))
    if (output_class == "spdf") message(paste("SpatialPolygonDataFrame at resolution 1:", resolution, " read from cache file: ", cf))
  }
  
  # if update or new: save
  if (cache && (update_cache || !file.exists(cache_file))){
    save(shp, file = cache_file)
    if (output_class == "sf") message(paste("sf at resolution 1:", resolution, " cached at: ", path.expand(cache_file)))
    if (output_class == "df") message(paste("data_frame at resolution 1:", resolution, " cached at: ", path.expand(cache_file)))
    if (output_class == "spdf") message(paste("SpatialPolygonDataFrame at resolution 1:", resolution, " cached at: ", path.expand(cache_file)))
  }
  
  message("
# --------------------------
HEADS UP!!

Function now returns the data in 'sf'-class (simple features) 
by default which is different 
from original behaviour that returned 'SpatialPolygonDataFrame'. 

If you prefer either 'SpatialPolygonDataFrame' or 
fortified 'data_frame' for ggplot2::geom_polygon, 
please be specify it explicitly for 'output_class'-attribute!

# --------------------------          
          ")
  
  return(shp)

}


