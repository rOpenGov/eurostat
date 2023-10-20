#' @title Set Eurostat TOC
#' @description Internal function.
#' @inheritParams get_eurostat
#' @return Empty element
#' @references see citation("eurostat")
#' @author Przemyslaw Biecek and Leo Lahti <ropengov-forum@@googlegroups.com>
#'
#' @importFrom readr read_tsv cols col_character
#' @importFrom stringr str_glue
#' 
#' @seealso [get_eurostat_toc()] [toc_count_children()] [toc_determine_hierarchy()] 
#' [toc_list_children()] [toc_count_whitespace()]
#'
#' @keywords internal
set_eurostat_toc <- function(lang = "en") {
  lang <- check_lang(lang)
  
  language_version <- switch(lang,
                             en = ".eurostatTOC",
                             fr = ".eurostatTOC_fr",
                             de = ".eurostatTOC_de")
  
  if (!exists(language_version, envir = .EurostatEnv)) {
    base <- getOption("eurostat_url")
    url <- stringr::str_glue(
      paste0(base, "api/dissemination/catalogue/toc/txt?lang={lang}")
    )
    
    .eurostatTOC <- readr::read_tsv(
      file = url(url),
      col_types = readr::cols(.default = readr::col_character()),
      name_repair = make.names,
      trim_ws = FALSE
    )
    
    .eurostatTOC$hierarchy <- toc_determine_hierarchy(.eurostatTOC$title)
    .eurostatTOC$title <- trimws(.eurostatTOC$title, which = "left")
    .eurostatTOC$values <- as.numeric(.eurostatTOC$values)
    
    assign(language_version, .eurostatTOC, envir = .EurostatEnv)
  }
  invisible(0)
}

#' @title Count white space at the start of the title
#' @description Counts the number of white space characters at the start
#' of the string.
#' @inherit toc_determine_hierarchy details
#' @inheritParams toc_determine_hierarchy
#' @return Numeric (number of white space characters)
#' @importFrom stringr str_extract
#' @examples
#' strings <- c("    abc", "  cdf", "no_spaces")
#' for (string in strings) {
#'  whitespace_count <- eurostat:::toc_count_whitespace(string)
#'  cat("String:", string, "\tWhitespace Count:", whitespace_count, "\n")
#' }
#' 
#' @inherit set_eurostat_toc seealso
#' 
#' @author Pyry Kantanen
#' 
#' @keywords internal
toc_count_whitespace <- function(input_string) {
  # Counts white space chars \s before encountering the 1st non-ws char \S
  pattern <- "^\\s*(?=\\S)"
  extracted_ws <- stringr::str_extract(input_string, pattern)
  
  nchar(extracted_ws)
}

#' @title Determine level in hierarchy
#' @description Divides the number of spaces before alphanumeric characters
#' with 4 and uses the result to determine hierarchy. Top level is 0.
#' @details Used in toc_determine_hierarchy function to determine hierarchy. 
#' Hierarchy is defined in Eurostat .txt format TOC files by the number of 
#' white space characters at intervals of four. For example, 
#' "    Foo" (4 white space characters) is one level higher than 
#' "        Bar" (8 white space characters). 
#' "Database by themes" (0 white space characters before the first
#' alphanumeric character) is highest in the hierarchy.
#' 
#' The function will return a warning if the input has white space in anything
#' else than as increments of 4. 0, 4, 8... are acceptable but 3, 6, 10... 
#' are not.
#' @param input_string
#' A string containing Eurostat TOC titles
#' @return Numeric
#' @examples
#' strings <- c("        abc", "    cdf", "no_spaces")
#' eurostat:::toc_determine_hierarchy(strings)
#' 
#' @inherit set_eurostat_toc seealso
#' 
#' @author Pyry Kantanen
#' 
#' @keywords internal
toc_determine_hierarchy <- function(input_string) {
  number_of_whitespace <- toc_count_whitespace(input_string)

  # If all x mod y calculations equal 0 everything is ok. 
  # If not, input is somehow mangled
  # For example "    General and regional statistics" (4 whitespace) returns 1
  # whereas "            " (12 whitespace without any letters) returns also 1
  # Normally all dataset items are expected to have a title to determine
  # their place in hierarchy. Testing for this might be a bit tricky.
  if (!all((number_of_whitespace %% 4) %in% c(0))) {
    warning(
      paste(
      "TOC indentation was not uniform in all rows or there were some",
      "items that were missing a proper title. Hierarchy value set to NA",
      "for problematic rows."
        )
      )
    invalid_rows <- which(!(number_of_whitespace %% 4) %in% c(0))
    # return(invisible())
    hierarchy <- number_of_whitespace %/% 4
    hierarchy[invalid_rows] <- NA
    return(hierarchy)
  }
  
  # If white space is 0, it gets number 0 in hierarchy
  hierarchy <- number_of_whitespace %/% 4
  hierarchy
  # Or should it be 1?
  # (number_of_whitespace %/% 4) + 1
}

#' @title Count number of children
#' @description
#' Determine how many children a certain TOC item (usually a folder) has.
#' @param code Eurostat TOC item code (folder, dataset, table)
#' 
#' @importFrom stringr str_glue
#' 
#' @inherit set_eurostat_toc seealso
#' 
#' @author Pyry Kantanen
#' 
#' @keywords internal
#' 
toc_count_children <- function(code) {
  toc <- get_eurostat_toc()
  
  # Line number for hit
  initial_pos <- which(toc$code == code)
  
  if (length(initial_pos) > 1) {
    warning(stringr::str_glue(
      "Unambiguous code input: \"{code}\". ",
      "TOC contains multiple items with the same code."))
    return(invisible())
  }
  
  initial_hierarchy <- toc$hierarchy[initial_pos]
  i <- initial_pos + 1
  num_children <- 0

  while (toc$hierarchy[i] > initial_hierarchy) {
    # Check for the 1st iteration: If the next item is of the same hierarchy
    # break the while loop and determine that the number of children is 0
    if (toc$hierarchy[i] == initial_hierarchy && num_children == 0) {
      num_children <- 0
      break
    }
    num_children <- i - initial_pos
    i <- i + 1
  }
  num_children
}

#' @title List children
#' @description
#' List children of a specific folder.
#' @inheritParams toc_count_children
#' 
#' @importFrom stringr str_glue
#' 
#' @inherit set_eurostat_toc seealso
#' 
#' @author Pyry Kantanen
#' 
#' @keywords internal
#' 
toc_list_children <- function(code) {
  toc <- get_eurostat_toc()
  # Line number for hit
  initial_pos <- which(toc$code == code)

  if (length(initial_pos) > 1) {
    warning(stringr::str_glue(
      "Unambiguous code input: \"{code}\". ",
      "TOC contains multiple items with the same code."))
    return(invisible())
  }

  final_pos <- initial_pos + toc_count_children(code)

  if (final_pos == initial_pos) {
    initial_pos_type <- toc$type[initial_pos]
    message(stringr::str_glue(
      "The TOC item with code \"{code}\" (type: {initial_pos_type}) ",
      "does not have any children. Please use another code.")
    )
    return(invisible())
  }

  # Add 1 to omit root folder
  initial_pos <- initial_pos + 1

  children <- toc[initial_pos:final_pos, ]
  children
}
