#' Recode Region Codes From Source To Target NUTS Typology
#'
#' Validate your geo codes, pair them with the appropriate standard
#' typology, look up potential causes of invalidity in the EU correspondence
#' tables, and look up the appropriate geographical codes in the other
#' (target) typology.  For example, validate geo codes in the \code{'NUTS2016'}
#' typology and translate them to the now obsolete the \code{'NUTS2010'} typology
#' to join current data with historical data sets.
#' 
#' Imported from the \url{https://ropengov.github.io/regions/}{regions} package.
#' @param dat A data frame with a 3-5 character \code{geo_var} variable
#' to be validated.
#' @param geo_var Defaults to \code{"geo"}. The variable that contains
#' the 3-5 character geo codes to be validated.
#' @param nuts_year The year of the NUTS typology to use.
#' You can select any valid
#' NUTS definition, i.e. \code{1999}, \code{2003}, \code{2006},
#' \code{2010}, \code{2013}, the currently used \code{2016} and the
#' already announced and defined \code{2021}. Defaults to the current
#' typology in force, which is \code{2016}.
#' @importFrom regions recode_nuts(
#' @return The original data frame with a \code{'geo_var'} column is extended
#' with a \code{'typology'} column that states in which typology is the \code{'geo_var'}
#' a valid code.  For invalid codes, looks up potential reasons of invalidity
#' and adds them to the \code{'typology_change'} column, and at last it
#' adds a column of character vector containing the desired codes in the
#' target typology, for example, in the NUTS2013 typology.
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
#' @export

#' Validate Conformity With NUTS Geo Codes
#'
#' Validate that \code{geo_var} is conforming with the \code{NUTS1},
#' \code{NUTS2}, or \code{NUTS3} typologies.
#' While country codes are technically not part of the NUTS typologies,
#' Eurostat de facto uses a \code{NUTS0} typology to identify countries.
#' This de facto typology has three exception which are handled by the
#' \link[regions]{validate_nuts_countries} function.
#'
#' NUTS typologies have different versions, therefore the conformity
#' is validated with one specific versions, which can be any of these:
#' \code{1999}, \code{2003}, \code{2006}, \code{2010},
#'  \code{2013}, the currently used \code{2016} and the already
#'  announced and defined \code{2021}.
#'
#' The NUTS typology was codified with the \code{NUTS2003}, and the
#' pre-1999 NUTS typologies may confuse programmatic data processing,
#' given that some  NUTS1 regions were identified with country codes
#' in smaller countries that had no \code{NUTS1} divisions.
#'
#' Currently the \code{2016} is used by Eurostat, but many datasets
#' still contain \code{2013} and sometimes earlier metadata.
#'
#' @param dat A data frame with a 3-5 character \code{geo_var}
#' variable to be validated.
#' @param geo_var Defaults to \code{"geo"}. The variable that contains
#' the 3-5 character geo codes to be validated.
#' @param nuts_year The year of the NUTS typology to use.
#' Defaults to \code{2016}.  You can select any valid
#' NUTS definition, i.e. \code{1999}, \code{2003}, \code{2006},
#' \code{2010}, \code{2013}, the currently used \code{2016} and the
#' already announced and defined \code{2021}.
#' @importFrom regions validate_nuts_regions 
#' @return Returns the original \code{dat} data frame with a column
#' that specifies the comformity with the NUTS definition of the year
#' \code{nuts_year}.
#' @examples
#' \donttest{
#' my_reg_data <- data.frame (
#'   geo = c("BE1", "HU102", "FR1",
#'           "DED", "FR7", "TR", "DED2",
#'           "EL", "XK", "GB"),
#'   values = runif(10))
#'
#' validate_nuts_regions (my_reg_data)
#'
#' validate_nuts_regions (my_reg_data, nuts_year = 2013)
#'
#' validate_nuts_regions (my_reg_data, nuts_year = 2003)
#' }
#' @export


#' Validate Conformity with NUTS Geo Codes (vector)
#'
#' Validate that \code{geo} is conforming with the \code{NUTS1},
#' \code{NUTS2}, or \code{NUTS3} typologies.
#' While country codes are technically not part of the NUTS typologies,
#' Eurostat de facto uses a \code{NUTS0} typology to identify countries.
#' This de facto typology has three exception which are handled by the
#' \link[regions]{validate_nuts_countries} function.
#'
#' NUTS typologies have different versions, therefore the conformity
#' is validated with one specific versions, which can be any of these:
#' \code{1999}, \code{2003}, \code{2006}, \code{2010},
#'  \code{2013}, the currently used \code{2016} and the already
#'  announced and defined \code{2021}.
#'
#' The NUTS typology was codified with the \code{NUTS2003}, and the
#' pre-1999 NUTS typologies may confuse programmatic data processing,
#' given that some  NUTS1 regions were identified with country codes
#' in smaller countries that had no \code{NUTS1} divisions.
#'
#' Currently the \code{2016} is used by Eurostat, but many datasets
#' still contain \code{2013} and sometimes earlier metadata.
#' @param geo A vector of geographical code to validate.
#' @param nuts_year A valid NUTS edition year.
#' @importFrom regions validate_geo_code
#' @return A character list with the valid typology, or 'invalid' in the cases
#' when the geo coding is not valid.
#' @examples
#' \donttest{
#' my_reg_data <- data.frame (
#'   geo = c("BE1", "HU102", "FR1",
#'           "DED", "FR7", "TR", "DED2",
#'           "EL", "XK", "GB"),
#'   values = runif(10))
#'
#' validate_geo_code(my_reg_data$geo)
#' }
#' @export
