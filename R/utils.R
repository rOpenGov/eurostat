# Small utility functions used by other eurostat functions
# Should not be exported
# Return vector of available frequencies
# param x a vector of "raw" time variable
available_freq <- function(x) {
  if (is.factor(x)) x <- levels(x)
  x <- gsub("X", "", x)
  freq <- c()
  if (any(nchar(x) == 4)) freq <- c(freq, "Y")
  freq_char <- unique(
    substr(grep("[[:alpha:]]", x, value = TRUE), 5, 5)
  )
  freq <- c(freq, freq_char)
  freq
}

## load a eurostat package data without causing binding errors
## controlled loading in functions without loading the data
## to the global environment

load_package_data <- function(dataset) {
  .new_data_environment <- new.env(parent = emptyenv()) # a new environment

  if (!exists(x = dataset, envir = .new_data_environment)) {
    utils::data(
      list = dataset,
      package = "eurostat",
      envir = .new_data_environment
    )
  }
  .new_data_environment[[dataset]]
}

check_lang <- function(lang) {
  if (!is.null(lang)) {
    # The Language parameter (“lang”) can have only three values:
    # "en" (English), "fr" (French), and "de" (German).
    lang <- tolower(lang)
    if (lang %in% c("en", "fr", "de")) {
      return(lang)
    } else {
      message(
        "Unsupported language code used. Using the default language: \"en\""
      )
      lang <- "en"
    }
  } else {
    # In case the parameter isn’t specified, the default value "en" is taken.
    message("Using the default language: \"en\"")
    lang <- "en"
  }
  lang
}

#' @title Calculate a fixity checksum for an object
#' @description
#' Uses a hash function (md5) on an object and calculates a digest of the object
#' in the form of a character string.
#' 
#' @details
#' “Fixity, in the preservation sense, means the assurance that a digital file
#' has remained unchanged, i.e. fixed.” (Bailey, 2014). In practice, fixity
#' can most easily be established by calculating a checksum for the data object
#' that changes if anything in the data object has changed. What we use as a
#' checksum here is by default calculated with md5 hash algorithm. It is
#' possible to use other algorithms supported by the imported digest function,
#' see function documentation.
#' 
#' In the case of big objects with millions of rows of data calculating a
#' checksum can take a bit longer and require some amount of RAM to be
#' available. Selecting another algorithm might perform faster and/or more
#' efficiently. Whichever algorithm you are using, please make sure to report
#' it transparently in your work for transparency and ensuring replicability.
#' 
#' This function takes the whole data object as an input, meaning that
#' everything counts when calculating the fixity checksum. If the dataset
#' column names are labeled, if the data itself is labeled, if stringsAsFactors
#' is TRUE, if flags are removed or kept, if data is somehow edited... all these
#' affect the calculated checksum. It is advisable to calculate the checksum
#' immediately after downloading the data, before adding any labels or doing
#' other mutating operations. If you are using other arguments than the default
#' ones when downloading data, it is also good to report the exact arguments
#' used.
#' 
#' This implementation fulfills the level 1 requirement of National Digital
#' Stewardship Alliance (NDSA) preservation levels by creating "fixity info 
#' if it wasn’t provided with the content". In the current version of the
#' package, fixity information has to be created manually and is at the
#' responsibility of the user.
#' 
#' @param data_object A dataset downloaded with some eurostat package function.
#' @param algorithm Algorithm to use when calculating a checksum for a dataset.
#' Default is 'md5', but can be any supported algorithm in digest function.
#' 
#' @seealso [digest::digest()]
#' @source https://www.dpconline.org/handbook/technical-solutions-and-tools/fixity-and-checksums
#' @importFrom digest digest
#' @keywords internal utilities
fixity_checksum <- function(data_object, algorithm = "md5") {
  if (!(algorithm %in% c("md5", "sha1", "crc32", "sha256", "sha512",
                      "xxhash32", "xxhash64", "murmur32", "spookyhash",
                      "blake3", "crc32c"))) {
    stop("Use a valid algorithm. See digest::digest function documentation")
  }

  fixity <- digest::digest(data_object, algo = algorithm)
  fixity
}
