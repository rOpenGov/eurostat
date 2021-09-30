library(tidyverse)

## Check for non-unique elements in nuts_correction.R

check_dat_input <- function(dat) {
  incorrect <- FALSE
  if (!"geo" %in% names(dat)) correct <- TRUE
  incorrect
}

check_unique_values <- function(df) {
  if ("corrected_values" %in% names(df)) {
    df <- df %>%
      rename(values = corrected_values)
  }

  df <- df %>%
    select(geo, indicator, time) %>%
    add_count(geo, indicator, time)

  if (any(df$n) > 1) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}


regdata_files <- dir("regdata")[!grepl("rest_of_ceemid", dir("regdata"))]
regdata_files <- regdata_files[grepl(".rds", regdata_files)]
regdata_files <- regdata_files[!grepl("corrected", regdata_files)]
regdata_files

for (test in regdata_files) {
  message("Testing ", test)
  readRDS(file.path("regdata", test))
}

message("All regional data files read, none was corrupted on disk.")
source(file.path("R", "nuts_coding.R"))

dat <- eurostat::tgs00026 %>%
  check_nuts2013()

correct_nuts_labelling <- function(dat) {

  ## Check if geo information is present ------------------------------
  if (check_dat_input(dat)) {
    stop("There is no 'geo' column in the inserted data. This is an error.")
  }


  if (!"change" %in% names(dat)) {
    dat <- check_nuts2013(dat)
  }
  unchanged_regions <- regional_changes_2016 %>%
    filter(change == "unchanged")

  changed_regions <- regional_changes_2016 %>%
    filter(change != "unchanged")

  nuts_2016_codes <- unique(regional_changes_2016$code16)
  # for easier debugging, this data will be re-assigned in each major
  # step as tmp2, tmp3...  Debugging is particulary difficult, because
  # not only the program code, but the underlying logic may have faults.

  tmp_eu_only <- tmp %>%
    filter(change != "not_eu") # leave out non-EU regions.

  # Find those codes that are missing from the correct NUTS2016 codes
  missing_2016_codes <- nuts_2016_codes[which(!nuts_2016_codes %in% tmp_eu_only$geo)]
  missing_2016_codes <- missing_2016_codes[which(stringr::str_sub(missing_2016_codes, -3, -1) != "ZZZ")]
  missing_2016_codes <- missing_2016_codes[which(stringr::str_sub(missing_2016_codes, -2, -1) != "ZZ")]

  # Sort them out by NUTS1 and NUTS2 levels
  missing_nuts1_2016 <- missing_2016_codes[which(nchar(missing_2016_codes) == 3)]
  missing_nuts2_2016 <- missing_2016_codes[which(nchar(missing_2016_codes) == 4)]

  # Separating labels that need to be corrected into tmp3 ----------------

  correctly_labelled_unchanged <- tmp %>%
    filter(change == "unchanged")

  tmp_changed <- tmp %>%
    filter(change != "unchanged")

  correctly_labelled_changed <- tmp_changed %>%
    filter(geo %in% changed_regions$code16)

  ## Finding incorrectly labelled NUTS1 geo labels --------------------
  incorrectlly_labelled_nuts1 <- tmp_changed %>%
    filter(geo %in% changed_regions$code13)

  incorrectly_labelled_nuts1_2013 <- incorrectlly_labelled_nuts1 %>%
    filter(nchar(as.character(geo)) == 3) %>%
    select(-change) %>%
    left_join(nuts_correspondence %>%
      filter(nuts_level == 1) %>%
      rename(geo = code13) %>%
      filter(!is.na(geo)) %>%
      select(geo, code16, change, resolution),
    by = "geo"
    ) %>%
    filter(change != "discontinued") %>%
    mutate(problem_code = geo) %>%
    mutate(geo = code16)


  ## NUTS1 labels that are missing and which are found ------------------
  nuts1_missings <- missing_nuts1_2016[which(missing_nuts1_2016 %in% incorrectly_labelled_nuts1_2013$geo)]

  found_nuts1 <- incorrectly_labelled_nuts1_2013 %>%
    filter(geo %in% missing_nuts1_2016)
  message(length(unique(found_nuts1$geo)), " incorrectly labelled NUTS1 regions could be re-labelled")

  ## Finding incorrectly labelled NUTS2 geo labels --------------------

  incorrectly_labelled_nuts2_2013 <- incorrectlly_labelled_nuts13 %>%
    filter(nchar(as.character(geo)) == 4) %>%
    select(-change) %>%
    left_join(nuts_correspondence %>%
      filter(nuts_level == 2) %>%
      rename(geo = code13) %>%
      filter(!is.na(geo)) %>%
      select(geo, code16, change, resolution),
    by = "geo"
    ) %>%
    filter(change != "discontinued") %>%
    mutate(problem_code = geo) %>%
    mutate(geo = code16)

  recoded_nuts2_2013 <- incorrectly_labelled_nuts2_2013 %>%
    filter(change == "recoded")

  found_nuts2 <- recoded_nuts2_2013 %>%
    filter(geo %in% missing_nuts2_2016)

  message(length(unique(found_nuts2$geo)), " incorrectly labelled NUTS2 regions could be re-labelled.")

  ## If there are no corrections to made at all, return the original data frame ------------
  if (length(unique(found_nuts2$geo)) + length(unique(found_nuts1$geo)) == 0) {
    message("There is no data found that can be further arranged.\nThe data is returned in its original format.")
    return(dat)
  }

  ## If there are changes to be made, make them from here ------------------
  join_by <- names(correctly_labelled_unchanged)
  join_by <- join_by[which(join_by %in% names(correctly_labelled_changed))]

  join_by2 <- names(correctly_labelled_unchanged)
  join_by2 <- join_by2[which(join_by2 %in% names(found_nuts1))]

  ## Add unchanged regions and changed, but correctly labelled ones
  so_far_joined <- full_join(correctly_labelled_unchanged,
    correctly_labelled_changed,
    by = join_by
  ) %>%
    full_join(found_nuts1, by = join_by2)

  ## Add NUTS1 regions that were recoded, if there are any
  if (nrow(found_nuts1) > 0) {
    join_by3 <- names(so_far_joined)
    join_by3 <- join_by3[which(join_by3 %in% names(found_nuts1))]

    so_far_joined <- so_far_joined %>%
      full_join(found_nuts2, by = join_by3)
  }


  ## Add NUTS2 regions that were recoded, if there are any
  if (nrow(found_nuts2) > 0) {
    join_by4 <- names(so_far_joined)
    join_by4 <- join_by3[which(join_by4 %in% names(found_nuts2))]

    so_far_joined <- so_far_joined %>%
      full_join(found_nuts2, by = join_by4)
  }


  remaining_eu_data <- tmp %>%
    filter(!geo %in% so_far_joined$geo)

  ## The following geo codes will be changed using rules -------------
  used_in_correction <- c(
    "FR24",
    "FR26", "FR43",
    "FR23", "FR25",
    "FR22", "FR30",
    "FR21", "FR41", "FR42",
    "FR51",
    "FR52",
    "FR53", "FR61", "FR63",
    "FR62", "FR81",
    "FR7",
    "FR82",
    "FR83",
    "FRA",
    "PL11", "PL33",
    "PL3",
    "PL12",
    "IE023", "IE024", "IE025",
    "LT00", "LT00A",
    "UKM2",
    "UKM31", "UKM34", "UKM35", "UKM36",
    "UKM24", "UKM32", "UKM33", "UKM37", "UKM38",
    "HU102", "HU101"
  )

  correct_with_correspondence <- remaining_eu_data %>%
    select(time, country_code, years, indicator, geo, values)

  if (any(correct_with_correspondence$geo %in% so_far_joined$geo)) {
    stop("There are overlaps with the already corrected dataset")
  }

  if (check_unique_values(correct_with_correspondence)) {
    stop("There were joining errors, please check correct_with_correspondence")
  }

  ## The data has time and space dimension, so corrections have to be
  ## made for each year in the dataset----------------------------
  correspondence_by_year <- function(df, this_time) {
    df <- df %>% filter(time == this_time)

    complete_with_missing <- tibble(
      geo = used_in_correction[which(!unique(used_in_correction) %in% df$geo)],
      country_code = case_when(
        substr(geo, 1, 2) == "UK" ~ "GB",
        substr(geo, 1, 2) == "EL" ~ "GR",
        TRUE ~ substr(geo, 1, 2)
      ),
      values = NA_real_,
      indicator = NA_character_,
      time = this_time,
      years = as.numeric(substr(as.character(this_time), 1, 4))
    )

    correct_with_correspondence <- df %>%
      full_join(., complete_with_missing,
        by = c(
          "indicator", "geo", "values", "years",
          "time", "country_code"
        )
      ) %>%
      fill(indicator) %>%
      spread(geo, values) %>%
      mutate(
        FRB = FR24,
        FRC = FR26 + FR43,
        FRD = FR23 + FR25,
        FRE = FR22 + FR30,
        FRF = FR21 + FR41 + FR42,
        FRG = FR51,
        FRH = FR52,
        FRI = FR53 + FR61 + FR63,
        FRJ = FR62 + FR81,
        FRK = FR7,
        FRL = FR82,
        FRM = FR83,
        FRY = FRA,
        LT02 = LT00 - LT00A,
        UKM7 = UKM2 - UKM24,
        UKM8 = UKM31 + UKM34 + UKM35 + UKM36,
        UKM9 = UKM24 + UKM32 + UKM33 + UKM37 + UKM38,
        PL7 = PL11 + PL33,
        PL8 = PL3 - PL33,
        PL9 = PL12,
        IE05 = IE023 + IE024 + IE025,
        HU11 = HU101,
        HU12 = HU102
      ) %>%
      gather(geo, corrected_values, -one_of("indicator", "country_code", "time", "years")) %>%
      filter(!is.na(corrected_values)) %>%
      filter(geo %in% c(missing_nuts1_2016, missing_nuts2_2016))

    correct_with_correspondence
  }

  for (t in seq_along(unique(correct_with_correspondence$time))) {
    this_time <- unique(correct_with_correspondence$time)[t]
    to_correct_by_year <- correct_with_correspondence %>%
      filter(time == this_time)
    if (t == 1) {
      corrected_with_correspondence <- correspondence_by_year(to_correct_by_year, this_time)
    } else {
      tmp <- correspondence_by_year(to_correct_by_year,
        this_time = this_time
      )
      if (is.null(tmp)) next
      if (!nrow(tmp) == 0) {
        corrected_with_correspondence <- full_join(
          corrected_with_correspondence, tmp,
          by = c(
            "time", "country_code", "years", "indicator",
            "geo", "corrected_values"
          )
        )
      }
    } # end of else
  } # end of loop

  check_unique_values(corrected_with_correspondence)

  incorrectly_labelled_unknown <- tmp3 %>%
    filter(!geo %in% c(changed_regions$code16, changed_regions$code13))

  if (nrow(incorrectly_labelled_unknown) > 0) {
    message("The following labels do not conform the NUTS2016 definition: ", paste(
      unique(incorrectly_labelled_unknown$geo),
      collapse = ","
    ))
    warning("Unknown labels found")
  }

  check_unique_values(so_far_joined)

  ### If there are duplications, they look like this
  dups <- so_far_joined %>%
    mutate(change = ifelse(is.na(change), "NA", change)) %>%
    select(geo, time, indicator, values, change) %>%
    add_count(geo, time, indicator) %>%
    filter(n > 1) %>%
    spread(change, values)
  ## If everything works well, you have two identical values vector, the
  ## original Eurostat values and the recoded values.

  names(corrected_with_correspondence)

  corrected_dataset <- so_far_joined %>%
    full_join(corrected_with_correspondence,
      by = c("geo", "time", "country_code", "years", "indicator")
    ) %>%
    fill(-one_of(c(
      "geo", "time", "country_code", "years", "country",
      "indicator", "change", "code16", "resolution",
      "problem_code", "corrected_values", "values"
    ))) %>%
    add_count(geo, time, indicator)

  duplications <- corrected_dataset %>%
    filter(n > 1)

  if (any(corrected_dataset$n > 1)) {
    message("Duplications occured, probably because of the relabelling.")
  }

  corrected_dataset2 <- corrected_dataset %>%
    select(-n) %>%
    ungroup() %>%
    filter(!is.na(change)) %>%
    distinct(geo, time, indicator, values, .keep_all = TRUE) %>%
    add_count(geo, time, indicator)

  if (any(corrected_dataset2$n > 1)) {
    # If the problem was only relabelling, you never end up here.
    # You can add here further exception handling code if you want.
    corrected_dataset2 <- corrected_dataset2 %>% rowid_to_column()

    duplications <- corrected_dataset2 %>% filter(n > 1)
    log_file_name <- paste0("log-", unique(duplications$indicator)[1], "-", Sys.Date(), ".rds")
    saveRDS(object = duplications, file = log_file_name)

    kept <- duplications %>% filter(is.na(change))
    not_kept <- duplications %>% filter(!is.na(change))

    corrected_dataset2 <- corrected_dataset2 %>%
      filter(!rowid %in% not_kept$rowid)

    corrected_dataset3 <- corrected_dataset2 %>%
      select(-n) %>%
      add_count(geo, time, indicator) %>%
      filter(n > 1)
    nrow(corrected_dataset3)

    corrected_dataset2 <- select(corrected_dataset2, -one_of("n", "rowid"))
    warning("The duplications could not be resolved fully, please review manually ", log_file_name, ".")
  } else {
    message("The duplications were resolved successfully.")
    corrected_dataset2 <- select(corrected_dataset2, -one_of("n"))
  }

  message("Corrections: ", paste(
    c(missing_nuts1_2016, missing_nuts2_2016)[c(missing_nuts1_2016, missing_nuts2_2016) %in% corrected_dataset$geo],
    collapse = ", "
  ))

  corrected_dataset2
}


check_spread <- function(dat) {
  dat %>%
    filter(indicator == unique(indicator)[1]) %>%
    select(geo, time, indicator, values) %>%
    spread(geo, values)
}

source("fill_forecast.R")
safely_check_spread <- purrr::safely(check_spread)
safely_fill_forecast <- purrr::safely(fill_forecast)
safely_fill_data_source <- purrr::safely(fill_data_source)
i <- 2
for (i in 1:length(regdata_files)) {
  message(i, ":", regdata_files[i])

  this_data <- readRDS(file.path("regdata", regdata_files[i]))
  corrected <- correct_nuts_labelling(this_data)
  test_results <- safely_check_spread(corrected)

  if (!is.null(test_results$error)) {
    warning("there is a problem with ", i, ": ", regdata_files[i])
    saveRDS(corrected, file.path("corrected", paste0("problems_", regdata_files[i])))
  } else {
    message("The data can be spread to wide format, saving...")
    saveRDS(corrected, file.path("corrected", paste0("corrected_", regdata_files[i])))
  }

  try_forecast <- safely_fill_data_source(corrected)
}
