#' @title Download Eurostat Data from API Link (robust, no list-columns, async-aware)
#'
#' @description
#' `r lifecycle::badge('experimental')`
#' 
#' Supports TSV, SDMX-CSV, SDMX-ML, JSON-stat, and Spreadsheet (.xlsx) formats.
#' Always returns a tibble where possible.
#'
#' @param link Eurostat "Copy API link" URL or Data Browser download link
#' @param destfile Optional file path for saving raw files (only for Excel)
#' @inheritParams get_eurostat
#' @return Tibble for all supported formats
#' @importFrom purrr map_dfr
#' @importFrom utils read.delim read.csv
#' @importFrom stats setNames
#' @importFrom httr2 request req_user_agent req_perform resp_check_status
#' @importFrom httr2 resp_body_raw resp_content_type url_parse
#' @export
get_eurostat_link <- function(link, destfile = NULL, verbose = TRUE) {
  if (!is.character(link) || length(link) != 1) stop("Provide a valid Eurostat link.")
  if (!grepl("ec\\.europa\\.eu/eurostat/", link)) stop("Only Eurostat links allowed.")

  as_tibble_safe <- function(x) {
    if (is.data.frame(x)) tibble::as_tibble(x)
    else tibble::tibble(data = list(x))
  }

  download_content <- function(link) {
    resp <- httr2::request(link) %>% 
      httr2::req_user_agent("https://github.com/rOpenGov/eurostat") %>% 
      httr2::req_perform()

    httr2::resp_check_status(resp)

    raw <- httr2::resp_body_raw(resp)

    if (httr2::resp_content_type(resp) == "application/gzip" || grepl("compress=true", link, ignore.case = TRUE)) {
      if (verbose) message("Decompressing content...")
      raw <- memDecompress(raw, type = "gzip", asChar = TRUE)
    } else {
      raw <- rawToChar(raw)
    }

    raw
  }
  
  url_parsed <- httr2::url_parse(link)

  # Comext DS-prefixed datasets must use correct base
  if (grepl("/comext/dissemination", link)) {
    dataset_match <- grepl("/ds-[0-9]+", url_parsed$path)
    if (!dataset_match) {
      stop("Comext API requires DS-prefixed dataset codes (e.g., ds-056120).")
    }
  }

  # TSV format
  if ("format" %in% attributes(url_parsed$query) && url_parsed$query$format == "TSV") {
    if (verbose) message("Downloading TSV...")
    text_content <- download_content(link)

    df <- utils::read.delim(
      text = text_content,
      sep = "\t",
      check.names = FALSE,
      na.strings = c(":", ": ")
    )

    # Unpack first column
    first_col_name <- names(df)[1]
    dim_names <- strsplit(first_col_name, ",", fixed = TRUE)[[1]]
    dim_values <- strsplit(df[[1]], ",", fixed = TRUE)
    dim_matrix <- do.call(rbind, dim_values)
    dim_df <- as.data.frame(dim_matrix, stringsAsFactors = FALSE)
    colnames(dim_df) <- dim_names

    # Optional: fix backslash column name
    names(dim_df)[grepl("\\\\", names(dim_df))] <- sub("\\\\.*", "", names(dim_df)[grepl("\\\\", names(dim_df))])

    final_df <- dplyr::bind_cols(dim_df, df[-1])
    return(tibble::as_tibble(final_df))
  }

  # SDMX-CSV
  if ("format" %in% attributes(url_parsed$query)$names && url_parsed$query$format == "csvdata") {
    if (verbose) message(paste0("Downloading SDMX-CSV ", url_parsed$query$formatVersion, "..."))
    text_content <- download_content(link)
    lines <- strsplit(text_content, "\n", fixed = TRUE)[[1]]
    data_start <- which(sapply(lines, function(l) {
      fields <- strsplit(l, ",", fixed = TRUE)[[1]]
      length(fields) > 1 && all(nzchar(fields) | fields == "")
    }))[1]
    if (is.na(data_start)) stop("Could not detect valid SDMX-CSV header for Comext dataset.")
    clean_text <- paste(lines[data_start:length(lines)], collapse = "\n")
    return(as_tibble_safe(utils::read.csv(text = clean_text, check.names = FALSE, row.names = NULL)))
  }

  # SDMX-ML 2.1 StructureSpecific
  if ("format" %in% attributes(url_parsed$query)$names && url_parsed$query$format == "structurespecificdata") {
    if (!requireNamespace("xml2", quietly = TRUE)) stop("Please install 'xml2' for XML parsing.")
    if (verbose) message(paste("Downloading SDMX-ML", url_parsed$query$formatVersion, url_parsed$query$format, "..."))
    xml_text <- download_content(link)
    doc <- xml2::read_xml(xml_text)
    ns <- xml2::xml_ns(doc)
    series_nodes <- xml2::xml_find_all(doc, ".//Series", ns)
    result <- purrr::map_dfr(series_nodes, function(series) {
      series_atts <- xml2::xml_attrs(series)
      obs_nodes <- xml2::xml_find_all(series, ".//Obs", ns)
      purrr::map_dfr(obs_nodes, function(o) {
        data.frame(as.list(series_atts), time = xml2::xml_attr(o, "TIME_PERIOD"), value = as.numeric(xml2::xml_attr(o, "OBS_VALUE")), stringsAsFactors = FALSE)
      })
    })
    return(tibble::as_tibble(result))
  }

  # SDMX-ML 2.1 GenericData
  if ("format" %in% attributes(url_parsed$query)$names && url_parsed$query$format == "genericdata") {
    if (!requireNamespace("xml2", quietly = TRUE)) stop("Please install 'xml2' for XML parsing.")
    if (verbose) message(paste("Downloading SDMX-ML", url_parsed$query$formatVersion, url_parsed$query$format, "..."))
    xml_text <- download_content(link)
    doc <- xml2::read_xml(xml_text)
    ns <- xml2::xml_ns(doc)
    series_nodes <- xml2::xml_find_all(doc, ".//g:Series", ns)
    result <- purrr::map_dfr(series_nodes, function(series) {
      key_nodes <- xml2::xml_find_all(series, ".//g:Value", ns)
      key_vals <- stats::setNames(xml2::xml_attr(key_nodes, "value"), xml2::xml_attr(key_nodes, "id"))
      obs_nodes <- xml2::xml_find_all(series, ".//g:Obs", ns)
      purrr::map_dfr(obs_nodes, function(obs) {
        data.frame(as.list(key_vals), time = xml2::xml_attr(xml2::xml_find_first(obs, ".//g:ObsDimension", ns), "value"), value = as.numeric(xml2::xml_attr(xml2::xml_find_first(obs, ".//g:ObsValue", ns), "value")), stringsAsFactors = FALSE)
      })
    })
    return(tibble::as_tibble(result))
  }

  # SDMX-ML 3.0 StructureSpecific
  if (grepl("/sdmx/3.0/data", link) && (grepl("\\.xml", link, ignore.case = TRUE) || !grepl("format=", link, ignore.case = TRUE))) {
    if (!requireNamespace("xml2", quietly = TRUE)) stop("Please install 'xml2' for XML parsing.")
    if (verbose) message(paste("Downloading SDMX-ML", url_parsed$query$formatVersion, url_parsed$query$format, "..."))
    xml_text <- download_content(link)
    doc <- xml2::read_xml(xml_text)
    ns <- xml2::xml_ns(doc)
    series_nodes <- xml2::xml_find_all(doc, ".//m:Series", ns)
    if (length(series_nodes) == 0) {
      series_nodes <- xml2::xml_find_all(doc, ".//Series", ns)
    }
    result <- purrr::map_dfr(series_nodes, function(series) {
      series_atts <- xml2::xml_attrs(series)
      obs <- xml2::xml_find_all(series, ".//Obs", ns)
      if (length(obs) == 0) {
        obs <- xml2::xml_find_all(series, ".//Obs", ns)
      }
      purrr::map_dfr(obs, function(o) {
        row <- c(series_atts, list(
          time = xml2::xml_attr(o, "TIME_PERIOD"),
          value = as.numeric(xml2::xml_attr(o, "OBS_VALUE"))
        ))
        data.frame(row, stringsAsFactors = FALSE)
      })
    })
    return(tibble::as_tibble(result))
  }

  # JSON-stat handling
  if ("format" %in% attributes(url_parsed$query)$names && url_parsed$query$format == "JSON") {
    if (verbose) message("Downloading JSON-stat 2.0...")
    json_data <- jsonlite::fromJSON(link)
    value_data <- json_data$value
    dims <- json_data$dimension
    if (is.null(value_data) && !is.null(json_data$dataset$value)) {
      value_data <- json_data$dataset$value
      dims <- json_data$dataset$dimension
    }
    if (!is.null(value_data) && !is.null(dims)) {
      dim_ids <- names(dims)
      dim_lists <- lapply(dim_ids, function(id) names(dims[[id]]$category$index))
      names(dim_lists) <- dim_ids
      grid <- expand.grid(dim_lists, stringsAsFactors = FALSE)
      values <- rep(NA_real_, nrow(grid))
      idx <- as.integer(names(value_data)) + 1
      values[idx] <- as.numeric(unlist(value_data))
      grid$value <- values
      if (verbose) message("Returning flattened tibble.")
      return(tibble::as_tibble(grid))
    }
    flat <- jsonlite::flatten(json_data)
    return(as_tibble_safe(flat))
  }

  stop("Unsupported or unknown format.")
}
