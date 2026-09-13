#' @title Create A Data Bibliography
#' @description Creates a bibliography from selected Eurostat data files,
#' including last Eurostat update, URL access data, and optional keywords
#' set by the user.
#' @param code A Eurostat data code or a vector of Eurostat data codes as
#' character or factor.
#' @param keywords A list of keywords to be added to the entries. Defaults
#' to `NULL`.
#' @param format Default is `'Biblatex'`, alternatives are `'bibentry'`
#' or `'Bibtex'` (not case sensitive)
#' @inheritParams get_eurostat
#' @author Daniel Antal, Przemyslaw Biecek
#' @inheritSection eurostat-package Citing Eurostat data
#' 
#' @return a bibentry, Bibtex or Biblatex object.
#' 
#' @seealso [utils::bibentry]
#' 
#' @examplesIf check_access_to_data()
#' \dontrun{
#'   my_bibliography <- get_bibentry(
#'     code = c("tran_hv_frtra", "tec00001"),
#'     keywords = list(
#'       c("transport", "freight", "multimodal data", "GDP"),
#'       c("economy and finance", "annual", "national accounts", "GDP")
#'     ),
#'     format = "Biblatex"
#'   )
#'   my_bibliography
#' }
#' 
#' @importFrom lubridate dmy year month day
#' @importFrom utils toBibtex person
#' @importFrom stringr str_glue
#'
#' @export
get_bibentry <- function(code,
                         keywords = NULL,
                         format = "bibtex",
                         lang = "en") {
  if (!any(class(code) %in% c("character", "factor"))) {
    stop("The code(s) must be added as character vector")
  }
  if (!is.null(keywords) && !inherits(keywords, "list")) {
    stop("If keyword(s) are added, they must be added as a list.")
  }

  code <- as.character(code)
  format <- tolower(as.character(format))

  if (!format %in% c("bibentry", "bibtex")) {
    warning("The ", format, " is not recognized, will return bibtex as
              default.")
    format <- "bibtex"
  }

  toc <- get_eurostat_toc(lang = lang)
  # Remove hierarchy column to make duplicated() check more viable
  toc <- toc[, !names(toc) %in% c("hierarchy")]
  toc <- toc[toc$code %in% code, ]
  toc <- toc[!duplicated(toc), ]

  urldate <- as.character(Sys.Date())
  
  lang <- check_lang(lang)
  
  lang_long <- switch(lang,
                      en = "English",
                      fr = "French",
                      de = "German")

  if (nrow(toc) == 0) {
    warning(paste(
      "None of the codes were found in the Eurostat table of contents.\n",
      "Please check the 'code' argument in get_bibentry() for errors:\n",
      paste(code, collapse = ", ")
      )
    )
    return()
  }
  
  not_found <- NULL
  not_found <- !(code %in% toc$code)
  not_found <- code[not_found]
  if (is.character(not_found) && length(not_found) != 0) {
    warning(paste(
      "The following codes were not found in the Eurostat table of contents.\n",
      "Bibliography object returned without the following items:\n",
      paste(not_found, collapse = ", ")
    ))
  }

  for (i in seq_len(nrow(toc))) {
    last_update_date <- lubridate::dmy(toc[["last.update.of.data"]][[i]])
    last_update_year <- lubridate::year(last_update_date)
    last_update_month <- lubridate::month(last_update_date)
    last_update_day <- lubridate::day(last_update_date)
    
    dataset_key <- paste0(
      toc$code[i], "-", last_update_year, "-", last_update_month, "-", 
      last_update_day
    )
    # replace troublesome _ with -
    dataset_key <- gsub("_", "-", dataset_key)
    
    dataset_id <- toc$code[i]
    # replace troublesome _ with \_ for bibtex and biblatex references
    if (format %in% c("bibtex", "biblatex")) {
      dataset_id <- gsub("_", "\\\\_", dataset_id)
    }

    if (!is.null(keywords)) { # if user entered keywords
      if (length(keywords) < i) { # last keyword not entered
        keyword_entry <- NULL
      } else if (nchar(keywords)[i] > 0) { # not empty keyword entry
        keyword_entry <- paste(keywords[[i]], collapse = ", ")
      }
    } else {
      keyword_entry <- NULL
    }
    
    sdmx_dataflow <- get_sdmx_dataflow(id = toc$code[i], agency = "Eurostat")
    
    unexpanded_doi <- ""
    if (!is.na(sdmx_dataflow$doi_url)) {
      unexpanded_doi <- gsub("https://doi.org/", "", sdmx_dataflow$doi_url)
      unexpanded_doi <- gsub("_", "\\\\_", unexpanded_doi)
    }
    
    entry <- utils::bibentry(
      bibtype = "misc",
      key = dataset_key,
      title = paste0(toc$title[i], " (", dataset_id, ")"),
      author = c(
        utils::person(given = "Eurostat")
      ),
      url = paste0("https://ec.europa.eu/eurostat/web/products-datasets/product?code=",
                   toc$code[i]),
      language = lang_long,
      # date = last_update_date,
      year = last_update_year,
      doi = unexpanded_doi,
      keywords = keyword_entry,
      urldate = urldate,
      type = "Dataset",
      note = stringr::str_glue(
        paste("Accessed {as.Date(urldate)},",
              "dataset last updated {as.Date(last_update_date)}")
      )
    )

    if (i > 1) {
      entries <- c(entries, entry)
    } else {
      entries <- entry
    }
  }

  if (format == "bibtex") {
    entries <- utils::toBibtex(entries)
  }
  # if entry is bibentry then that will be returned instead of bibtex
  entries
}
