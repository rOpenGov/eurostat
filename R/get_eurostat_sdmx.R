#' @title Get Eurostat Data from SDMX 2.1 API
#'
#' @description
#' `r lifecycle::badge('experimental')`
#'
#' Download data sets from Eurostat using the same logic as `get_eurostat()`
#' function.
#'
#' @details
#' This function is experimental because while it works as intended and is
#' useful in the same way as other get_ functions in the package, we would
#' like to test it for a while and listen to user feedback before deciding on
#' what is the best way to interact with SDMX APIs.
#'
#' @inheritParams get_eurostat
#' @param agency Either "Eurostat" (default), "Eurostat_comext"
#' (for Comext and Prodcom datasets), "COMP", "EMPL" or "GROW"
#' @param use.data.table Use data.table to process files? Default is FALSE.
#' If data.table is used, data will be downloaded as a TSV file and
#' processed using [tidy_eurostat()]
#' @param wait Integer. Seconds between status checks. Default is 1 second.
#' @param max_wait Integer. Max time to wait in seconds. Default is 60 seconds.
#' @param compressed Logical. Download data in compressed format? Default is TRUE.
#'
#' @importFrom curl curl_download
#' @importFrom utils download.file
#' @importFrom readr read_csv read_tsv cols col_character
#' @importFrom data.table fread
#' @importFrom httr2 request req_url_path_append req_url_query req_perform
#'
#' @export
get_eurostat_sdmx <- function(
    id,
    time_format = "date",
    filters = NULL,
    type = "code",
    lang = "en",
    use.data.table = FALSE,
    agency = "Eurostat",
    compressed = TRUE,
    keepFlags = FALSE,
    legacy.data.output = FALSE,
    wait = 10,
    max_wait = 600,
    verbose = TRUE
    ) {

  # Check if you have access to ec.europa.eu.
  # If dataset is cached, access to ec.europa.eu is not needed
  # Therefore this is a warning, not a stop
  if (!check_access_to_data()) {
    # nocov start
    stop("You have no access to ec.europa.eu.
      Please check your connection and/or review your proxy settings")
    # nocov end
  }

  lang <- check_lang(lang)

  agency <- tolower(agency)

  api_base_uri <- build_api_base_uri(agency)
  agencyID <- build_agencyID(agency)

  if (is.null(api_base_uri)) stop("Use valid agency")

  if (is.null(filters) && agency == "eurostat_comext") {
    stop("Use filters when querying data from Eurostat COMEXT or PRODCOM")
  }

  # Following resource is supported: data
  resource <- "data"
  # The identifier of the dataflow reference
  flowRef <- id
  key <- data_filtering_on_dimension(agency, id, filters)
  compressed_string <- if (compressed) "&compressed=true" else "&compressed=false"

  if (use.data.table) {
    tfile <- tempfile()
    on.exit(unlink(tfile))

    httr2::request(api_base_uri) %>%
      httr2::req_url_path_append("sdmx", "2.1", resource, id, key) %>%
      httr2::req_url_query(format = "TSV", compressed = compressed, detail = "dataonly") %>%
      httr2::req_perform(path = tfile)

    dat <- readr::read_tsv(tfile, progress = verbose, show_col_types = verbose)
    dat2 <- data.table::fread(tfile, na.strings = c(":"), verbose = verbose)
    # Columns containing NA's don't play well with data.table::melt in
    # tidy_eurostat
    # This turns logical columns (containing NA's) into integers (NA_integer_)
    offending_cols <- names(dat2[, .SD, .SDcols = anyNA])
    dat2 <- dat2[ , (offending_cols) := lapply(.SD, as.integer), .SDcols = offending_cols]

    dat <- tidy_eurostat(dat2, use.data.table = use.data.table)

    return(dat)
  } else {
    res <- httr2::request(api_base_uri) %>%
      httr2::req_url_path_append("sdmx", "2.1", resource, id, key) %>%
      httr2::req_url_query(format = "SDMX-CSV", compressed = compressed, detail = "dataonly")
  }

  tfile <- tempfile()
  on.exit(unlink(tfile))

  httr2::req_perform(res, path = tfile)

  dat <- readr::read_csv(tfile, progress = verbose, show_col_types = verbose)
  if (!keepFlags) {
    col_names <- names(dat)
    dat <- dat[setdiff(col_names, "OBS_FLAG")]
  }

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

get_sdmx_codelist <- function(codelist_id, agency = "Eurostat", type = "list", lang = NULL) {
  lang <- check_lang(lang)

  api_base_uri <- build_api_base_uri(agency)

  xml_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/codelist/estat/",
    codelist_id)

  xml_object <- xml2::read_xml(xml_url)

  if (identical(type, "raw")) {
    return(xml_object)
  }

  namespaces <- xml2::xml_ns(xml_object)

  codelists <- xml2::xml_find_first(xml_object, ".//s:Codelists", namespaces)

  code_nodes <- xml2::xml_find_all(codelists, ".//s:Code", namespaces)

  id <- c()
  name <- c()

  for (node in code_nodes) {
    id <- c(id, xml2::xml_attr(node, "id"))
    name <- c(name, xml2::xml_text(xml2::xml_find_first(node, sprintf(".//c:Name[@xml:lang='%s']", lang))))
  }

  df <- data.frame(
    id = id,
    name = name
  )

  return(df)
}

get_sdmx_conceptscheme <- function(id, agency = "Eurostat", type = "list", lang = NULL) {

  lang <- check_lang(lang)

  api_base_uri <- build_api_base_uri(agency)

  xml_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/conceptscheme/estat/",
    id)

  xml_object <- xml2::read_xml(xml_url)

  if (identical(type, "raw")) {
    return(xml_object)
  }

  namespaces <- xml2::xml_ns(xml_object)

  # Continue with dimensions and concept extraction
  data_structure_components <- xml2::xml_find_first(xml_object, ".//s:Concepts", namespaces)

  concept_nodes <- xml2::xml_find_all(data_structure_components, ".//s:Concept", namespaces)

  # metadata <- xml2::as_list(concept_nodes)

  id <- c()
  urn <- c()
  name <- c()
  core_representation <- c()
  version <- c()

  for (node in concept_nodes) {
    id <- c(id, xml2::xml_attr(node, "id"))
    urn <- c(urn, xml2::xml_attr(node, "urn"))
    name <- c(name, xml2::xml_text(xml2::xml_find_first(node, sprintf(".//c:Name[@xml:lang='%s']", lang))))
    if (is.na(xml2::xml_attr(xml2::xml_find_first(node, ".//Ref"), "class"))) {
      core_representation <- c(core_representation, xml2::xml_attr(xml2::xml_find_first(node, ".//s:TextFormat"), "textType"))
    } else {
      core_representation <- c(core_representation, xml2::xml_attr(xml2::xml_find_first(node, ".//Ref"), "class"))
    }
    version <- c(version, xml2::xml_attr(xml2::xml_find_first(node, ".//Ref"), "version"))
  }

  metadata_returnable <- data.frame(
    id = id,
    urn = urn,
    name = name,
    core_representation = core_representation,
    version = version
  )

  return(metadata_returnable)
}

