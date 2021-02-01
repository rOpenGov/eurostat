#' @title Correspondence Table NUTS2013-NUTS2016
#' @description A tidy version of the Eurostat correspondence for 
#' NUTS1 and NUTS2 territorial units.
#' @format A data_frame:
#' \describe{
#'   \item{code13}{The geographical code of the territory in the NUTS2013 definition}
#'   \item{code16}{The geographical code of the territory in the NUTS2016 definition}
#'   \item{name}{Name of the territorial unit in the Eurostat database}
#'   \item{nuts_level}{Aggregation level, i.e. 0=national, 1,2,3 for smaller regions.}
#'   \item{change}{Change with the region, or 'unchanged'}
#'   \item{resolution}{How can the comparison made between NUTS2013 and NUTS2016 units made, if possible.}
#' }
#' @source \url{https://ec.europa.eu/eurostat/web/nuts/history},
#'   \url{https://ec.europa.eu/eurostat/documents/345175/629341/NUTS2013-NUTS2016.xlsx}
"nuts_correspondence"
