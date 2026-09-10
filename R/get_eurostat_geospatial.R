#' @title Download Geospatial Data from GISCO
#'
#' @description Downloads either a simple features (sf) or a data_frame
#' of NUTS regions. This function is a wrapper of \CRANpkg{giscoR} function
#' `gisco_get_nuts()`.
#' This function requires to have packages \CRANpkg{sf} and
#' \CRANpkg{giscoR} installed.
#'
#' @seealso giscoR package and its functions
#' @param output_class Class of object returned,
#'   either `sf` `simple features` or `df` (`data_frame`). `spdf` output has
#'   been soft-deprecated, the function will switch to `sf`.
#' @param resolution Resolution of the geospatial data. One of
#'    * "60" (1:60million),
#'    * "20" (1:20million)
#'    * "10" (1:10million)
#'    * "03" (1:3million) or
#'    * "01" (1:1million).
#' @param nuts_level Level of NUTS classification of the geospatial data. One of
#'    "0", "1", "2", "3" or "all" (mimics the original behaviour)
#' @param year NUTS release year. One of
#'    "2003", "2006", "2010", "2013", "2016", "2021" or "2024"
#' @param crs projection of the map: 4-digit
#'   [EPSG code](https://spatialreference.org/ref/epsg/). One of:
#'  * "4326" - WGS84
#'  * "3035" - ETRS89 / ETRS-LAEA
#'  * "3857" - Pseudo-Mercator
#' @param ... additional arguments to be passed onto \CRANpkg{giscoR} function
#' `gisco_get_nuts()`
#'
#' @inheritParams get_eurostat
#'
#' @details
#' The objects downloaded from GISCO should contain all or some of the
#' following variable columns:
#' * **id**: JSON id code, the same as **NUTS_ID**. See **NUTS_ID** below for
#'   further clarification.
#' * **LEVL_CODE**: NUTS level code: 0 (national level), 1 (major
#'   socio-economic regions), 2 (basic regions for the application of regional
#'   policies) or 3 (small regions).
#' * **NUTS_ID**: NUTS ID code, consisting of country code and numbers (1 for
#'   NUTS 1, 2 for NUTS 2 and 3 for NUTS 3)
#' * **CNTR_CODE**: Country code: two-letter ISO code (ISO 3166 alpha-2), except
#'   in the case of Greece (EL).
#' * **NAME_LATN**: NUTS name in local language, transliterated to Latin script
#' * **NUTS_NAME**: NUTS name in local language, in local script.
#' * **MOUNT_TYPE**: Mountain typology for NUTS 3 regions.
#'   * 1: "where more than 50 % of the surface is covered by topographic
#'     mountain areas"
#'   * 2: "in which more than 50 % of the regional population lives in
#'     topographic mountain areas"
#'   * 3: "where more than 50 % of the surface is covered by topographic
#'     mountain areas and where more than 50 % of the regional population lives
#'     in these mountain areas"
#'   * 4: non-mountain region / other region
#'   * 0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2 and
#'     non-EU countries)
#' * **URBN_TYPE**: Urban-rural typology for NUTS 3 regions.
#'   * 1: predominantly urban region
#'   * 2: intermediate region
#'   * 3: predominantly rural region
#'   * 0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2
#'     regions)
#' * **COAST_TYPE**: Coastal typology for NUTS 3 regions.
#'   * 1: coastal (on coast)
#'   * 2: coastal (>= 50% of population living within 50km of the coastline)
#'   * 3: non-coastal region
#'   * 0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2
#'     regions)
#' * **FID**: Same as NUTS_ID.
#' * **geo**: Same as NUTS_ID, added for for easier joins with dplyr. Consider
#'   the status of this column "questioning" and use other columns for joins
#'   when possible.
#' * **geometry**: geospatial information.
#'
#' @author
#' Markus Kainu <markuskainu@gmail.com>, Diego Hernangomez
#' <https://github.com/dieghernan/>
#' @return a sf or data_frame
#'
#' @source
#' Data source: Eurostat
#'
#' © EuroGeographics for the administrative boundaries
#'
#' Data downloaded using \pkg{giscoR}
#'
#' @inheritSection eurostat-package Eurostat: Copyright notice and free re-use of data
#' @inheritSection eurostat-package Data source: GISCO - General Copyright
#' @inheritSection eurostat-package Data source: GISCO - Administrative Units / Statistical Units
#'
#' @family geospatial
#' @examples
#' \donttest{
#' # Uses cached dataset
#' sf <- get_eurostat_geospatial(
#'   output_class = "sf",
#'   resolution = "60",
#'   nuts_level = "all"
#' )
#' \dontrun{
#' # Downloads dataset from server
#' sf2 <- get_eurostat_geospatial(
#'   output_class = "sf",
#'   resolution = "20",
#'   nuts_level = "all"
#' )
#' df <- get_eurostat_geospatial(
#'   output_class = "df",
#'   nuts_level = "0"
#' )
#' }
#' }
#'
#' @importFrom utils modifyList
#'
#' @export
get_eurostat_geospatial <- function(output_class = "sf",
                                    resolution = "60",
                                    nuts_level = "all", year = "2024",
                                    cache = TRUE, update_cache = FALSE,
                                    cache_dir = NULL, crs = "4326",
                                    verbose = TRUE, ...) {

  # sf is always required
  if (!requireNamespace("sf", quietly = TRUE)) {
    if (verbose) message("'sf' package is required for geospatial functionalities")
    return(invisible())
  }

  has_gisco <- requireNamespace("giscoR", quietly = TRUE)

  # Deprecation handling
  stopifnot(length(output_class) == 1L)
  if (output_class == "spdf") {
    if (verbose) message("'spdf' output deprecated. Switching to sf output")
    output_class <- "sf"
  }

  output_class <- match.arg(as.character(output_class), c("sf", "df"))

  # ---- Determine whether we should use local data ----
  use_local <- all(
    as.character(resolution) == "60",
    as.character(year) == "2024",
    isFALSE(update_cache),
    as.character(crs) == "4326",
    length(list(...)) == 0
  )

  # FORCE local if giscoR not available
  if (!has_gisco) {
    use_local <- TRUE
    if (verbose) {
      message("Package 'giscoR' not installed: using local dataset only")
    }
  }

  # ---- LOCAL BRANCH ----
  if (use_local) {
    if (verbose) {
      message("Extracting data from eurostat::eurostat_geodata_60_2024")
    }

    shp <- eurostat::eurostat_geodata_60_2024

    if (nuts_level != "all") {
      shp <- shp[shp$LEVL_CODE == nuts_level, ]
    }

  } else {

    # ---- REMOTE BRANCH (safe: giscoR exists here) ----

    # defaults only accessed AFTER we know giscoR exists
    default_args <- as.list(formals(giscoR::gisco_get_nuts))
    args <- utils::modifyList(default_args, list(...))

    args$resolution <- resolution
    args$nuts_level <- nuts_level
    args$year <- year
    args$epsg <- crs
    args$cache <- cache
    args$update_cache <- update_cache
    args$cache_dir <- cache_dir

    # Sanity check
    stopifnot(length(args$nuts_level) == 1L)
    args$nuts_level <- regmatches(args$nuts_level, regexpr("^(all|[0-9]+)", args$nuts_level))
    args$nuts_level <- match.arg(args$nuts_level, c("all", 0:3))

    # Performance tweak
    if (output_class == "df") {
      args$resolution <- "60"
      args$epsg <- "4326"
      if (as.integer(args$year) == 2003) args$resolution <- "20"
    }

    if (verbose) {
      message(
        "Extracting data using giscoR package, please report issues ",
        "on https://github.com/rOpenGov/giscoR/issues"
      )
    }

    shp <- do.call(giscoR::gisco_get_nuts, args)
  }

  # Handle NULL safely
  if (is.null(shp)) return(NULL)

  # Post-processing
  shp <- geo_names(shp)

  if (output_class == "df") {
    shp <- sf::st_drop_geometry(shp)
  }

  shp
}


