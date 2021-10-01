#' @title Read Eurostat Data
#' @description Download data sets from Eurostat <https://ec.europa.eu/eurostat/>.
#' @param id A code name for the dataset of interest.
#'        See [search_eurostat()] or details for how to get code.
#' @param filters a "none" (default) to get a whole dataset or a named list of
#'        filters to get just part of the table. Names of list objects are
#'        Eurostat variable codes and values are vectors of observation codes.
#'        If `NULL` the whole
#'        dataset is returned via API. More on details. See more on filters and
#'        limitations per query via API from for
#'        [get_eurostat_json()].
#' @param time_format a string giving a type of the conversion of the time
#'        column from the eurostat format. A "date" (default) converts to
#'        a [Date()] with a first date of the period.
#'        A "date_last" converts to a [Date()] with
#'         a last date of the period. A "num" converts to a numeric and "raw"
#'         does not do conversion. See [eurotime2date()] and
#'         [eurotime2num()].
#' @param type A type of variables, "code" (default) or "label".
#' @param select_time a character symbol for a time frequency or NULL,
#'        which is used by default as most datasets have just one time
#'        frequency. For datasets with multiple time
#'        frequencies, select the desired time format with:
#'    	  Y = annual, S = semi-annual, Q = quarterly, M = monthly.
#'        For all frequencies in same data frame `time_format = "raw"`
#'        should be used.
#' @param cache a logical whether to do caching. Default is `TRUE`. Affects
#'        only queries from the bulk download facility.
#' @param update_cache a logical whether to update cache. Can be set also with
#'        options(eurostat_update = TRUE)
#' @param cache_dir a path to a cache directory. The directory must exist.
#'        The `NULL` (default) uses and creates
#'        'eurostat' directory in the temporary directory from
#'        [tempdir()]. The directory can also be set with
#'        [set_eurostat_cache_dir()].
#' @param compress_file a logical whether to compress the
#'        RDS-file in caching. Default is `TRUE`.
#' @param stringsAsFactors if `TRUE` (the default) variables are
#'        converted to factors in original Eurostat order. If `FALSE`
#'        they are returned as a character.
#' @param keepFlags a logical whether the flags (e.g. "confidential",
#'        "provisional") should be kept in a separate column or if they
#'        can be removed. Default is `FALSE`. For flag values see:
#'        <https://ec.europa.eu/eurostat/data/database/information>.
#'        Also possible non-real zero "0n" is indicated in flags column.
#'        Flags are not available for eurostat API, so `keepFlags`
#'        can not be used with a `filters`.
#' @inheritDotParams get_eurostat_json
#' @export
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="#" }
#' citation("eurostat")
#' ```
#'
#' @author Przemyslaw Biecek, Leo Lahti, Janne Huovari and Markus Kainu
#' @details Data sets are downloaded from
#' [the Eurostat bulk download facility](https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing) or from The Eurostat Web Services
#' [JSON API](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services).
#' If only the table `id` is given, the whole table is downloaded from the
#' bulk download facility. If also `filters` are defined the JSON API is
#' used.
#'
#' The bulk download facility is the fastest method to download whole datasets.
#' It is also often the only way as the JSON API has limitation of maximum
#' 50 sub-indicators at time and whole datasets usually exceeds that. Also,
#' it seems that multi frequency datasets can only be retrieved via
#' bulk download facility and the `select_time` is not available for
#' JSON API method.
#'
#' If your connection is thru a proxy, you probably have to set proxy parameters
#' to use JSON API, see [get_eurostat_json()].
#'
#' By default datasets from the bulk download facility are cached as they are
#' often rather large. Caching is not (currently) possible for datasets from
#' JSON API.
#' Cache files are stored in a temporary directory by default or in
#' a named directory (See [set_eurostat_cache_dir()]).
#' The cache can be emptied with [clean_eurostat_cache()].
#'
#' The `id`, a code, for the dataset can be searched with
#' the [search_eurostat()] or from the Eurostat database
#' <https://ec.europa.eu/eurostat/data/database>. The Eurostat
#' database gives codes in the Data Navigation Tree after every dataset
#' in parenthesis.
#' @return a tibble. One column for each dimension in the data,
#'         the time column for a time dimension and
#'         the values column for numerical values.
#'         Eurostat data does not include all missing values and a treatment of
#'         missing values depend on source. In bulk download
#'         facility missing values are dropped if all dimensions are missing
#'         on particular time. In JSON API missing values are dropped
#'         only if all dimensions are missing on all times. The data from
#'         bulk download facility can be completed for example with
#'         [tidyr::complete()].
#' @seealso [search_eurostat()], [label_eurostat()]
#' @examplesIf check_access_to_data()
#' \donttest{
#' k <- get_eurostat("nama_10_lp_ulc")
#' k <- get_eurostat("nama_10_lp_ulc", time_format = "num")
#' k <- get_eurostat("nama_10_lp_ulc", update_cache = TRUE)
#'
#' k <- get_eurostat("nama_10_lp_ulc",
#'   cache_dir = file.path(tempdir(), "r_cache")
#' )
#' options(eurostat_update = TRUE)
#' k <- get_eurostat("nama_10_lp_ulc")
#' options(eurostat_update = FALSE)
#'
#' set_eurostat_cache_dir(file.path(tempdir(), "r_cache2"))
#' k <- get_eurostat("nama_10_lp_ulc")
#' k <- get_eurostat("nama_10_lp_ulc", cache = FALSE)
#' k <- get_eurostat("avia_gonc", select_time = "Y", cache = FALSE)
#' }
#' \dontrun{
#' dd <- get_eurostat("nama_10_gdp",
#'   filters = list(
#'     geo = "FI",
#'     na_item = "B1GQ",
#'     unit = "CLV_I10"
#'   )
#' )
#' }
#'
get_eurostat <- function(id, time_format = "date", filters = "none",
                         type = "code",
                         select_time = NULL,
                         cache = TRUE, update_cache = FALSE, cache_dir = NULL,
                         compress_file = TRUE,
                         stringsAsFactors = FALSE,
                         keepFlags = FALSE, ...) {

  # Check if you have access to ec.europe.eu.
  if (!check_access_to_data()) {
    message("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
  } else {
    # Warning for flags with filter
    if (keepFlags & !is.character(filters) && filters != "none") {
      warning("The keepFlags argument of the get_eurostat function
               can be used only without filters. No Flags returned.")
    }

    # No cache for json
    if (is.null(filters) || filters != "none") {
      cache <- FALSE
    }

    if (cache) {

      # check option for update
      update_cache <- update_cache | getOption("eurostat_update", FALSE)

      # get cache directory
      cache_dir <- eur_helper_cachedir(cache_dir)

      # cache filename
      cache_file <- file.path(
        cache_dir,
        paste0(
          id, "_", time_format,
          "_", type, select_time, "_",
          strtrim(stringsAsFactors, 1),
          strtrim(keepFlags, 1),
          ".rds"
        )
      )
    }

    # if cache = FALSE or update or new: dowload else read from cache
    if (!cache || update_cache || !file.exists(cache_file)) {
      if (is.null(filters) || is.list(filters)) {

        # API Download
        y <- get_eurostat_json(id, filters,
          type = type,
          stringsAsFactors = stringsAsFactors, ...
        )
        y$time <- convert_time_col(factor(y$time), time_format = time_format)

        # Bulk download
      } else if (filters == "none") {
        y_raw <- try(get_eurostat_raw(id))
        if ("try-error" %in% class(y_raw)) {
          stop(paste("get_eurostat_raw fails with the id", id))
        }

        y <- tidy_eurostat(y_raw, time_format, select_time,
          stringsAsFactors = stringsAsFactors,
          keepFlags = keepFlags
        )
        if (type == "code") {
          y <- y
        } else if (type == "label") {
          y <- label_eurostat(y)
        } else if (type == "both") {
          stop("type = \"both\" can be only used with JSON API. Set filters argument")
        } else {
          stop("Invalid type.")
        }
      }
    } else {
      cf <- path.expand(cache_file)
      message(paste("Reading cache file", cf))
      y <- readRDS(cache_file)
      message(paste("Table ", id, " read from cache file: ", cf))
    }

    # if update or new: save
    if (cache && (update_cache || !file.exists(cache_file))) {
      saveRDS(y, file = cache_file, compress = compress_file)
      message("Table ", id, " cached at ", path.expand(cache_file))
    }

    y
  }
}
