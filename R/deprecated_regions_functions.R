#' DEPRECATED FUNCTIONS FOR BACKWARD COMPATIBILITY
#' FUNCTIONS GIVE WARNING AND CALL APPROPRIATE regions FUNCTIONS

#' @title Add the statistical aggregation level to data frame
#' @description Eurostat regional statistics contain country, and various
#' regional level information.  In many cases, for example, when mapping,
#' it is useful to filter out national level data from NUTS2 level regional
#' data, for example.
#'
#' This function will be deprecated. Use the more comprehensive
#' `[regions::validate_nuts_regions()]` instead.
#'
#' @param dat A data frame or tibble returned by [get_eurostat()].
#' @param geo_labels A geographical label, defaults to `geo`.
#' @author Daniel Antal
#' @return a new numeric variable nuts_level with the numeric value of
#' NUTS level 0 (country), 1 (greater region),
#' 2 (region), 3 (small region).
#' @keywords internal
#' @family regions functions
#' @seealso [regions::validate_nuts_regions()]
#' @examples
#'
#' dat <- data.frame(
#'   geo    = c("FR", "IE04", "DEB1C"),
#'   values = c(1000, 23, 12)
#' )
#'
#' add_nuts_level(dat)
#' @importFrom dplyr mutate case_when
#'
#' @export

add_nuts_level <- function(dat, geo_labels = "geo") {
  message("This function will be deprecated. Use regions::validate_nuts_regions() instead.")

  if (any(c("character", "factor") %in% class(dat))) {
    input <- "label"
    geo <- dat
    dat <- data.frame(
      geo = as.character(geo),
      stringsAsFactors = FALSE
    )
  } else {
    input <- "not_label"
  }


  if ("data.frame" %in% class(dat)) {
    if (!geo_labels %in% names(dat)) {
      stop(
        "Regional labelling variable '",
        geo_labels,
        "' is not found in the data frame."
      )
    }

    dat <- regions::validate_nuts_regions(dat)
    dat$nuts_level <- unlist(lapply(dat$typology, switch,
      country = 0,
      nuts_level_1 = 1,
      nuts_level_2 = 2,
      nuts_level_3 = 3
    ))
  }

  if (input == "label") {
    as.numeric(dat$nuts_level)
  } else {
    dat
  }
}

#' @title Harmonize NUTS region codes that changed with the `NUTS2016`
#'  definition
#' @description Eurostat mixes `NUTS2013` and `NUTS2016` geographic
#' label codes in the `'geo'` column, which creates time-wise comparativity
#' issues. This deprecated function checked if you data is affected by this
#' problem and gives information on what to do.
#'
#' This function is deprecated, and a more general function was moved to
#' [regions::validate_nuts_regions()].
#'
#' @param dat A Eurostat data frame downloaded with [get_eurostat()]
#' @author Daniel Antal
#' @return An augmented data frame that explains potential problems and
#' possible solutions.
#' @importFrom regions validate_nuts_regions
#' @examples
#' dat <- eurostat::tgs00026
#' regions::validate_nuts_regions(dat)
#' @family regions functions
#' @keywords internal
#' @seealso [regions::validate_nuts_regions()]
#' @export

harmonize_geo_code <- function(dat) {
  warning("The 'harmonize_geo_code' function is deprecated. Use instead regions::validate_nuts_regions(dat, nuts_year = 2016)")

  regions::validate_nuts_regions(dat, nuts_year = 2016)
}


#' @title Recode geo labels and rename regions from NUTS2013 to NUTS2016
#' @description Eurostat mixes NUTS2013 and NUTS2016 geographic label codes
#' in the `'geo'` column, which creates time-wise comparativity issues.
#'
#' This function is deprecated, and a more general function was moved to
#' `[regions::recode_nuts()]`.
#'
#' @param dat A Eurostat data frame downloaded with
#' [get_eurostat()].
#' @author Daniel Antal
#' @return An augmented and potentially relabelled data frame which
#' contains all formerly `'NUTS2013'` definition geo labels in the
#' `'NUTS2016'` vocabulary when only the code changed, but the
#' boundary did not. It also contains some information on other geo labels
#' that cannot be brought to the current `'NUTS2016'` definition.
#' Furthermore, when the official name of the region changed, it will use
#' the new name (if the otherwise the region boundary did not change.)
#' If not called before, the function will use the helper function
#' [harmonize_geo_code()]
#' @examples
#' test_regional_codes <- data.frame(
#'   geo = c("FRB", "FRE", "UKN02", "IE022", "FR243", "FRB03"),
#'   time = c(rep(as.Date("2014-01-01"), 5), as.Date("2015-01-01")),
#'   values = c(1:6),
#'   control = c(
#'     "Changed from NUTS2 to NUTS1",
#'     "New region NUTS2016 only",
#'     "Discontinued region NUTS2013",
#'     "Boundary shift NUTS2013",
#'     "Recoded in NUTS2013",
#'     "Recoded in NUTS2016"
#'   )
#' )
#'
#' recode_to_nuts_2016(test_regional_codes)
#' @importFrom regions recode_nuts
#' @family regions functions
#' @seealso [regions::recode_nuts()]
#' @keywords internal
#' @export

recode_to_nuts_2016 <- function(dat) {
  warning("The 'recode_to_nuts_2013' function is deprecated. Use instead regions::recode_nuts(dat, nuts_year = 2016)")

  regions::recode_nuts(dat, nuts_year = 2016)
}



#' @title Recode geo labels and rename regions from NUTS2016 to NUTS2013
#' @description Eurostat mixes NUTS2013 and NUTS2016 geographic label codes
#' in the `'geo'` column, which creates time-wise comparativity issues.
#'
#' This function is deprecated, and a more general function was moved to
#' `[regions::recode_nuts()]`.
#'
#' @param dat A Eurostat data frame downloaded with
#' [get_eurostat()].
#' @author Daniel Antal
#' @return An augmented and potentially relabelled data frame which
#' contains all formerly `'NUTS2013'` definition geo labels in the
#' `'NUTS2016'` vocabulary when only the code changed, but the
#' boundary did not. It also contains some information on other geo labels
#' that cannot be brought to the current `'NUTS2013'` definition.
#' Furthermore, when the official name of the region changed, it will use
#' the new name (if the otherwise the region boundary did not change.)
#' If not called before, the function will use the helper function
#' [harmonize_geo_code()]
#' @examples
#' test_regional_codes <- data.frame(
#'   geo = c("FRB", "FRE", "UKN02", "IE022", "FR243", "FRB03"),
#'   time = c(rep(as.Date("2014-01-01"), 5), as.Date("2015-01-01")),
#'   values = c(1:6),
#'   control = c(
#'     "Changed from NUTS2 to NUTS1",
#'     "New region NUTS2016 only",
#'     "Discontinued region NUTS2013",
#'     "Boundary shift NUTS2013",
#'     "Recoded in NUTS2013",
#'     "Recoded in NUTS2016"
#'   )
#' )
#'
#' recode_to_nuts_2013(test_regional_codes)
#' @importFrom regions recode_nuts
#' @family regions functions
#' @seealso [regions::recode_nuts()]
#' @keywords internal
#' @export

recode_to_nuts_2013 <- function(dat) {
  warning("The 'recode_to_nuts_2013' function is deprecated. Use instead regions::recode_nuts(dat, nuts_year = 2013)")

  recode_nuts(dat, nuts_year = 2013)
}
