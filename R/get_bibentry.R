#' @title Create A Data Bibliography
#' @description Creates a bibliography from selected Eurostat data files, 
#' including last Eurostat update, URL access data, and optional keywords
#' set by the user. 
#' @param code A Eurostat data code or a vector of Eurostat data codes as
#' character or factor. 
#' @param keywords A list of keywords to be added to the entries. Defaults
#' to \code{NULL}. 
#' @param format Default is \code{'Biblatex'}, alternatives are \code{'bibentry'} 
#' or \code{'Bibtex'} (not case sensitive.)
#' @export
#' @author Daniel Antal, Przemyslaw Biecek
#' @return a bibentry, Bibtex or Biblatex object.
#' @examples
#'  \dontrun{
#'    my_bibliography <- get_bibentry (
#'         code = c("tran_hv_frtra", "t2020_rk310","tec00001") ,
#'         keywords = list ( c("railways", "freight", "transport"),
#'                           c("railways", "passengers", "modal split") ),
#'         format = "Biblatex" )
#'         
#'    # readLines ( my_bibliograhy, "eurostat_data.bib")
#'  }


get_bibentry <- function(
  code,
  keywords = NULL,
  format = "Biblatex" ) {
  
  if ( ! any( class (code) %in% c("character", "factor")) ) {
    stop("The code(s) must be added as character vector")
  }
  if ( !is.null(keywords) & ! class (keywords) == "list" ) {
    stop("If keyword(s) are added, they must be added as a list.")
  }
  
  code <- as.character(code)
  format <- tolower(as.character(format))
  
  if ( ! format %in% c("bibentry", "bibtex", "biblatex")) {
    warning ( "The ", format, " is not recognized, will return Biblatex as
              default.")
    format <- 'biblatex'
  }

  toc <- get_eurostat_toc()
  toc <- toc[toc$code %in% code, ]
  toc <- toc[! duplicated(toc), ]

  urldate <- as.character(Sys.Date())
  
  if (nrow(toc) == 0) {
      warning(paste0("Code ",code, "not found"))
      return()
  }

  eurostat_id <- paste0( toc$code, "_",
                           gsub("\\.", "-",  toc$`last update of data`))

  for ( i in 1:nrow(toc) ) {

    last_update_date  <- lubridate::dmy(toc[["last update of data"]][[i]])
    last_update_year  <- lubridate::year(last_update_date)
    last_update_month <- lubridate::month(last_update_date)
    last_update_day   <- lubridate::day(last_update_date)


      if ( !is.null(keywords) ) {                             #if user entered keywords
        if ( length(keywords)<i ) {                           #last keyword not entered
          keyword_entry <- NULL } else if ( nchar(keywords)[i] > 0 ) {         #not empty keyword entry
            keyword_entry <- paste( keywords[[i]], collapse = ', ' )
          }
      } else {
        keyword_entry <- NULL
      }

      entry <- RefManageR::BibEntry(
        bibtype = "misc",
        key = eurostat_id[i],
        title = paste0(toc$title[i]," [",code[i],"]"),
        url = paste0("https://ec.europa.eu/eurostat/web/products-datasets/-/",code[i]),
        language = "en",
        year = paste0(toc$`last update of data`[i]),
        publisher = "Eurostat",
        author = "Eurostat",
        keywords = keyword_entry,
        urldate = urldate
      )

    if ( i > 1 ) {
        entries <- c(entries, entry)
      } else {
        entries <- entry
      }
  }

    if (format == "bibtex") {
      entries <- utils::toBibtex(entries)
    } else if ( format == "biblatex") {
      entries <- RefManageR::toBiblatex ( entries )
    }
  entries
}
