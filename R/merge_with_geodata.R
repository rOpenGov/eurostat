#' @title Merge preprocessed geospatial data from CISGO with data.frame from Eurostat
#' @description Merges data.frame obtained from Eurostat with \code{get_eurostat} 
#' with geospatial data preprocessed using \code{ggplot2::fortify}. Resulting data.frame can be plotted using ggplot2
#' @param data A data.frame including a character vector that
#' consists of values following current NUTS classification
#' @param geocolumn A string. Name of the column with NUTS information 
#' (\code{geo} in data.frames fetched using \code{get_eurostat})
#' @param resolution Resolution of the geospatial data. One of "60" (1:60million), "20" (1:20million), "10" (1:10million), "01" (1:1million),
#' @export
#' @author Markus Kainu <markuskainu@@gmail.com>
#' @return a data.frame.
#' @examples
#'  \dontrun{
#'    lp <- get_eurostat("nama_aux_lp")
#'    lpl <- merge_with_geodata(lp, geocolumn="geo", resolution=60)
#'    str(lpl)
#'  }
#'  

merge_with_geodata <- function(data,geocolumn="geo",resolution=60){
  load(url(paste0("http://data.okf.fi/ropengov/avoindata/eurostat_geodata/rdata/NUTS_2013_",
                  resolution,
                  "M_SH_DF.RData")))
  map.df <- get(paste0("NUTS_2013_",resolution,"M_SH_DF"))
  d <- merge(data,map.df,by.x=geocolumn,by="NUTS_ID",all.x=TRUE)
  d <- d[order(d$order),] 
  return(d)
}