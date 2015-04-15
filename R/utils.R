# Small utility functions used by other eurostat functions
# Should not be exported

#' Return vector of available frequencies
#' 
#' @param x a vector of "raw" time variable
available_freq <- function(x){
  if (is.factor(x)) x <- levels(x)
  x <- gsub("X", "", x)
  freq <- c()
  if (any(nchar(levels(dat3$time)) == 4)) freq <- c(freq, "Y")
  freq_char <- unique(
    substr(grep("[[:alpha:]]", levels(dat3$time), value = TRUE), 5,5))
  freq <- c(freq, freq_char)
  freq
}