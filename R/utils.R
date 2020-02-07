# Small utility functions used by other eurostat functions
# Should not be exported
# Return vector of available frequencies
# param x a vector of "raw" time variable
available_freq <- function(x){
  if (is.factor(x)) x <- levels(x)
  x <- gsub("X", "", x)
  freq <- c()
  if (any(nchar(x) == 4)) freq <- c(freq, "Y")
  freq_char <- unique(
    substr(grep("[[:alpha:]]", x, value = TRUE), 5,5))
  freq <- c(freq, freq_char)
  freq
}

## load a eurostat package data without causing binding errors
## controlled loading in functions without loading the data 
## to the global environment

load_package_data <- function(dataset) {
  
  .new_data_environment <- new.env(parent=emptyenv()) # a new environment

  if (! exists(x = dataset, envir = .new_data_environment) ) {
    data(list = dataset, 
         package = "eurostat", 
         envir=.new_data_environment)
  } 
  .new_data_environment[[dataset]]
}