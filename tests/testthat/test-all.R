context("Get")

test_that("get_eurostat includes time and value",{
  skip_on_cran()
  expect_true(all(c("time", "values") %in%
                    names(get_eurostat("road_eqr_trams"))))
})

test_that("get_eurostat works with multi-frequency",{
  skip_on_cran()
  expect_error(get_eurostat("avia_gonc", cache = FALSE))
  expect_match(as.character(unique(get_eurostat("avia_gonc", select_time = "Y" , 
                                                cache = FALSE)$time)), "-01-01")
})

test_that("get_eurostat return right classes",{
  skip_on_cran()
  expect_true(all(c("factor", "numeric") %in%
                    sapply(get_eurostat("road_eqr_trams"), class)))
  expect_true(all(c("character", "numeric") %in%
                    sapply(get_eurostat("road_eqr_trams", stringsAsFactors = FALSE),
                           class)))
})

test_that("get_eurostat handles daily data", {
  skip_on_cran()
  skip_on_travis()    
  dat1 <- get_eurostat("ert_bil_eur_d", 
                       filters = list(currency = "ARS", statinfo ="AVG",
                                      time = c("2017M03D09", "2017M03D10")), 
                       time_format = "date", cache = FALSE)
  expect_equal(as.numeric(difftime(dat1$time[2], dat1$time[1], units = "days")), 1)
})


test_that("get_eurostat get non-normal variable order",{
  skip_on_cran()
  expect_gt(nrow(get_eurostat("cens_01rdhh")), 0)
})

context("cache")

test_that("Cache give error if cache dir does not exist", {
  skip_on_cran()
  expect_error(
    get_eurostat("nama_10_lp_ulc", cache_dir = file.path(tempdir(), "r_cache")))
})

test_that("Cache works", {
  skip_on_cran()
  expect_is({
    t_dir <- file.path(tempdir(), "reurostat")
    dir.create(t_dir)
    k <- get_eurostat("nama_10_lp_ulc", cache_dir = t_dir)
    },
    "data.frame")
})


context("Search")

test_that("search_eurostat finds",{
  skip_on_cran()
  expect_equal(search_eurostat(
    "Dwellings by type of housing, building and NUTS 3", type = "dataset")$code[1],
    "cens_01rdhh"
  )
})


context("Label")

test_that("Variable names are labeled",{
  skip_on_cran()
  expect_equal(label_eurostat_vars("geo"), "Geopolitical entity (reporting)")
  expect_equal(label_eurostat_vars("housing", lang = "fr"), "Habitation")

  expect_true(any(grepl("_code",
                        names(label_eurostat(
                          get_eurostat("road_eqr_trams"), code = "geo")))))
})

test_that("Label ordering is ordered", {
  skip_on_cran()
  expect_equal(c("European Union - 28 countries",
               "Finland", "United States"),
               levels(label_eurostat(factor(c("FI", "US", "EU28")),
                              dic = "geo", eu_order = TRUE)))
})


test_that("Countrycodes are labelled for factors", {
  expect_equal(levels(label_eurostat(factor(c("FI", "DE", "EU28"), c("FI", "DE", "EU28")), dic = "geo",
                                     countrycode = "country.name")),
               c("Finland", "Germany", "EU28"))
})

test_that("Countrycodes return NA for countrycode_nomatch = NA", {
  expect_equal(suppressWarnings(label_eurostat(c("FI", "DE", "EU28"), dic = "geo",
                              countrycode = "country.name", countrycode_nomatch = NA)),
               c("Finland", "Germany", NA))
})

test_that("Countrycodes use eurostat for missing", {
  expect_equal(suppressWarnings(label_eurostat(c("FI", "DE", "EU28"), dic = "geo",
                              countrycode = "country.name", countrycode_nomatch = "eurostat")),
               c("Finland", "Germany", "European Union - 28 countries"))
})

test_that("custom_dic works", {
  expect_equal(label_eurostat(c("FI", "DE"), dic = "geo", custom_dic = c(DE = "Germany")),
               c("Finland", "Germany"))
})

context("Misc")

test_that("Dic downloading works", {
  skip_on_cran()
  expect_warning(get_eurostat_dic("na_item"), NA)
})

test_that("Factors are retained in data.frame", {
  skip_on_cran()
  y <- label_eurostat(data.frame(unit = factor("EUR")))
  expect_is(y$unit, "factor")
})

test_that("Duplicated gives an error", {
  skip_on_cran()
  expect_error(label_eurostat(x = factor(c("P5G", "P5")), dic = "na_item"))
})

test_that("Duplicated with fix_duplicated does not give an error", {
  skip_on_cran()
  expect_match(as.character(
    label_eurostat(x = factor(c("P5G", "P5")), dic = "na_item", 
                              fix_duplicated = TRUE)), "P5", all = TRUE)
})

context("Flags")

#flag_dat <- get_eurostat("t2020_rk310", type = "label", keepFlags=T, cache = FALSE)
#flag_dat <- get_eurostat("tsdtr210", type = "label", keepFlags=T, cache = FALSE)
flag_dat <- get_eurostat("road_pa_buscoa", type = "label", keepFlags=T, cache = FALSE)


test_that("get_eurostat includes flags",{
  skip_on_cran()
  expect_true(all(c("flags") %in%
                    names(get_eurostat("road_eqr_trams", keepFlags = TRUE))))
})

test_that("keepFlags + label as in #61",{
  skip_on_cran()
  expect_true(all(c("flags") %in%
                    names(flag_dat)))
})

test_that("flag content",{
  skip_on_cran()
  expect_true(all(c("b", "e") %in%
              unique(flag_dat$flags)))
})

context("json")

test_that("Get json data",{
  skip_on_cran()
  skip_on_travis()    
  expect_named(get_eurostat_json("nama_10_gdp", filters = list(geo = "FI",
                                                               na_item = "B1GQ",
                                                               unit = "CLV_I10")),
               c("geo", "unit", "na_item", "time", "values"), 
               ignore.order = TRUE)
})

test_that("Handle numbers in filter name",{
  skip_on_cran()
  skip_on_travis()  
  expect_named(get_eurostat(id = "sts_inpr_a", filters = list(geo = "AT",
                                                              nace_r2 = "B",
                                                              s_adj = "CA",
                                                              indic_bt = "PROD",
                                                              unit = "I10")),
               c("geo", "nace_r2", "s_adj", "indic_bt", "unit", "time", "values"), 
               ignore.order = TRUE)
})


context("bibliography")

test_that("Bibentry gives correct results",{
  skip_on_cran()
  skip_on_travis()  
  expect_equal(
    class (get_bibentry ( code = c("sts_inpr_a", "nama_10_gdp"),
                          keywords = list ( c("production", "industry"),
                                            c("GDP")
                          ),
                          format = "Biblatex")), 
    "Bibtex"
  )
  expect_error(
    get_bibentry( code = 123456))
  expect_warning(
    get_bibentry( code = c("sts_inpr_a", "nama_10_gdp"),
                  keywords = list ( c("production", "industry"),
                                    c("GDP")
                  ),
                  format = "character"))
})

