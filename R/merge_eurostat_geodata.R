#' @title Merge Geospatial GISCO Data with Eurostat data_frame
#' @description Merges data_frame obtained from Eurostat with \code{get_eurostat} with geospatial data preprocessed either using \code{ggplot2::fortify} into a \code{data_frame} or a regular \code{SpatialPolygonDataFrame}. The resulting \code{data_frame} can be plotted using \code{ggplot2} and \code{SpatialPolygonDataFrame} using \code{sp::spplot}.
#' @param data A data_frame including a character vector that
#' consists of values following current NUTS classification
#' @param geocolumn A string. Name of the column with NUTS information 
#' (\code{geo} in data_frames fetched using \code{get_eurostat})
#' @param resolution Resolution of the geospatial data. One of "60" (1:60million), "20" (1:20million), "10" (1:10million), "01" (1:1million),
#' @param all_regions Logical. To include all the regions from spatial data or only the ones included in the fetched Eurostat attribute data
#' @param cache cache. Logical.
#' @param update_cache Update cache. Logical.
#' @param cache_dir Cache directory.
#' @author Markus Kainu <markuskainu@@gmail.com>
#' @return a data_frame or SpatialPolygonDataFrame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- merge_eurostat_geodata(lp, geocolumn="geo", resolution=60,
#'      	                    all_regions=FALSE)
#'    str(lpl)
#'  }
#'  
# merge_eurostat_geodata <- function(data,geocolumn="geo",resolution="60",
#                                    all_regions=FALSE,
#                                    cache = TRUE,
#                                    update_cache = FALSE, cache_dir = NULL){
#   
#   map.df <- get_eurostat_geospatial(output_class=output_class,
#                                     resolution=resolution,
#                                     cache = cache,
#                                     update_cache = update_cache,
#                                     cache_dir = cache_dir)
#   
#   data[[geocolumn]] <- as.character(data[[geocolumn]])
#   
#   if (output_class == "df"){
#     if (all_regions)  d <- merge(data,map.df,by.x=geocolumn,by.y="NUTS_ID",all.y=TRUE)
#     if (!all_regions) d <- merge(data,map.df,by.x=geocolumn,by.y="NUTS_ID",all.x=TRUE)
#     d <- d[order(d$order),] 
#   }
#   if (output_class == "spdf"){
#     if (any(duplicated(data[[geocolumn]]))) stop("Duplicated countries/regions in attribute data. Please remove!")
#     if (all_regions)  d <- merge(map.df,data,by.x="NUTS_ID",by.y=geocolumn,duplicateGeoms= TRUE, all.y=TRUE)
#     if (!all_regions) d <- merge(map.df,data,by.x="NUTS_ID",by.y=geocolumn,duplicateGeoms= TRUE, all.x=TRUE)
#     d <- d[!is.na(d[[ncol(data)]]),] # remove polygons with no attribute data
#   }
#   return(d)
#   
#   message("
#           # --------------------------
#           HEADS UP!!
#           
#           eurostat-package now support sf (simple features) by default 
#           regarding the geospatial data.
#           
#           Rather than using this functions, please consider migrating into
#           simple features and using dplyr join-verbs for joining 
#           attribute data with geospatial data!
#           
#           This function will be deprecated in future versions!
#           # --------------------------          
#           ")  
#   
# }
