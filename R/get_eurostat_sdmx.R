#' @title Get Eurostat Data from SDMX 2.1 API
#'
#' @description
#' Download data sets from Eurostat \url{https://ec.europa.eu/eurostat}
#' 
#' @details
#' Download data from SDMX API
#'
#' @inheritParams get_eurostat
#' @param agency Either "Eurostat" (default), "Eurostat_comext" 
#' (for Comext and Prodcom datasets), "COMP", "EMPL" or "GROW"
#' 
#' @importFrom curl curl_download
#' @importFrom utils download.file
#' @importFrom readr read_tsv cols col_character
#' @importFrom data.table fread
#' 
#' @export
get_eurostat_sdmx <- function(
    id,
    time_format = "date",
    filters = NULL,
    type = "code",
    lang = "en",
    use.data.table,
    agency = "Eurostat",
    compressed = TRUE,
    keepFlags = FALSE,
    legacy.data.output = FALSE
    ) {
  
  # Check if you have access to ec.europe.eu.
  # If dataset is cached, access to ec.europe.eu is not needed
  # Therefore this is a warning, not a stop
  if (!check_access_to_data()) {
    # nocov start
    stop("You have no access to ec.europe.eu.
      Please check your connection and/or review your proxy settings")
    # nocov end
  }
  
  lang <- check_lang(lang)
  
  agency <- tolower(agency)
  
  # agencyID <- switch(
  #   agency,
  #   eurostat = "ESTAT",
  #   eurostat_comext = "ESTAT",
  #   comp = "COMP",
  #   empl = "EMPL",
  #   grow = "GROW"
  # )
  
  api_base_uri <- build_api_base_uri(agency)
  agencyID <- build_agencyID(agency)
  
  # api_base_uri <- switch(
  #   agency,
  #   eurostat = "https://ec.europa.eu/eurostat/api/dissemination",
  #   eurostat_comext = "https://ec.europa.eu/eurostat/api/comext/dissemination",
  #   comp = "https://webgate.ec.europa.eu/comp/redisstat/api/dissemination",
  #   empl = "https://webgate.ec.europa.eu/empl/redisstat/api/dissemination",
  #   grow = "https://webgate.ec.europa.eu/grow/redisstat/api/dissemination")
  
  if (is.null(api_base_uri)) stop("Use valid agency")
  
  if (is.null(filters) && agency == "eurostat_comext") {
    stop("Use filters when querying data from Eurostat COMEXT or PRODCOM")
  }
  
  # Following resource is supported: data
  resource <- "data"
  # The identifier of the dataflow reference
  flowRef <- id
  key <- data_filtering_on_dimension(agency, id, filters)
  compressed <- ifelse(compressed == TRUE, "&compressed=true", "&compressed=false")
  
  url <- paste0(
    api_base_uri,
    "/sdmx/2.1/",
    resource,
    "/",
    flowRef,
    "/",
    key,
    "?",
    "format=SDMX-CSV",
    compressed
  )
  
  tfile <- tempfile()
  on.exit(unlink(tfile))
  
  curl::curl_download(url = url, destfile = tfile)

  dat <- read.csv(tfile, colClasses = "character")
  if (!keepFlags) {
    col_names <- names(dat)
    dat <- dat[setdiff(col_names, "OBS_FLAG")]
  }
  
  # return(references_resolution(api_base_uri, resource = "datastructure", agencyID = agencyID, resourceID = id))
  
  if (identical(type, "label")){
    dat <- label_eurostat_sdmx(x = dat,
                             agency = agency,
                             id = id,
                             lang = lang)
  }
  
  dat$TIME_PERIOD <- convert_time_col(x = dat$TIME_PERIOD,
                                      time_format = time_format)
  
  dat$OBS_VALUE <- as.numeric(dat$OBS_VALUE)
  
  if (legacy.data.output) {
    dat <- legacy_data_format(dat)
  }
  
  dat
  
}

legacy_data_format <- function(x, cols_to_drop = c("DATAFLOW", "LAST UPDATE", "freq")) {
  if (inherits(x, "data.table")) {
    # Drop columns that were not used in old API
    for (i in seq_along(cols_to_drop)) {
      if (cols_to_drop[i] %in% names(x)){
        x[, (cols_to_drop[i]):=NULL]
      }
    }
    
    # Rename columns
    non_legacy_col_name = c("TIME_PERIOD", "OBS_VALUE", "OBS_FLAG")
    legacy_col_name = c("time", "values", "flags")
    for (i in seq_along(non_legacy_col_name)) {
      if (non_legacy_col_name[i] %in% names(x)){
        data.table::setnames(x, (non_legacy_col_name[i]), (legacy_col_name[i]))
      }
    }
    
  } else {
    x <- x[setdiff(names(x), cols_to_drop)]
    cols_to_rename <- data.frame(non_legacy_col_name = c("TIME_PERIOD", "OBS_VALUE", "OBS_FLAG"),
                                 legacy_col_name = c("time", "values", "flags"))
    for (i in seq_len(nrow(cols_to_rename))) {
      non_legacy_col_name <- cols_to_rename[i,1]
      if (non_legacy_col_name %in% names(x)) {
        col_num <- which(names(x) == non_legacy_col_name)
        colnames(x)[col_num] <- cols_to_rename[i,2]
      }
    }
  }
  x
}

build_api_base_uri <- function(agency) {
  agency <- tolower(agency)
  api_base_uri <- switch(
    agency,
    eurostat = "https://ec.europa.eu/eurostat/api/dissemination",
    estat = "https://ec.europa.eu/eurostat/api/dissemination",
    eurostat_comext = "https://ec.europa.eu/eurostat/api/comext/dissemination",
    comext = "https://ec.europa.eu/eurostat/api/comext/dissemination",
    eurostat_prodcom = "https://ec.europa.eu/eurostat/api/comext/dissemination",
    prodcom = "https://ec.europa.eu/eurostat/api/comext/dissemination",
    comp = "https://webgate.ec.europa.eu/comp/redisstat/api/dissemination",
    empl = "https://webgate.ec.europa.eu/empl/redisstat/api/dissemination",
    grow = "https://webgate.ec.europa.eu/grow/redisstat/api/dissemination")
  
  api_base_uri
}

build_agencyID <- function(agency) {
  agency <- tolower(agency)
  agencyID <- switch(
    agency,
    eurostat = "ESTAT",
    estat = "ESTAT",
    eurostat_comext = "ESTAT",
    comext = "ESTAT",
    eurostat_prodcom = "ESTAT",
    prodcom = "ESTAT",
    comp = "COMP",
    empl = "EMPL",
    grow = "GROW"
  )
  
  agencyID
}

data_filtering_on_dimension <- function(agency, id, filters) {
  # data_structure_definition_url <- paste0(
  #   api_base_url,
  #   "/sdmx/2.1/datastructure/estat/",
  #   id)
  
  filter_names <- toupper(names(filters))
  
  dimension_df <- get_codelist_id(agency = agency,
                                 id = id)
  dimension_id_upper <- dimension_df$dimension_id_upper
  
  if (!rlang::is_empty(setdiff(filter_names, dimension_id_upper))) {
    stop(paste0("Use valid filter dimensions in the correct order: ", paste(dimension_id, collapse = ".")))
  }
  
  # Assumes that dimensions are listed in the order of their positions
  # If there is an example to the contrary somewhere, this should be changed
  filter_string <- ""
  for (i in seq_along(dimension_df$dimension_id_upper)){
    if (dimension_df$dimension_id_upper[i] %in% filter_names) {
      x <- paste(filters[[dimension_df$dimension_id_upper[i]]], collapse = "+")
      filter_string <- paste0(filter_string, x, ".")
    } else {
      filter_string <- paste0(filter_string, ".")
    }
    if (i == length(dimension_df$dimension_id_upper)) {
      # Remove final dot
      filter_string <- substr(filter_string, 1, nchar(filter_string)-1)
    }
  }
  return(filter_string)
}

get_codelist_id <- function(agency, id) {
  
  api_base_uri <- build_api_base_uri(agency)
  
  data_structure_definition_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/datastructure/ESTAT/",
    id)
  
  dsd <- xml2::read_xml(data_structure_definition_url)
  
  # dimension_id <- xml2::xml_text(xml2::xml_find_all(xml2::xml_find_all(dsd, ".//s:Dimension"), ".//Ref[@class='Codelist']/@id"))
  dimension_id <- xml2::xml_text(xml2::xml_find_all(dsd, ".//s:Dimension/@id"))
  dimension_position <- xml2::xml_text(xml2::xml_find_all(dsd, ".//s:Dimension/@position"))
  codelist_id <- xml2::xml_text(xml2::xml_find_all(dsd, ".//s:Dimension/s:LocalRepresentation/s:Enumeration/Ref/@id"))
  dimension_id_upper <- toupper(dimension_id)
  dimension_df <- data.frame(dimension_position, dimension_id, dimension_id_upper, codelist_id)
  
  dimension_df
}

