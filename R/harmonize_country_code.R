harmonize_country_code <- function (x) {
    # The European Commission and the Eurostat generally uses ISO
    # 3166-1 alpha-2 codes with two exceptions: EL (not GR) is used to
    # represent Greece, and UK (not GB) is used to represent the
    # United Kingdom. These exceptions touch upon any Eurostat
    # tables. Hence this special issue should be addressed either in
    # eurostat or in countrycode, but is not a universal
    # issue, so is should be used in packages concerning European
    # Commission / Eurostat data access.
    x <- gsub("EL", "GR", x)
    x <- gsub("UK", "GB", x)      

  x   
}