#' @importFrom xml2 xml_ns xml_find_first xml_text xml_attr xml_find_all
get_sdmx_dsd <- function(id, agency = "Eurostat", type = "list", lang = NULL) {
  api_base_uri <- build_api_base_uri(agency)

  dsd_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/datastructure/estat/",
    id)

  xml_object <- xml2::read_xml(dsd_url)

  if (identical(type, "raw")) {
    return(xml_object)
  }

  # Define namespaces
  namespaces <- xml2::xml_ns(xml_object)

  # Extract Header information
  header <- xml2::xml_find_first(xml_object, ".//m:Header", namespaces)
  header_id <- xml2::xml_text(xml2::xml_find_first(header, ".//m:ID", namespaces))
  prepared <- substr(xml2::xml_text(xml2::xml_find_first(header, ".//m:Prepared", namespaces)),1,10)
  sender_id <- xml2::xml_attr(xml2::xml_find_first(header, ".//m:Sender", namespaces), "id")


  # Continue with dimensions and concept extraction
  data_structure_components <- xml2::xml_find_first(xml_object, ".//s:DataStructureComponents", namespaces)

  dimension_nodes <- xml2::xml_find_all(data_structure_components, ".//s:Dimension | .//s:TimeDimension | .//s:AttributeList/s:Attribute | .//s:MeasureList/s:PrimaryMeasure", namespaces)

  metadata_returnable <- list()

  metadata <- xml2::as_list(dimension_nodes)

  id <- c()
  urn <- c()
  concept_identity_class <- c()
  local_representation <- c()
  local_representation_version <- c()

  for (node in dimension_nodes) {
    id <- c(id, xml2::xml_attr(node, "id"))
    urn <- c(urn, xml2::xml_attr(node, "urn"))
    concept_identity_class <- c(concept_identity_class, xml2::xml_attr(xml_find_first(node, ".//Ref"), "class"))
    if (is.na(xml2::xml_attr(xml2::xml_find_first(node, ".//Ref"), "class"))) {
      local_representation <- c(local_representation, xml2::xml_attr(xml2::xml_find_first(node, ".//s:TextFormat"), "textType"))
    } else {
      local_representation <- c(local_representation, xml2::xml_attr(xml2::xml_find_first(node, ".//Ref"), "class"))
    }
    local_representation_version <- c(local_representation_version, xml2::xml_attr(xml2::xml_find_first(node, ".//s:Enumeration/Ref"), "version"))
  }

  metadata_returnable <- data.frame(
    id = id,
    urn = urn,
    concept_identity_class = concept_identity_class,
    local_representation = local_representation,
    local_representation_version = local_representation_version
  )

  return(metadata_returnable)
}

