#' @title Countries and Country Codes
#' @description Countries and country codes in EU,
#' Euro area, EFTA and EU candidate countries.
#' @format A data_frame:
#'   * **code**: Country code in the Eurostat database (two-letter ISO code (ISO 3166 alpha-2) except in the case of Greece where EL is used).
#'   * **name**: Country name in English.
#'   * **label**: Country name in the Eurostat database
#'   * **name_fr**: Country name in French
#'   * **name_de**: Country name in German
#'   * **country_language**: Country name in national language(s).
#'
#' @details
#' Country codes are two-letter ISO codes (ISO 3166 alpha-2) except in the case
#' of Greece where EL is used instead of the standard ISO code.
#'
#' @family datasets
#' @source <https://ec.europa.eu/eurostat/statistics-explained/index.php/Tutorial:Country_codes_and_protocol_order>,
#'   <https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Euro_area>
"eu_countries"

#' @rdname eu_countries
"ea_countries"

#' @rdname eu_countries
"efta_countries"

#' @rdname eu_countries
"eu_candidate_countries"
