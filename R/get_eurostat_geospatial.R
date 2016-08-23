#' @title Downloads preprocessed geospatial data from CISGO
#' @description Downloads either a SpatialPolygonDataFrame or a data.frame preprocessed using \code{ggplot2::fortify}.
#' @param resolution Resolution of the geospatial data. One of "60" (1:60million), "20" (1:20million), "10" (1:10million), "01" (1:1million),
#' @param output_class A string. Class of object returned, either \code{df} (\code{data.frame}) or \code{spdf} (\code{SpatialPolygonDataFrame})
#' @export
#' @author Markus Kainu <markuskainu@@gmail.com>
#' @return a data.frame or SpatialPolygonDataFrame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat_geospatial(output_class = "spdf", resolution = "60")
#'    spplot(lp, "STAT_LEVL_")
#'    # or
#'    lp <- get_eurostat_geospatial(output_class = "df", resolution = "60")
#'    ggplot(lp, aes(x=long,y=lat,group=group,fill=STAT_LEVL_),color="white") + geom_polygon()
#'  }
#'  


get_eurostat_geospatial <- function(output_class="spdf",resolution="60"){
  
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
    shape <- get(paste0("NUTS_2013_",resolution,"M_SH_DF"))
    shape <- shape[order(shape$order),] 
  }
  if (output_class == "spdf"){
    load(url(paste0("http://data.okf.fi/ropengov/avoindata/eurostat_geodata/rdata/NUTS_2013_",
                    resolution,
                    "M_SH_SPDF.RData")))
    shape <- get(paste0("NUTS_2013_",resolution,"M_SH_SPDF"))
  }
  return(shape)
}


t <- get_eurostat_geospatial()
