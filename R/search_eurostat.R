#' @title Grep Datasets Titles from Eurostat
#' @description Lists datasets from eurostat table of contents with the 
#' particular pattern in item titles.
#' @details Downloads list of all datasets available on
#' eurostat and return list of names of datasets that contains particular
#' pattern in the dataset description. E.g. all datasets related to
#' education of teaching. 
#' 
#' If you wish to perform searches on other fields than item title, 
#' you can download the Eurostat Table of Contents manually using 
#' `get_eurostat_toc()` function and use `grep()` function normally. The data
#' browser on Eurostat website may also return useful results.
#' @param pattern 
#' Text string that is used to search from dataset, folder or table titles,
#' depending on the type argument.
#' @param type
#' Selection for types of datasets to be searched. Default is `dataset`, other
#' possible options are `table`, `folder` and `all` for all types.
#' @param column
#' Selection for the column of TOC where search is done. Default is `title`, 
#' other possible option is `code`.
#' @param fixed 
#' logical. If TRUE (default), pattern is a string to be matched as is.
#' See `grep()` documentation for more information.
#' @inheritParams get_eurostat
#' @inherit get_eurostat_toc return seealso
#' @inherit eurostat-package references
#' @inheritSection eurostat-package Data source: Eurostat Table of Contents
#' 
#' @author Przemyslaw Biecek and Leo Lahti <ropengov-forum@@googlegroups.com>
#' 
#' @examplesIf check_access_to_data()
#' \donttest{
#' tmp <- search_eurostat("education")
#' head(tmp)
#' # Use "fixed = TRUE" when pattern has characters that would need escaping.
#' # Here, parentheses would normally need to be escaped in regex
#' tmp <- search_eurostat("Live births (total) by NUTS 3 region", fixed = TRUE)
#' }
#' 
#' @keywords utilities database
#' 
#' @export
search_eurostat <- function(pattern,
                            type = "dataset",
                            column = "title",
                            fixed = TRUE,
                            lang = "en") {

  # Sanity check
  type <- tolower(as.character(type))
  column <- tolower(as.character(column))
  lang <- check_lang(lang)

  if (!type %in% c("dataset", "table", "folder", "all")) {
    warning(stringr::str_glue("The type \"{type}\" is not recognized, ",
                              "will return the search results using the ",
                              "default argument: type = \"dataset\"."))
    type <- "dataset"
  }

  if (!column %in% c("title", "code")) {
    warning(stringr::str_glue("The column \"{column}\" is not recognized, ",
                              "will return the search results using the ",
                              "default argument: column = \"title\"."))
    column <- "title"
  }

  # Check if you have access to ec.europe.eu.
  if (!check_access_to_data()) {
    message("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
    return(invisible())
  }

  #set_eurostat_toc()
  #tmp <- get(".eurostatTOC", envir = .EurostatEnv)
  tmp <- get_eurostat_toc(lang = lang)

  
  if (!identical(type, "all")) {
    tmp <- tmp[tmp$type %in% type, ]
  }
  tmp <- tmp[grep(tmp[[column]], pattern = pattern, fixed = fixed), ]
}