get_sdmx_dataflow <- function(id, agency = "Eurostat", type = "list", lang = NULL) {

  api_base_uri <- build_api_base_uri(agency)

  dataflow_url <- paste0(
    api_base_uri,
    "/sdmx/2.1/dataflow/estat/",
    id)

  # With DSD
  # dataflow_url <- paste0(
  #   api_base_uri,
  #   "/sdmx/2.1/dataflow/estat/",
  #   id,
  #   "/",
  #  "?references=children")

  xml_object <- xml2::read_xml(dataflow_url)

  if (identical(type, "raw")) {
    return(xml_object)
  }

  # Define namespaces
  namespaces <- xml2::xml_ns(xml_object)

  # Extract Header information
  header <- xml2::xml_find_first(xml_object, ".//m:Header", namespaces)
  header_id <- xml2::xml_text(xml2::xml_find_first(header, ".//m:ID", namespaces))
  prepared <- substr(xml2::xml_text(xml2::xml_find_first(header, ".//m:Prepared", namespaces)),1,10)
  sender_id <- xml2::xml_attr(xml2::xml_find_first(header, ".//m:Sender", namespaces), "id")

  # Continue with dataflow and annotations extraction
  dataflow <- xml2::xml_find_first(xml_object, ".//s:Dataflow", namespaces)
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
  if (!is.null(lang)) {
    name <- xml2::xml_text(xml2::xml_find_first(dataflow, sprintf(".//c:Name[@xml:lang='%s']", lang), namespaces))
  } else {
    name <- name_en
  }

  source_institutions <- list()
  doi_details <- NULL

  annotations_nodes <- xml2::xml_find_all(dataflow, ".//c:Annotation", namespaces)
  for (node in annotations_nodes) {
    title <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationTitle", namespaces))
    type <- xml2::xml_text(xml2::xml_find_first(node, ".//c:AnnotationType", namespaces))
    texts_nodes <- xml2::xml_find_all(node, ".//c:AnnotationText", namespaces)


    # Assign specific annotations based on type
    if (type == "OBS_PERIOD_OVERALL_LATEST") {
      latest_period_timestamp <- title  # Directly store the latest period timestamp
    } else if (type == "OBS_PERIOD_OVERALL_OLDEST") {
      oldest_period_timestamp <- title
    } else if (type == "UPDATE_DATA") {
      update_data_timestamp <- title
    } else if(type == "SOURCE_INSTITUTIONS"){
      if (!is.null(lang)) {
        source_institutions <- xml2::xml_text(
          xml2::xml_find_all(node, sprintf(".//c:AnnotationText[@xml:lang='%s']", lang))
          )
      } else {
        source_institutions <- xml2::xml_text(
          xml2::xml_find_all(node, ".//c:AnnotationText[@xml:lang='en']")
          )
      }
    }

    if (grepl("adms:Identifier", title)) {
      title_xml <- xml2::read_xml(title)
      doi_url <- xml2::xml_attr(xml2::xml_find_first(title_xml, ".//adms:Identifier"), "rdf:about", xml2::xml_ns(title_xml))
    }
  }

  # # Extract DOI URL if the annotation contains adms:Identifier
  # if (grepl("adms:Identifier", title)) {
  #   title_xml <- xml2::read_xml(title)
  #   doi_url <- xml2::xml_attr(xml2::xml_find_first(title_xml, ".//adms:Identifier"), "rdf:about", xml2::xml_ns(title_xml))
  # }


  metadata <- list(
    name = name,
    name_en = name_en,
    name_de = name_de,
    name_fr = name_fr,
    doi_url = ifelse(exists("doi_url"), eval(doi_url), NA_character_),
    dataflow_id = dataflow_id,
    agency_id = agencyID,
    id = header_id,
    prepared = prepared,
    sender_id = sender_id,
    oldest_period_timestamp = oldest_period_timestamp,
    latest_period_timestamp = latest_period_timestamp,
    update_data_timestamp = update_data_timestamp,
    source_institutions = source_institutions,
    urn = urn,
    version = version,
    is_final = isFinal
  )

  return(metadata)

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
    stop(paste0("Use valid filter dimensions in the correct order: ", paste(dimension_df$dimension_id, collapse = ".")))
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

label_eurostat_sdmx <- function(x, agency, id, lang = "en", verbose = TRUE) {
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
      if (verbose) message(paste("Building codelist URL for resourceID:", resourceID))
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
        if (verbose) message(paste("Labeling dimension (column):", column_to_handle))
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