# references_resolution <- function(api_base_uri, resource, agencyID, resourceID) {
#   # resource <- "datastructure"
#   
#   url <- paste0(
#     api_base_uri,
#     "/sdmx/2.1/",
#     resource,
#     "/",
#     agencyID,
#     "/",
#     resourceID
#   )
#   
#   parsed <- xml2::read_xml(url)
#   
# }

# get_codelist <- function(api_base_uri, id, dimension_id) {
#   
# }

label_eurostat_sdmx <- function(x, agency, id, lang = "en") {
  # how many columns there are that can be labeled with a codelist
  dimension_df <- get_codelist_id(agency = agency, id = id)
  resource <- "codelist"
  lang <- check_lang(lang)
  
  # non-destructive editing
  y <- x
  api_base_uri <- build_api_base_uri(agency)
  agencyID <- build_agencyID(agency)
  
  agencyID <- agencyID
  # data.table objects need different kind of handling
  if (inherits(y, "data.table")) {
    for (i in seq_len(nrow(dimension_df))) {
      resourceID <- dimension_df$codelist_id[[i]]
      message(paste("Building codelist URL for resourceID:", resourceID))
      codelist_url <- paste0(
        api_base_uri,
        "/sdmx/2.1/",
        resource,
        "/",
        agencyID,
        "/",
        resourceID,
        "?format=TSV",
        "&lang=",
        lang
      )
      tryCatch({
        codelist <- as.data.frame(readr::read_tsv(file = codelist_url, col_types = "cc", col_names = FALSE))
        column_to_handle <- dimension_df$dimension_id[[i]]
        codes_to_label <- unique(y[[column_to_handle]])
        codelist_subset <- codelist[which(codelist[,1] %in% codes_to_label),]
        message(paste("Labeling dimension (column):", column_to_handle))
        for (j in seq_len(nrow(codelist_subset))) {
          data.table::set(y, i=which(y[[column_to_handle]] == codelist_subset[j,1]), j = column_to_handle, value = codelist_subset[j,2])
        }
      },
      error = function(e) message(paste("Couldn't label", resourceID))
      )
    }
  } else {
    for (i in seq_len(nrow(dimension_df))) {
      resourceID <- dimension_df$codelist_id[[i]]
      message(paste("Building codelist URL for resourceID:", resourceID))
      codelist_url <- paste0(
        api_base_uri,
        "/sdmx/2.1/",
        resource,
        "/",
        agencyID,
        "/",
        resourceID,
        "?format=TSV",
        "&lang=",
        lang
      )
      tryCatch({
        codelist <- as.data.frame(readr::read_tsv(file = codelist_url, col_types = "cc", col_names = FALSE))
        column_to_handle <- dimension_df$dimension_id[[i]]
        col <- x[[column_to_handle]]
        codes_to_label <- codelist[(codelist[,1] %in% col),]
        message(paste("Labeling dimension (column):", column_to_handle))
        for (j in seq_len(nrow(codes_to_label))) {
          col[which(col == as.character(codes_to_label[j,][1]))] <- as.character(codes_to_label[j,2])
        }
        x[column_to_handle] <- col
      },
      error = function(e) message(paste("Couldn't label", resourceID))
      )
    }
    if ("OBS_FLAG" %in% names(x)){
      tryCatch({
        resourceID <- "OBS_FLAG"
        message(paste("Building codelist URL for resourceID:", resourceID))
        codelist_url <- paste0(
          api_base_uri,
          "/sdmx/2.1/",
          resource,
          "/",
          agencyID,
          "/",
          resourceID,
          "?format=TSV",
          "&lang=",
          lang
        )
        codelist <- as.data.frame(readr::read_tsv(file = codelist_url, col_types = "cc"))
        column_to_handle <- "OBS_FLAG"
        col <- x[[column_to_handle]]
        codes_to_label <- codelist[(codelist[,1] %in% col),]
        message(paste("Labeling dimension (column):", column_to_handle))
        for (j in seq_len(nrow(codes_to_label))) {
          col[which(col == as.character(codes_to_label[j,][1]))] <- as.character(codes_to_label[j,2])
        }
        x[column_to_handle] <- col
      },
      error = function(e) message(paste("Couldn't label", resourceID))
      )
    }
  }
  x
}