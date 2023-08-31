#' @title Set Eurostat TOC
#' @description Internal function.
#' @param ... Arguments to be passed
#' @return Empty element
#' @references see citation("eurostat")
#' @author Przemyslaw Biecek and Leo Lahti <ropengov-forum@@googlegroups.com>
#'
#' @importFrom readr read_tsv cols col_character
#'
#' @keywords internal
set_eurostat_toc <- function(...) {
  if (!exists(".eurostatTOC", envir = .EurostatEnv)) {
    base <- getOption("eurostat_url")
    url <- paste(base, "api/dissemination/catalogue/toc/txt?lang=en",
      sep = ""
    )
    .eurostatTOC <- readr::read_tsv(
      file = url(url),
      col_types = readr::cols(.default = readr::col_character()),
      name_repair = make.names,
      trim_ws = FALSE
    )
    
    # Clean the names, replace " " (empty spaces) with "."
    # names(.eurostatTOC) <- gsub(" ", ".", names(.eurostatTOC))
    
    .eurostatTOC$hierarchy <- determine_hierarchy(.eurostatTOC$title)
    .eurostatTOC$title <- trimws(.eurostatTOC$title, which = "left")

    assign(".eurostatTOC", .eurostatTOC, envir = .EurostatEnv)
  }
  invisible(0)
}

#' @title Count white space at the start of the title
#' @description Counts the number of white space characters at the start
#' of the string.
#' @inherit determine_hierarchy details
#' @return Numeric (number of white space characters)
#' @importFrom stringr str_match
#' @examples
#' strings <- c("    abc", "  cdf", "no_spaces")
#' for (string in strings) {
#'  whitespace_count <- eurostat:::count_whitespace_before_alphanumeric(string)
#'  cat("String:", string, "\tWhitespace Count:", whitespace_count, "\n")
#' }
#' @keywords internal
count_whitespace_before_alphanumeric <- function(input_string) {
  # Counts white space chars \s before encountering the 1st non-ws char \S
  pattern <- "^\\s*(?=\\S)"
  extracted_ws <- stringr::str_extract(input_string, pattern)
  
  nchar(extracted_ws)
}

#' @title Determine level in hierarchy
#' @description Divides the number of spaces before alphanumeric characters
#' with 4 and uses the result to determine hierarchy. Top level is 0.
#' @details Used in determine_hierarchy function to determine hierarchy. 
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
#' eurostat:::determine_hierarchy(strings)
#' @keywords internal
determine_hierarchy <- function(input_string) {
  number_of_whitespace <- count_whitespace_before_alphanumeric(input_string)

  # If all x mod y calculations equal 0 everything is ok. 
  # If not, input is somehow mangled
  if (!all((number_of_whitespace %% 4) %in% c(0))) {
    warning("Mangled input")
    return(invisible())
  }
  
  # If white space is 0, it gets number 0 in hierarchy
  (number_of_whitespace %/% 4)
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
#' @keywords internal
#' 
count_children <- function(code) {
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
    num_children <- i - initial_pos
    i <- i + 1
  }
  num_children
}
