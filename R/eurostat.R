# Copyright (C) 2014 Leo Lahti 
# <ropengov.github.com>. All rights reserved.

#' List the open Eurostat data available through Statistics Finland database
#' Not exported at present, problems with the URL source. 
#'
#'  @param ... Arguments to be passed
#'
#'  @return table
#'
#' @references
#' See citation("eurostat") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples df <- list_eurostat_files()
#' @keywords utilities

list_eurostat_files <- function (...) {

  url <- "http://pxweb2.stat.fi/database/Eurostatn/Eurostatn_rap.csv"

  message(paste("Downloading", url))

  tab <- apply(read.csv(url, sep = ";", encoding = "latin1"), 2, function (x) {iconv(x, from = "latin1", to = "utf-8")})
  tab <- as.data.frame(tab)

  tab$File <- as.character(tab$File)
  tab$size <- as.numeric(as.character(tab$size)) 
  tab$created <- as.character(tab$created) 
  tab$updated <- as.character(tab$updated) 
  tab$variables <- as.numeric(tab$variables)
  tab$tablesize <- as.character(tab$tablesize) 
  tab$TITLE <- as.character(tab$TITLE)
  tab$DESCRIPTION <- as.character(tab$DESCRIPTION)

  tab

}




#' Get PC Axis data with custom preprocessing for PC Axis 
#' files from Statistics Finland (Tilastokeskus) http://www.stat.fi/
#'
#' @param url or local file name of the Eurostat file
#' @param format One of the following: "px", "csv", "xml". Specifies the desired format of the source file.
#' @param verbose verbose
#'
#' @return data.frame
#'
#' @details If the reading of PX file fails, CSV is used instead.
#'
#' @export
#' @references
#' See citation("eurostat") 
#' @author Leo Lahti \email{louhos@@googlegroups.com}
#' @examples \dontrun{px <- get_eurostat(url)}
#' @keywords utilities

get_eurostat <- function (url, format = "px", verbose = TRUE) {

  if (format == "px") {

    url <- gsub("\\.csv", "\\.px", url)
    url <- gsub("\\.xml", "\\.px", url)

    # If URL is given, read the data into PX object
    if (is_url(url)) {
      message(paste("Reading Eurostat data from ", url))
      px <- read_px(url)
    }

    # Convert to data.frame 
    if (class(px) == "px") { 
      df <- as.data.frame(px) 
    }

  } else if (format == "xml") {

    warning("xml not yet implemented for eurostat; using csv instead")

    url <- gsub("\\.px", "\\.csv", url)
    url <- gsub("\\.xml", "\\.csv", url)
    df <- read.csv(url, encoding = "latin1", as.is = T, colClasses = 'character', sep = ";"); 

  } else if (format == "csv") {

    # TODO
    url <- gsub("\\.px", "\\.csv", url)
    url <- gsub("\\.xml", "\\.csv", url)
    df <- read.csv(url, encoding = "latin1", as.is = T, colClasses = 'character', sep = ";"); 

  }

  df

}



