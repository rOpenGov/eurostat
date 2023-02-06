#' @title Download Geospatial Data from GISCO
#'
#' @description Downloads either a simple features (sf),
#' SpatialPolygonDataFrame or a data_frame preprocessed using [broom::tidy()].
#' @param output_class A string. Class of object returned,
#' either `sf` `simple features`, `df` (`data_frame`) or
#'    `spdf` (`SpatialPolygonDataFrame`)
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
#' @param cache a logical whether to do caching. Default is `TRUE`. Affects
#'        only queries from the bulk download facility.
#' @param update_cache a logical whether to update cache. Can be set also with
#'        options(eurostat_update = TRUE)
#' @param cache_dir a path to a cache directory. The directory have to exist.
#'        The `NULL` (default) uses and creates
#'        'eurostat' directory in the temporary directory from
#'        [tempdir()]. Directory can also be set with
#'        `option` eurostat_cache_dir.
#' @param crs projection of the map: 4-digit
#'   [EPSG code](https://spatialreference.org/ref/epsg/). One of:
#'  * "4326" - WGS84
#'  * "3035" - ETRS89 / ETRS-LAEA
#'  * "3857" - Pseudo-Mercator
#'
#' @param make_valid logical; ensure that valid (multi-)polygon features are
#'        returned if `output_class="sf"`, see Details. Current default
#'        `FALSE`, will be changed in the future.
#'
#' @details The data source URL is
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>.
#' The source provides feature collections as line strings (GeoJSON format),
#' not as (multi-)polygons which, in some cases, yields invalid
#' self-intersecting (multi-)polygon geometries (for some years/resolutions).
#' This can cause problems, e.g., when using these geometries as input argument
#' to [sf::st_interpolate_aw()]. `make_valid = TRUE` makes sure that
#' only valid (multi-)polygons are returned, example included below.
#' 
#' The objects downloaded from GISCO should contain all or some of the 
#' following variable columns:
#' * **id**: JSON id code, the same as NUTS_ID. See NUTS_ID below for further clarification.
#' * **LEVL_CODE**: NUTS level code: 0 (national level), 1 (major socio-economic regions), 2 (basic regions for the application of regional policies) or 3 (small regions).
#' * **NUTS_ID**: NUTS ID code, consisting of country code and numbers (1 for NUTS 1, 2 for NUTS 2 and 3 for NUTS 3)
#' * **CNTR_CODE**: Country code: two-letter ISO code (ISO 3166 alpha-2), except in the case of Greece (EL).
#' * **NAME_LATN**: NUTS name in local language, transliterated to Latin script
#' * **NUTS_NAME**: NUTS name in local language, in local script.
#' * **MOUNT_TYPE**: Mountain typology for NUTS 3 regions.
#' \itemize{
#'   \item{1: "where more than 50 % of the surface is covered by topographic mountain areas"}
#'   \item{2: "in which more than 50 % of the regional population lives in topographic mountain areas"}
#'   \item{3: "where more than 50 % of the surface is covered by topographic mountain areas and where more than 50 % of the regional population lives in these mountain areas"} 
#'   \item{4: non-mountain region / other region}
#'   \item{0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2 and non-EU countries)}
#' }
#' * **URBN_TYPE**: Urban-rural typology for NUTS 3 regions.
#' \itemize{
#'   \item{1: predominantly urban region}
#'   \item{2: intermediate region}
#'   \item{3: predominantly rural region}
#'   \item{0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2 regions)}
#' }
#' * **COAST_TYPE**: Coastal typology for NUTS 3 regions. 
#' \itemize{
#'   \item{1: coastal (on coast)}
#'   \item{2: coastal (>= 50% of population living within 50km of the coastline)}
#'   \item{3: non-coastal region}
#'   \item{0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2 regions)}
#' }
#' * **FID**: Same as NUTS_ID.
#' * **geometry**: geospatial information.
#' * **geo**: Same as NUTS_ID, added for for easier joins with dplyr. However, it is recommended to use other identical fields for this purpose.
#' 
#' @author Markus Kainu <markuskainu@gmail.com>
#' @return a sf, data_frame or SpatialPolygonDataFrame.
#' 
#' @source 
#' Data source: Eurostat
#' 
#' © EuroGeographics for the administrative boundaries
#' 
#' Data downloaded from: \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}
#' @references 
#' The following copyright notice is provided for end user convenience. 
#' Please check up-to-date copyright information from the eurostat website:
#' [GISCO: Geographical information and maps - Administrative units/statistical units](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units)
#' 
#' "In addition to the [general copyright and licence policy](https://ec.europa.eu/eurostat/web/main/about/policies/copyright) applicable to the whole Eurostat website, the following specific provisions apply to the datasets you are downloading. The download and usage of these data is subject to the acceptance of the following clauses:
#' 
#' 1. The Commission agrees to grant the non-exclusive and not transferable
#' right to use and process the Eurostat/GISCO geographical data downloaded
#' from this page (the "data").
#' 
#' 1. The permission to use the data is granted on condition that:
#' \enumerate{
#'   \item{the data will not be used for commercial purposes;}
#'   \item{the source will be acknowledged. A copyright notice, as specified 
#'   below, will have to be visible on any printed or electronic publication 
#'   using the data downloaded from this page.}
#' }
#' ## Copyright notice
#' 
#' When data downloaded from this page is used in any printed or electronic
#' publication, in addition to any other provisions applicable to the whole
#' Eurostat website, data source will have to be acknowledged in the legend of
#' the map and in the introductory page of the publication with the following
#' copyright notice:
#' 
#' EN: © EuroGeographics for the administrative boundaries
#' 
#' FR: © EuroGeographics pour les limites administratives
#' 
#' DE: © EuroGeographics bezüglich der Verwaltungsgrenzen
#' 
#' For publications in languages other than English, French or German, the 
#' translation of the copyright notice in the language of the publication shall
#' be used.
#' 
#' If you intend to use the data commercially, please contact EuroGeographics 
#' for information regarding their licence agreements."
#' 
#' @family geospatial
#' @examples
#' \donttest{
#' sf <- get_eurostat_geospatial(
#'   output_class = "sf",
#'   resolution = "60",
#'   nuts_level = "all"
#' )
#' df <- get_eurostat_geospatial(
#'   output_class = "df",
#'   resolution = "20",
#'   nuts_level = "0"
#' )
#' }
#'
#' \dontrun{
#' spdf <- get_eurostat_geospatial(
#'   output_class = "spdf",
#'   resolution = "10",
#'   nuts_level = "3"
#' )
#' }
#'
#' \dontrun{
#' # -------------------------------------------------------------------
#' # Minimal example to demonstrate reason/effect of 'make_valid = TRUE'
#' # Spatial data set; rectangle spanning the entire globe with a constant value of 1L.
#' # Requires the R package sf.
#' library("sf")
#' d <- c(-180, -90, -180, 90, 180, 90, 180, -90, -180, -90)
#' poly <- st_polygon(list(matrix(d, ncol = 2, byrow = TRUE)))
#' data <- st_sf(data.frame(geom = st_sfc(poly), data = 1L),
#'   crs = st_crs(4326)
#' )
#'
#' # Causing an error: Self-intersection of some points of the geometry
#' NUTS2_A <- get_eurostat_geospatial("sf", 60,
#'   nuts_level = 2, year = 2013,
#'   crs = 4326, make_valid = FALSE
#' )
#' res <- tryCatch(st_interpolate_aw(data, NUTS2_A, extensive = FALSE),
#'   error = function(e) e
#' )
#' print(res)
#'
#' # Resolving the problem using
#' # make_valid = TRUE. 'extensive = FALSE' returns
#' # average over each area, thus resulting in a
#' # constant value of 1 for each geometry in NUTS2_B.
#' NUTS2_B <- get_eurostat_geospatial("sf", 60,
#'   nuts_level = 2, year = 2013,
#'   crs = 4326, make_valid = TRUE
#' )
#' res <- st_interpolate_aw(data, NUTS2_B, extensive = FALSE)
#' print(head(res))
#' }
#'
#' @importFrom utils data
#' @importFrom broom tidy
#' @importFrom httr http_error content RETRY
#' @importFrom methods as
#' @importFrom dplyr left_join
#'
#' @export
get_eurostat_geospatial <- function(output_class = "sf",
                                    resolution = "60",
                                    nuts_level = "all", year = "2016",
                                    cache = TRUE, update_cache = FALSE,
                                    cache_dir = NULL, crs = "4326",
                                    make_valid = FALSE) {
  # Check if package "sf" is installed
  if (!requireNamespace("sf")) {
    message("'sf' package is required for geospatial functionalities")
    return(invisible())
  }

  if (output_class == "spdf" && !requireNamespace("sp")) {
    message("'sp' package is required for spdf output")
    return(invisible())
  }

  # Check if you have access to ec.europe.eu.
  if (!check_access_to_data()) {
    message("You have no access to ec.europe.eu.
             Please check your connection and/or review your proxy settings")
  } else {
    eurostat_geodata_60_2016 <- NULL
    LEVL_CODE <- NULL
    utils::data("eurostat_geodata_60_2016",
      envir = environment(),
      package = "eurostat"
    )

    # Check output_class is of correct format
    stopifnot(length(output_class) == 1L)
    output_class <- match.arg(as.character(output_class), c("sf", "df", "spdf"))

    # Check resolution is of correct format
    stopifnot(length(resolution) == 1L)
    resolution <- as.integer(regmatches(resolution, regexpr(
      "^[0-9]+",
      resolution
    )))
    resolution <- sprintf("%02d", match.arg(
      as.character(resolution),
      c(1, 3, 10, 20, 60)
    ))

    # Sanity check for nuts_level
    stopifnot(length(nuts_level) == 1L)
    nuts_level <- regmatches(nuts_level, regexpr("^(all|[0-9]+)", nuts_level))
    nuts_level <- match.arg(nuts_level, c("all", 0:3))

    # Check year is of correct format
    year <- match.arg(as.character(year), c(2003, 2006, 2010, 2013, 2016, 2021))

    # Sanity check for cache and update_cache
    stopifnot(is.logical(cache) && length(cache) == 1 &&
      cache %in% c(TRUE, FALSE))
    stopifnot(is.logical(update_cache) && length(update_cache) == 1 &&
      update_cache %in% c(TRUE, FALSE))

    # Sanity check for cache_dir
    stopifnot(is.null(cache_dir) || (is.character(cache_dir) &&
      length(cache_dir) == 1L))

    # Check crs is of correct format
    crs <- match.arg(as.character(crs), c(4326, 3035, 3857))

    # Invalid combination of year and resolution: stop and show
    # hint/error message.
    if (as.numeric(year) == 2003 & as.numeric(resolution) == 60) {
      stop("NUTS 2003 is not provided at 1:60 million resolution.
          Try 1:1 million, 1:3 million, 1:10 million or 1:20 million")
    }

    # Sanity check for input `make_valid`
    stopifnot(is.logical(make_valid) && length(make_valid) == 1L &&
      make_valid %in% c(TRUE, FALSE))

    #   message("
    # COPYRIGHT NOTICE
    #
    # When data downloaded from this page
    # <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
    # is used in any printed or electronic publication,
    # in addition to any other provisions
    # applicable to the whole Eurostat website,
    # data source will have to be acknowledged
    # in the legend of the map and
    # in the introductory page of the publication
    # with the following copyright notice:
    #
    # - EN: (C) EuroGeographics for the administrative boundaries
    # - FR: (C) EuroGeographics pour les limites administratives
    # - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
    #
    # For publications in languages other than
    # English, French or German,
    # the translation of the copyright notice
    # in the language of the publication shall be used.
    #
    # If you intend to use the data commercially,
    # please contact EuroGeographics for
    # information regarding their licence agreements.
    #       ")

    if (resolution == "60" && year == "2016" && crs == "4326") {

      # nuts_levels are mutually exclusive; either "all"
      # or one of "0", "1", "2", "3".
      if (nuts_level == c("all")) {
        shp <- eurostat_geodata_60_2016
      } else {
        shp <- filter(eurostat_geodata_60_2016, LEVL_CODE == as.integer(nuts_level))
      }

      if (output_class == "df") {
        nuts_sp <- as(shp, "Spatial")
        nuts_sp$id <- row.names(nuts_sp)
        nuts_ff <- broom::tidy(nuts_sp)
        shp <- dplyr::left_join(nuts_ff, nuts_sp@data)
      } else if (output_class == "spdf") {
        shp <- methods::as(shp, "Spatial")
      }
    } else {
      if (cache) {

        # check option for update
        update_cache <- update_cache | getOption("eurostat_update", FALSE)

        # get cache directory
        cache_dir <- eur_helper_cachedir(cache_dir)


        # cache filename
        cache_file <- file.path(
          cache_dir,
          paste0(
            output_class, resolution,
            nuts_level, year, crs, ".RData"
          )
        )
        message("Object cached at ", path.expand(cache_file))
      }

      # if cache = FALSE or update or new: download else read from cache
      if (!cache | update_cache | !file.exists(cache_file)) {
        burl <- "http://ec.europa.eu/eurostat/cache/GISCO/distribution/v2/nuts/geojson/NUTS_RG_"

        if (nuts_level %in% c("0", "all")) {
          url <- paste0(burl, resolution, "M_", year, "_", crs, "_LEVL_0.geojson")
          resp <- httr::RETRY("GET", url, terminate_on = c(404))
          if (httr::http_error(resp)) {
            stop(paste("The requested url cannot be found within
          the get_eurostat_geospatial function:", url))
          } else {
            nuts0 <- sf::st_read(httr::content(resp, as = "text", encoding = "UTF-8"),
              stringsAsFactors = FALSE, quiet = TRUE
            )
          }
        }
        if (nuts_level %in% c("1", "all")) {
          url <- paste0(burl, resolution, "M_", year, "_", crs, "_LEVL_1.geojson")
          resp <- httr::RETRY("GET", url, terminate_on = c(404))
          if (httr::http_error(resp)) {
            stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
          } else {
            nuts1 <- sf::st_read(httr::content(resp, as = "text", encoding = "UTF-8"),
              stringsAsFactors = FALSE, quiet = TRUE
            )
          }
        }
        if (nuts_level %in% c("2", "all")) {
          resp <- httr::RETRY("GET", paste0(burl, resolution, "M_", year, "_", crs, "_LEVL_2.geojson"), terminate_on = c(404))
          if (httr::http_error(resp)) {
            stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
          } else {
            nuts2 <- sf::st_read(httr::content(resp, as = "text", encoding = "UTF-8"),
              stringsAsFactors = FALSE, quiet = TRUE
            )
          }
        }
        if (nuts_level %in% c("3", "all")) {
          resp <- httr::RETRY("GET", paste0(burl, resolution, "M_", year, "_", crs, "_LEVL_3.geojson"), terminate_on = c(404))
          if (httr::http_error(resp)) {
            stop(paste("The requested url cannot be found within the get_eurostat_geospatial function:", url))
          } else {
            nuts3 <- sf::st_read(httr::content(resp, as = "text", encoding = "UTF-8"),
              stringsAsFactors = FALSE, quiet = TRUE
            )
          }
        }

        if (nuts_level == "all") {
          shp <- rbind(nuts0, nuts1, nuts2, nuts3)
        } else {
          shp <- eval(parse(text = paste0("nuts", nuts_level)))
        }

        if (output_class == "df") {
          nuts_sp <- as(shp, "Spatial")
          nuts_sp$id <- row.names(nuts_sp)
          nuts_ff <- broom::tidy(nuts_sp)
          shp <- left_join(nuts_ff, nuts_sp@data)
        }
        if (output_class == "spdf") {
          shp <- as(shp, "Spatial")
        }
      }
    }

    if (!(resolution == "60" & year == "2016" & crs == "4326")) {
      if (cache & file.exists(cache_file)) {
        cf <- path.expand(cache_file)
        message(paste("Reading cache file", cf))
        load(file = cache_file)
        if (output_class == "sf") {
          message(paste(
            "sf at resolution 1:",
            resolution, " from year ",
            year, " read from cache file: ",
            cf
          ))
        }
        if (output_class == "df") {
          message(paste(
            "data_frame at resolution 1:",
            resolution, " from year ",
            year, " read from cache file: ",
            cf
          ))
        }
        if (output_class == "spdf") {
          message(paste(
            "SpatialPolygonDataFrame at resolution 1:",
            resolution, " from year ",
            year, " read from cache file: ",
            cf
          ))
        }
      }

      # if update or new: save
      if (cache && (update_cache || !file.exists(cache_file))) {
        save(shp, file = cache_file)
        if (output_class == "sf") {
          message(paste(
            "sf at resolution 1:",
            resolution, " cached at: ",
            path.expand(cache_file)
          ))
        }
        if (output_class == "df") {
          message(paste(
            "data_frame at resolution 1:",
            resolution, " cached at: ",
            path.expand(cache_file)
          ))
        }
        if (output_class == "spdf") {
          message(paste(
            "SpatialPolygonDataFrame at resolution 1:",
            resolution, " cached at: ",
            path.expand(cache_file)
          ))
        }
      }
    }

    if (resolution == "60" & year == 2016 & crs == "4326") {
      if (output_class == "sf") message("sf at resolution 1:60 read from local file")
      if (output_class == "df") message("data_frame at resolution 1:60 read from local file")
      if (output_class == "spdf") message("SpatialPolygonDataFrame at resolution 1:60 read from local file")
    }

    #   message("
    # # --------------------------
    # HEADS UP!!
    #
    # Function get_eurostat_geospatial now returns the data in 'sf'-class (simple features)
    # by default which is different from previous behaviour's 'SpatialPolygonDataFrame'.
    #
    # If you prefer either 'SpatialPolygonDataFrame' or
    # fortified 'data_frame' (for ggplot2::geom_polygon),
    # please specify it explicitly to 'output_class'-argument!
    #
    # # --------------------------
    #           ")
    if (output_class == "sf" & make_valid) {
      shp <- sf::st_buffer(shp, 0)
    } else {
      warning(paste(
        "Default of 'make_valid' for 'output_class=\"sf\"'",
        "will be changed in the future (see function details)."
      ))
    }

    # Adding a `geo` column for easier joins with dplyr
    shp$geo <- shp$NUTS_ID
    return(shp)
  }
}
