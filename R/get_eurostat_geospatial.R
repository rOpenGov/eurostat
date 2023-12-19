#' @title Download Geospatial Data from GISCO
#'
#' @description Downloads either a simple features (sf) or a data_frame
#' of NUTS regions. This function is a wrapper of [giscoR::gisco_get_nuts()].
#' This function requires to have installed the packages \CRANpkg{sf} and
#' \CRANpkg{giscoR}.
#'
#' @seealso [giscoR::gisco_get_nuts()]
#' @param output_class Class of object returned,
#'   either `sf` `simple features` or `df` (`data_frame`). `spdf` output has
#'   been soft-deprecated, the function would switch to `sf`.
#' @param resolution Resolution of the geospatial data. One of
#'    * "60" (1:60million),
#'    * "20" (1:20million)
#'    * "10" (1:10million)
#'    * "03" (1:3million) or
#'    * "01" (1:1million).
#' @param nuts_level Level of NUTS classification of the geospatial data. One of
#'    "0", "1", "2", "3" or "all" (mimics the original behaviour)
#' @param year NUTS release year. One of
#'    "2003", "2006", "2010", "2013", "2016" or "2021"
#' @param cache a logical whether to do caching. Default is `TRUE`.
#' @param update_cache a logical whether to update cache. Can be set also with
#'        `options(eurostat_update = TRUE)`
#' @param cache_dir a path to a cache directory. See
#'   [set_eurostat_cache_dir()]. If `NULL` and the cache dir has not been set
#'   globally the file would be stored in the [tempdir()].
#' @param crs projection of the map: 4-digit
#'   [EPSG code](https://spatialreference.org/ref/epsg/). One of:
#'  * "4326" - WGS84
#'  * "3035" - ETRS89 / ETRS-LAEA
#'  * "3857" - Pseudo-Mercator
#'
#' @param make_valid Deprecated
#'
#' @inheritDotParams giscoR::gisco_get_nuts -epsg
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
#'
#' @export
get_eurostat_geospatial <- function(output_class = "sf",
                                    resolution = "60",
                                    nuts_level = "all", year = "2016",
                                    cache = TRUE, update_cache = FALSE,
                                    cache_dir = NULL, crs = "4326",
                                    make_valid = "DEPRECATED", ...) {
  # nocov start
  if (!requireNamespace("sf")) {
    message("'sf' package is required for geospatial functionalities")
    return(invisible())
  }
  # nocov end
  # Simplified and leaving most of the heavy-lifting to giscoR

  # Deprecation messages
  stopifnot(length(output_class) == 1L)
  if (output_class == "spdf") {
    message("'spdf' output deprecated. Switching to sf output")
    output_class <- "sf"
  }

  if (!identical(make_valid, "DEPRECATED")) {
    message("'make_valid' argument has been deprecated")
  }

  # Leaving only specific validations - rest of call would be handled by giscoR
  output_class <- match.arg(as.character(output_class), c("sf", "df"))

  # Sanity check for nuts_level
  stopifnot(length(nuts_level) == 1L)
  nuts_level <- regmatches(nuts_level, regexpr("^(all|[0-9]+)", nuts_level))
  nuts_level <- match.arg(nuts_level, c("all", 0:3))

  # Performance - If df requested resolution and crs are meaningless. Switching
  # to 60 and 4326 for speed (except for 2003, no available)
  if (output_class == "df") {
    resolution <- "60"
    crs <- "4326"

    if (as.integer(year) == 2003) resolution <- "20"
  }


  # If cache file requested get the info from the internal dataset
  capture_dots <- list(...)

  # Check if the pre-set call to the function has been modified on
  # relevant parameters
  use_local <- all(
    as.character(resolution) == "60",
    as.character(year) == "2016",
    isFALSE(update_cache),
    as.character(crs) == "4326",
    # Check dots are empty
    length(capture_dots) == 0
  )

  if (use_local) {
    # Not modified - using dataset included with eurostat package
    message("Extracting data from eurostat::eurostat_geodata_60_2016")
    shp <- eurostat::eurostat_geodata_60_2016
    if (nuts_level != "all") {
      shp <- shp[shp$LEVL_CODE == nuts_level, ]
    }
  } else {
    # Check if package "giscoR" is installed
    # nocov start
    if (!requireNamespace("giscoR")) {
      message("'giscoR' package is required for geospatial functionalities")
      return(invisible())
    }
    # nocov end

    message(paste0(
      "Extracting data using giscoR package, please report issues",
      " on https://github.com/rOpenGov/giscoR/issues"
    ))

    # Manage cache: Priority is eurostat cache (if set)
    # If not make use of giscoR default options
    detect_eurostat_cache <- eur_helper_detect_cache_dir()
    if (!is.null(cache_dir)) {
      # Already set by the user, no need message
      cache_dir <- eur_helper_cachedir(cache_dir)
    } else if (identical(
      detect_eurostat_cache,
      file.path(tempdir(), "eurostat")
    )) {
      # eurostat not set, using default giscoR cache management
      message("Cache management as per giscoR. see 'giscoR::gisco_get_nuts()'")
    } else {
      cache_dir <- eur_helper_cachedir(cache_dir)
    }

    # giscoR call with parameters
    # on input errors giscoR would show warnings, etc
    shp <- giscoR::gisco_get_nuts(
      resolution = resolution,
      nuts_level = nuts_level, year = year,
      cache = cache, update_cache = update_cache,
      cache_dir = cache_dir, epsg = crs,
      ...
    )
  }

  # Just to capture potential NULL outputs from giscoR - this can happen
  # on some errors
  if (is.null(shp)) {
    return(NULL)
  }

  # Post-data treatments
  # Manage col names
  shp <- geo_names(shp)

  # to df
  if (output_class == "df") {
    # Remove geometry
    shp <- sf::st_drop_geometry(shp)
  }

  return(shp)
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
