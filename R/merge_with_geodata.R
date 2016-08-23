#' @title Merge preprocessed geospatial data from CISGO with data.frame from Eurostat
#' @description Merges data.frame obtained from Eurostat with \code{get_eurostat} 
#' with geospatial data preprocessed either using \code{ggplot2::fortify} into a \code{data.frame} or a regular \code{SpatialPolygonDataFrame}. 
#' Resulting \code{data.frame} can be plotted using \code{ggplot2} and \code{SpatialPolygonDataFrame} using \code{sp::spplot}
#' @param data A data.frame including a character vector that
#' consists of values following current NUTS classification
#' @param geocolumn A string. Name of the column with NUTS information 
#' (\code{geo} in data.frames fetched using \code{get_eurostat})
#' @param resolution Resolution of the geospatial data. One of "60" (1:60million), "20" (1:20million), "10" (1:10million), "01" (1:1million),
#' @param output_class A string. Class of object returned, either \code{df} (\code{data.frame}) or \code{spdf} (\code{SpatialPolygonDataFrame})
#' @export
#' @author Markus Kainu <markuskainu@@gmail.com>
#' @return a data.frame or SpatialPolygonDataFrame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- merge_with_geodata(lp, geocolumn="geo", resolution=60, output_class="df")
#'    str(lpl)
#'  }
#'  

merge_with_geodata <- function(data,geocolumn="geo",resolution="60",output_class="df"){
  
  message("
      COPYRIGHT NOTICE

      When data downloaded from this page is 
      used in any printed or electronic publication, 
      in addition to any other provisions 
      applicable to the whole Eurostat website, 
      data source will have to be acknowledged 
      in the legend of the map and 
      in the introductory page of the publication 
      with the following copyright notice:

      - EN: © EuroGeographics for the administrative boundaries
      - FR: © EuroGeographics pour les limites administratives
      - DE: © EuroGeographics bezüglich der Verwaltungsgrenzen

      For publications in languages other than 
      English, French or German, 
      the translation of the copyright notice 
      in the language of the publication shall be used.

      If you intend to use the data commercially, 
      please contact EuroGeographics for 
      information regarding their licence agreements.
      ")
  Sys.sleep(2)
  if (output_class == "df"){
    load(url(paste0("http://data.okf.fi/ropengov/avoindata/eurostat_geodata/rdata/NUTS_2013_",
                    resolution,
                    "M_SH_DF.RData")))
    map.df <- get(paste0("NUTS_2013_",resolution,"M_SH_DF"))
    d <- merge(data,map.df,by.x=geocolumn,by.y="NUTS_ID",all.x=TRUE)
    d <- d[order(d$order),] 
  }
  if (output_class == "spdf"){
    load(url(paste0("http://data.okf.fi/ropengov/avoindata/eurostat_geodata/rdata/NUTS_2013_",
                    resolution,
                    "M_SH_SPDF.RData")))
    map.df <- get(paste0("NUTS_2013_",resolution,"M_SH_SPDF"))
    if (any(duplicated(data[[geocolumn]]))) stop("Duplicated countries/regions in attribute data. Please remove!")
    d <- sp::merge(map.df,data,by.x="NUTS_ID",by.y=geocolumn,all.x=TRUE, duplicateGeoms= TRUE)
    d <- d[!is.na(d[[ncol(data)]]),] # remove polygons with no attribute data
  }
  return(d)
}
