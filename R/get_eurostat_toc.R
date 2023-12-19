#' @title Download Table of Contents of Eurostat Data Sets
#' @description Download table of contents (TOC) of eurostat datasets.
#' @details In the downloaded Eurostat Table of Contents the 'code' column 
#' values are refer to the function 'id' that is used as an argument in certain
#' functions when downloading datasets.
#' @return A tibble with nine columns:
#' \describe{
#'    \item{title}{Dataset title in English (default)}
#' 	  \item{code}{ Each item (dataset, table and folder) of the TOC has a 
#' 	  unique code which allows it to be identified in the API. Used in the
#' 	  [get_eurostat()] and [get_eurostat_raw()] functions to retrieve datasets.}
#' 	  \item{type}{dataset, folder or table}
#' 	  \item{last.update.of.data}{Date, indicates the last time the 
#' 	  dataset/table was updated (format `DD.MM.YYYY` or `%d.%m.%Y`)}
#' 	  \item{last.table.structure.change}{Date, indicates the last time the 
#' 	  dataset/table structure was modified (format `DD.MM.YYYY` or `%d.%m.%Y`)}
#' 	  \item{data.start}{Date of the oldest value included in the dataset 
#' 	  (if available) (format usually `YYYY` or `%Y` but can also be `YYYY-MM`, 
#' 	  `YYYY-MM-DD`, `YYYY-SN`, `YYYY-QN` etc.)}
#' 	  \item{data.end}{Date of the most recent value included in the dataset 
#' 	  (if available) (format usually `YYYY` or `%Y` but can also be `YYYY-MM`, 
#' 	  `YYYY-MM-DD`, `YYYY-SN`, `YYYY-QN` etc.)}
#' 	  \item{values}{Number of actual values included in the dataset}
#' 	  \item{hierarchy}{Hierarchy of the data navigation tree, represented
#' 	  in the original txt file by a 4-spaces indentation prefix in the title}
#' }
#' 
#' @seealso [get_eurostat()], [search_eurostat()]
#' @inheritSection eurostat-package Data source: Eurostat Table of Contents
#' @inherit get_eurostat references
#' @inheritParams get_eurostat
#' 
#' @author
#' Przemyslaw Biecek, Leo Lahti and Pyry Kantanen <ropengov-forum@@googlegroups.com>
#' 
#' @examplesIf check_access_to_data()
#' \donttest{
#' tmp <- get_eurostat_toc()
#' head(tmp)
#'
#' # Convert columns containing dates as character into Date class
#' # Last update of data
#' tmp[[4]] <- as.Date(tmp[[4]], format = c("%d.%m.%Y"))
#' # Last table structure change
#' tmp[[5]] <- as.Date(tmp[[5]], format = c("%d.%m.%Y"))
#' # Data start, contains several formats (date, week, month quarter, semester)
#' # Unfortunately semesters are not directly supported so they need to be
#' # changed into quarters
#' tmp$data.start <- gsub("S2", "Q3", tmp$data.start)
#' tmp$data.start <- lubridate::as_date(
#'  x = tmp$data.start, 
#'  format = c("%Y", "%Y-Q%q", "%Y-W%W", "%Y-S%q", "%Y-%m-%d", "%Y-%m")
#'  )
#' # Data end, same as data start
#' tmp$data.end <- gsub("S2", "Q3", tmp$data.end)
#' tmp$data.end <- lubridate::as_date(
#'  x = tmp$data.end, 
#'  format = c("%Y", "%Y-Q%q", "%Y-W%W", "%Y-S%q", "%Y-%m-%d", "%Y-%m")
#'  )
#' }
#' 
#' @keywords utilities database
#' @export
get_eurostat_toc <- function(lang = "en") {
  
  lang <- check_lang(lang)
  
  language_version <- switch(lang,
                             en = ".eurostatTOC",
                             fr = ".eurostatTOC_fr",
                             de = ".eurostatTOC_de")
  
  set_eurostat_toc(lang = lang)
  
  invisible(get(language_version, envir = .EurostatEnv))
}

clean_eurostat_toc <- function() {
  objects_in_env <- objects(envir = .EurostatEnv, all.names = TRUE)
  toc_objects_in_env <- objects_in_env[grep(".eurostatTOC", objects_in_env)]
  remove(list = toc_objects_in_env, envir = .EurostatEnv)
}
