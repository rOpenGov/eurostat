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
  metadata <- extract_metadata(agency, id)
  attr(dat, "metadata") <- metadata
  
  dat
  
}

extract_metadata <- function(agency, id) {
  
  api_base_uri <- build_api_base_uri(agency)
  
  data_structure_definition_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/dataflow/estat/",
    id)
  
  dsd_xml <- xml2::read_xml(data_structure_definition_url)
  
    # Define namespaces
  namespaces <- xml2::xml_ns(dsd_xml)
  
  
  dataflow <- xml2::xml_find_first(dsd_xml, ".//s:Dataflow", namespaces)
  dataflow_id <- xml2::xml_attr(dataflow, "id")
  urn <- xml2::xml_attr(dataflow, "urn")
  agencyID <- xml2::xml_attr(dataflow, "agencyID")
  version <- xml2::xml_attr(dataflow, "version")
  isFinal <- xml2::xml_attr(dataflow, "isFinal")
  # Extract names in different languages
  # Extract names in different languages independently
  name_de <- xml2::xml_text(xml2::xml_find_first(dataflow, ".//c:Name[@xml:lang='de']", namespaces))
  name_en <- xml2::xml_text(xml2::xml_find_first(dataflow, ".//c:Name[@xml:lang='en']", namespaces))
  name_fr <- xml2::xml_text(xml2::xml_find_first(dataflow, ".//c:Name[@xml:lang='fr']", namespaces))
  
  oldest_period_timestamp <- NULL
  latest_period_timestamp <- NULL
  update_data_timestamp <- NULL
  doi_url <- NULL
  
  
  annotations_nodes <- xml2::xml_find_all(dataflow, ".//c:Annotation", namespaces)
  # filtered_annotations <- lapply(annotations_nodes, function(node) {
  #   title <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationTitle", namespaces))
  #   type <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationType", namespaces))
  #   url <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationURL", namespaces))
  #   if (type == "OBS_PERIOD_OVERALL_LATEST") {
  #     latest_period_annotation <- list(Title = title, Type = type, URL = url)
  #   } else if (type == "OBS_PERIOD_OVERALL_OLDEST") {
  #     oldest_period_annotation <- list(Title = title, Type = type, URL = url)
  #   } else if (type == "UPDATE_DATA") {
  #     update_data_annotation <- list(Title = title, Type = type, URL = url)
  #   }
  #   if (grepl("adms:Identifier", title)) {
  #     # Parse the XML content within the title to extract the DOI URL
  #     title_xml <- xml2::read_xml(title)
  #     doi_url <<- xml2::xml_attr(xml2::xml_find_first(title_xml, ".//adms:Identifier"), "rdf:about", xml2::xml_ns(title_xml))
  #   }
  #   
  # })
  for (node in annotations_nodes) {
    title <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationTitle", namespaces))
    type <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationType", namespaces))
    
    # Assign specific annotations based on type
    if (type == "OBS_PERIOD_OVERALL_LATEST") {
      latest_period_timestamp <- title  # Directly store the latest period timestamp
    } else if (type == "OBS_PERIOD_OVERALL_OLDEST") {
      oldest_period_timestamp <- title
    } else if (type == "UPDATE_DATA") {
      update_data_timestamp <- title
    }
    
    # Extract DOI URL if the annotation contains adms:Identifier
    if (grepl("adms:Identifier", title)) {
      title_xml <- xml2::read_xml(title)
      doi_url <- xml2::xml_attr(xml2::xml_find_first(title_xml, ".//adms:Identifier"), "rdf:about", xml2::xml_ns(title_xml))
    }
  }
  
  # Remove NULL entries from the list
  #filtered_annotations <- Filter(Negate(is.null), filtered_annotations)
  
  
  
  metadata <- list(
    DataflowID = dataflow_id,
    URN = urn,
    AgencyID = agencyID,
    Version = version,
    IsFinal = isFinal,
    Name_DE = name_de,
    Name_EN = name_en,
    Name_FR = name_fr,
    OldestPeriodTimestamp = oldest_period_timestamp,
    LatestPeriodTimestamp = latest_period_timestamp,
    UpdateDataTimestamp = update_data_timestamp,
    DOI_URL = doi_url 
  )
  
  return(metadata)
  
}


legacy_data_format <- function(x, cols_to_drop = c("DATAFLOW", "LAST.UPDATE", "freq")) {
  x <- x[setdiff(names(x), cols_to_drop)]
  cols_to_rename <- data.frame(old = c("TIME_PERIOD", "OBS_VALUE"),
                               new = c("time", "values"))
  for (i in seq_len(nrow(cols_to_rename))) {
    old <- cols_to_rename[i,1]
    if (old %in% names(x)) {
      col_num <- which(names(x) == old)
      colnames(x)[col_num] <- cols_to_rename[i,2]
    }
  }
  x
}

build_api_base_uri <- function(agency) {
  agency <- tolower(agency)
  api_base_uri <- switch(
    agency,
    eurostat = "https://ec.europa.eu/eurostat/api/dissemination",
    eurostat_comext = "https://ec.europa.eu/eurostat/api/comext/dissemination",
    eurostat_prodcom = "https://ec.europa.eu/eurostat/api/comext/dissemination",
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
    eurostat_comext = "ESTAT",
    eurostat_prodcom = "ESTAT",
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

label_eurostat_sdmx <- function(x, agency, id, lang = "en") {
  # how many columns there are that can be labeled with a codelist
  dimension_df <- get_codelist_id(agency = agency, id = id)
  resource <- "codelist"
  lang <- check_lang(lang)
  
  api_base_uri <- build_api_base_uri(agency)
  agencyID <- build_agencyID(agency)
  
  agencyID <- agencyID
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
  x
}