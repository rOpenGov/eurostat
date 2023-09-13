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
#' @author Daniel Antal, Przemyslaw Biecek
#' @inheritSection eurostat-package Citing Eurostat data
#' 
#' @return a bibentry, Bibtex or Biblatex object.
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
#' @importFrom RefManageR BibEntry toBiblatex
#'
#' @export
get_bibentry <- function(code,
                         keywords = NULL,
                         format = "Biblatex") {
  if (!any(class(code) %in% c("character", "factor"))) {
    stop("The code(s) must be added as character vector")
  }
  if (!is.null(keywords) && !inherits(keywords, "list")) {
    stop("If keyword(s) are added, they must be added as a list.")
  }

  code <- as.character(code)
  format <- tolower(as.character(format))

  if (!format %in% c("bibentry", "bibtex", "biblatex")) {
    warning("The ", format, " is not recognized, will return Biblatex as
              default.")
    format <- "biblatex"
  }

  toc <- get_eurostat_toc()
  # Remove hierarchy column to make duplicated() check more viable
  toc <- toc[, !names(toc) %in% c("hierarchy")]
  toc <- toc[toc$code %in% code, ]
  toc <- toc[!duplicated(toc), ]

  urldate <- as.character(Sys.Date())

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
    
    eurostat_id <- paste0(
      toc$code[i], "_", last_update_day, "-", last_update_month, "-", 
      last_update_year
    )

    if (!is.null(keywords)) { # if user entered keywords
      if (length(keywords) < i) { # last keyword not entered
        keyword_entry <- NULL
      } else if (nchar(keywords)[i] > 0) { # not empty keyword entry
        keyword_entry <- paste(keywords[[i]], collapse = ", ")
      }
    } else {
      keyword_entry <- NULL
    }

    entry <- RefManageR::BibEntry(
      bibtype = "misc",
      key = eurostat_id,
      title = paste0(toc$title[i], " (", toc$code[i], ")"),
      url = paste0("https://ec.europa.eu/eurostat/web/products-datasets/-/",
                   toc$code[i]),
      language = "en",
      date = last_update_date,
      author = c(
        utils::person(given = "Eurostat")
      ),
      keywords = keyword_entry,
      urldate = urldate
    )

    if (i > 1) {
      entries <- c(entries, entry)
    } else {
      entries <- entry
    }
  }

  if (format == "bibtex") {
    entries <- utils::toBibtex(entries)
  } else if (format == "biblatex") {
    entries <- RefManageR::toBiblatex(entries)
  }
  entries
}
