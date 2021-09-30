#' @title Recode Region Codes From Source To Target NUTS Typology
#' @param dat A data frame with a 3-5 character `geo_var` variable
#' to be validated.
#' @param geo_var Defaults to `"geo"`. The variable that contains
#' the 3-5 character geo codes to be validated.
#' @param nuts_year The year of the NUTS typology to use.
#' You can select any valid
#' NUTS definition, i.e. `1999`, `2003`, `2006`,
#' `2010`, `2013`, the currently used `2016` and the
#' already announced and defined `2021`. Defaults to the current
#' typology in force, which is `2016`.
#' @importFrom regions recode_nuts
#' @return The original data frame with a `'geo_var'` column is extended
#' with a `'typology'` column that states in which typology is the `'geo_var'`
#' a valid code.  For invalid codes, looks up potential reasons of invalidity
#' and adds them to the `'typology_change'` column, and at last it
#' adds a column of character vector containing the desired codes in the
#' target typology, for example, in the NUTS2013 typology.
#' @family regions functions
#' @export
#' @examples{
#' foo <- data.frame (
#'   geo  =  c("FR", "DEE32", "UKI3" ,
#'             "HU12", "DED",
#'             "FRK"),
#'   values = runif(6, 0, 100 ),
#'   stringsAsFactors = FALSE )
#'
#' recode_nuts(foo, nuts_year = 2013)
#' }
regions::recode_nuts

#' @title Validate Conformity With NUTS Geo Codes
#' @details While country codes are technically not part of the NUTS typologies,
#' Eurostat de facto uses a `NUTS0` typology to identify countries.
#' This de facto typology has three exception which are handled by the
#' [validate_nuts_countries][regions::validate_nuts_countries] function.
#'
#' NUTS typologies have different versions, therefore the conformity
#' is validated with one specific versions, which can be any of these:
#' `1999`, `2003`, `2006`, `2010`,
#'  `2013`, the currently used `2016` and the already
#'  announced and defined `2021`.
#'
#' The NUTS typology was codified with the `NUTS2003`, and the
#' pre-1999 NUTS typologies may confuse programmatic data processing,
#' given that some  NUTS1 regions were identified with country codes
#' in smaller countries that had no `NUTS1` divisions.
#'
#' Currently the `2016` is used by Eurostat, but many datasets
#' still contain `2013` and sometimes earlier metadata.
#'
#' @param dat A data frame with a 3-5 character `geo_var`
#' variable to be validated.
#' @param geo_var Defaults to `"geo"`. The variable that contains
#' the 3-5 character geo codes to be validated.
#' @param nuts_year The year of the NUTS typology to use.
#' Defaults to `2016`.  You can select any valid
#' NUTS definition, i.e. `1999`, `2003`, `2006`,
#' `2010`, `2013`, the currently used `2016` and the
#' already announced and defined `2021`.
#' @importFrom regions validate_nuts_regions
#' @return Returns the original `dat` data frame with a column
#' that specifies the comformity with the NUTS definition of the year
#' `nuts_year`.
#' @family regions functions
#' @export
#' @examples
#' \donttest{
#' my_reg_data <- data.frame(
#'   geo = c(
#'     "BE1", "HU102", "FR1",
#'     "DED", "FR7", "TR", "DED2",
#'     "EL", "XK", "GB"
#'   ),
#'   values = runif(10)
#' )
#'
#' validate_nuts_regions(my_reg_data)
#'
#' validate_nuts_regions(my_reg_data, nuts_year = 2013)
#'
#' validate_nuts_regions(my_reg_data, nuts_year = 2003)
#' }
regions::validate_nuts_regions


#' @title Validate Conformity with NUTS Geo Codes (vector)
#' @param geo A vector of geographical code to validate.
#' @param nuts_year A valid NUTS edition year.
#' @importFrom regions validate_geo_code
#' @family regions functions
#' @return A character list with the valid typology, or 'invalid' in the cases
#' when the geo coding is not valid.
#' @export
#' @examples
#' \donttest{
#' my_reg_data <- data.frame(
#'   geo = c(
#'     "BE1", "HU102", "FR1",
#'     "DED", "FR7", "TR", "DED2",
#'     "EL", "XK", "GB"
#'   ),
#'   values = runif(10)
#' )
#'
#' validate_geo_code(my_reg_data$geo)
#' }
regions::validate_geo_code
