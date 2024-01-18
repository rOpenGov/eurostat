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
    time_format,
    filters = NULL,
    type,
    lang,
    use.data.table,
    agency = "Eurostat",
    compressed = TRUE,
    label = FALSE
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
  
  agency <- tolower(agency)
  
  agencyID <- switch(
    agency,
    eurostat = "ESTAT",
    eurostat_comext = "ESTAT",
    comp = "COMP",
    empl = "EMPL",
    grow = "GROW"
  )
  
  api_base_uri <- switch(
    agency,
    eurostat = "https://ec.europa.eu/eurostat/api/dissemination",
    eurostat_comext = "https://ec.europa.eu/eurostat/api/comext/dissemination",
    comp = "https://webgate.ec.europa.eu/comp/redisstat/api/dissemination",
    empl = "https://webgate.ec.europa.eu/empl/redisstat/api/dissemination",
    grow = "https://webgate.ec.europa.eu/grow/redisstat/api/dissemination")
  
  if (is.null(api_base_uri)) stop("Use valid agency")
  
  if (is.null(filters) && agency == "eurostat_comext") {
    stop("Use filters when querying data from Eurostat COMEXT or PRODCOM")
  }
  
  # Following resource is supported: data
  resource <- "data"
  # The identifier of the dataflow reference
  flowRef <- id
  key <- data_filtering_on_dimension(api_base_uri, id, filters)
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

  x <- read.csv(tfile)
  
  # return(references_resolution(api_base_uri, resource = "datastructure", agencyID = agencyID, resourceID = id))
  
  if (label){
    x <- label_eurostat_sdmx(x = x,
                             api_base_uri = api_base_uri,
                             resourceID = "codelist",
                             id = id)
  }
  
  x
  
}

data_filtering_on_dimension <- function(api_base_uri, id, filters) {
  # data_structure_definition_url <- paste0(
  #   api_base_url,
  #   "/sdmx/2.1/datastructure/estat/",
  #   id)
  
  filter_names <- toupper(names(filters))
  
  dimension_df <- map_dimensions(api_base_uri = api_base_uri,
                                 id = id)
  dimension_id_upper <- dimension_df$dimension_id_upper
  
  # dsd <- xml2::read_xml(data_structure_definition_url)
  # 
  # # dimension_id <- xml2::xml_text(xml2::xml_find_all(xml2::xml_find_all(dsd, ".//s:Dimension"), ".//Ref[@class='Codelist']/@id"))
  # dimension_id <- xml2::xml_text(xml2::xml_find_all(dsd, ".//s:Dimension/@id"))
  # dimension_position <- xml2::xml_text(xml2::xml_find_all(dsd, ".//s:Dimension/@position"))
  # codelist_id <- xml2::xml_text(xml2::xml_find_all(dsd, ".//s:Dimension/s:LocalRepresentation/s:Enumeration/Ref/@id"))
  # dimension_id_upper <- toupper(dimension_id)
  # dimension_df <- data.frame(dimension_position, dimension_id, dimension_id_upper, codelist_id)
  
  # if (!setequal(filter_names, dimension_id)) {
  #   stop(paste0("Use valid filter dimensions, in this order: ", paste(dimension_id, collapse = ".")))
  # }
  
  if (!rlang::is_empty(setdiff(filter_names, dimension_id_upper))) {
    stop(paste0("Use valid filter dimensions in the correct order: ", paste(dimension_id, collapse = ".")))
  }
  
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

map_dimensions <- function(api_base_uri, id) {
  data_structure_definition_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/datastructure/estat/",
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

label_eurostat_sdmx <- function(x, api_base_uri, resourceID, id, lang = "en") {
  # how many columns there are that can be labeled with a codelist
  dimension_df <- map_dimensions(api_base_uri = api_base_uri, id = id)
  resource <- "codelist"
  agencyID <- "ESTAT"
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
    codelist <- as.data.frame(readr::read_tsv(file = codelist_url, col_types = "cc"))
    column_to_handle <- dimension_df$dimension_id[[i]]
    col <- x[[column_to_handle]]
    codes_to_label <- codelist[(codelist[,1] %in% col),]
    message(paste("Labeling dimension (column):", column_to_handle))
    for (j in seq_len(nrow(codes_to_label))) {
      col[which(col == as.character(codes_to_label[j,][1]))] <- as.character(codes_to_label[j,2])
    }
    x[column_to_handle] <- col
  }
  if ("OBS_FLAG" %in% names(x)){
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
  }
  x
}