# Helper function, add names and reorder
geo_names <- function(x) {
  # Case for border (BN), there are no NUTS_ID , do nothing
  if (!"NUTS_ID" %in% names(x)) {
    return(x)
  }


  # Add `id` and `geo` column for easier joins with dplyr
  x$geo <- x$NUTS_ID
  x$id <- x$geo

  # Arrange names in proper order
  the_geom <- sf::st_geometry(x)
  the_df <- sf::st_drop_geometry(x)
  rest <- c(
    "id", "LEVL_CODE", "NUTS_ID", "CNTR_CODE", "NAME_LATN", "NUTS_NAME",
    "MOUNT_TYPE", "URBN_TYPE", "COAST_TYPE", "FID", "geo"
  )

  # Check what needed columns are not present in the source file
  miss_cols <- setdiff(unique(rest), names(the_df))
  extra_cols <- setdiff(names(the_df), rest)


  # Add missing cols with NAs
  list_df <- lapply(miss_cols, function(x) {
    template_df <- data.frame(somecol = NA)
    names(template_df) <- x
    template_df
  })
  new_df <- dplyr::bind_cols(c(list(the_df), list_df))

  # Final column order
  order_cols <- unique(c(rest, extra_cols))
  xend <- new_df[, order_cols]

  # Back to sf
  final_sf <- sf::st_sf(xend, geometry = the_geom)

  final_sf
}
