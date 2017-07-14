# The R Journal, 2017 Roger Bivand 
# file share/doi_helpers.R
#
library(bibtex)
library(stringr)
library(rcrossref)

# Helper function to check whether a declared doi exists and points
# to the correct object; the existing doi format must follow:
# https://www.crossref.org/display-guidelines/
# for example: url = {https://doi.org/10.1080/10618600.1996.10474713}
#
# input *.bib file sent by copy-editor
# output a nested list of length = # articles with doi as urls, and nested
# lists of length 3 giving the article bibtex key, a simple text rendering of 
# the original article metadata from the *.bib file, and the simple text
# rendering of retrieved article metadata corresponding to the doi value.
#
# Visual inspection of the output $orig and $found values is required!!
#
# If the $found metadata indicate that the doi points to a different article
# or if the $found component is the empty string, the reference at the bibtex
# key needs urgent attention

check_doi <- function(bibfile) {
  biblist <- bibtex::read.bib(bibfile)
  stopifnot(inherits(biblist, "bibentry"))
  stopifnot(length(biblist) >= 1L)
  res <- list()
  for(i in 1:length(biblist)) {
    if(tolower(biblist[i]$bibtype) == "article" && !is.null(biblist[i]$url)) {
      url <- biblist[i]$url
      str_search_doi <- "((https://doi.org/)([-a-zA-Z0-9/_\\+\\.]*))"
      doi_str <- c(na.omit(str_trim(str_extract(url, str_search_doi))))
      doi <- str_sub(doi_str, 17L, str_length(doi_str))
      cat(biblist[i]$key, doi, "\n")
      j <- 0
      ok <- FALSE
      while(j < 5 & !ok) {
        j <- j + 1
        ret <- try(rcrossref::cr_cn(dois = doi, format = "text",
          style = "apa"), silent = TRUE)
        if(inherits(ret, "try-error")) {
          Sys.sleep(5)
        } else {
          ok <- TRUE
        }
      }
      if(!ok) ret <- ""
      resi <- list(list(key=biblist[i]$key, orig=format(biblist[i]),
        found=ret))
      names(resi) <- biblist[i]$key
      res <- c(res, resi)
    }
  }
  res  
}

# Helper function to try to guess article doi strings from article metadata,
# based on jss package code on R-Forge:
# https://r-forge.r-project.org/projects/jss/
#
# The existing doi format must follow:
# https://www.crossref.org/display-guidelines/
# for example: url = {https://doi.org/10.1080/10618600.1996.10474713}
# so that articles with dois can be skipped
#
# input *.bib file sent by copy-editor
#       limit: number of search items returned by rcrossref::cr_work()
#
# output: a nested list of length = # articles with doi as urls, and nested
# lists of length 3 giving the article bibtex key, a simple text rendering of 
# the original article metadata from the *.bib file, and either an empty
# string for failure or a data frame with limit rows with the found DOI
# values and item metadata, from which it should be possible to see whether
# the returned values actually apply to the query - they may very well
# be false positives!!!
#
# Visual inspection of the output $orig and $found values is required!!
#
# If the doi appears to have been found correctly, the reference at the
# bibtex key may be updated manually with url = {https://doi.org/<doi>}

find_doi <- function(bibfile, limit=3L) {
  biblist <- bibtex::read.bib(bibfile)
  stopifnot(inherits(biblist, "bibentry"))
  stopifnot(length(biblist) >= 1L)
  res <- list()
  for(i in 1:length(biblist)) {
    if(tolower(biblist[i]$bibtype) == "article") {
      if (is.null(biblist[i]$doi)) {
        has_url_doi <- FALSE
        if (!is.null(biblist[i]$url)) {
          url <- biblist[i]$url
          str_search_doi <- "((https://doi.org/)([-a-zA-Z0-9/_\\+\\.]*))"
          doi_str <- c(na.omit(str_trim(str_extract(url, str_search_doi))))
          has_url_doi <- str_length(doi_str) > 0
        }
        if (!has_url_doi) {
          cat(biblist[i]$key, "\n")
          qry <- format(biblist[i])
          j <- 0
          ok <- FALSE
          while(j < 5 & !ok) {
            j <- j + 1
            ret <- try(rcrossref::cr_works(query = qry, limit = limit)$data,
              silent = TRUE)
            if(inherits(ret, "try-error")) {
              Sys.sleep(5)
            } else {
              ok <- TRUE
            }
          }
          if(!ok) {
            ret <- ""
           } else {
             nms <- names(ret)
             cols <- c(na.omit(match(c("DOI", "title", "author",
               "container.title", "type", "page", "score"), nms)))
             ret <- as.data.frame(ret[, cols])           
          }
          resi <- list(list(key=biblist[i]$key, orig=qry, found=ret))
          names(resi) <- biblist[i]$key
          res <- c(res, resi)
        }
      } else {
        warning("doi key present in key: ", biblist[i]$key)
      }
    }
  }
  res
}


