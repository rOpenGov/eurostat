
context("Get")

test_that("get_eurostat includes time and value",{
  skip_on_cran()
  expect_true(all(c("time", "values") %in%
                    names(get_eurostat("namq_aux_lp"))))
})

test_that("get_eurostat works with multi-frequency",{
  skip_on_cran()
  expect_error(get_eurostat("avia_gonc", cache = FALSE))
  matches("-01-01", unique(get_eurostat("avia_gonc", select_time = "Y" , cache = FALSE)$time))
})

test_that("get_eurostat return right classes",{
  skip_on_cran()
  expect_true(all(c("factor", "numeric") %in%
                    sapply(get_eurostat("namq_aux_lp"), class)))
  expect_true(all(c("character", "numeric") %in%
                    sapply(get_eurostat("namq_aux_lp", stringsAsFactors = FALSE),
                           class)))
})

test_that("get_eurostat handles daily data", {
  skip_on_cran()
  dat <- get_eurostat("ert_bil_eur_d", time_format = "date", cache = FALSE)
  dat1 <- subset(dat, currency == "ARS")
  expect_equal(abs(as.numeric(difftime(dat1$time[1], dat1$time[2], units = "days"))), 1)
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
  expect_equal(label_eurostat_vars("indic_na", lang = "fr"), 
               "Indicateur des comptes nationaux")
  expect_true(any(grepl("_code",
                        names(label_eurostat(
                          get_eurostat("namq_aux_lp"), code = "geo")))))
})

test_that("Label ordering is ordered", {
  skip_on_cran()
  expect_equal(c("European Union (28 countries)", "Finland", "United States"),
               levels(label_eurostat(factor(c("FI", "US", "EU28")),
                              dic = "geo", eu_order = TRUE)))
})


context("Flags")

test_that("get_eurostat includes flags",{
  skip_on_cran()
  expect_true(all(c("flags") %in%
                    names(get_eurostat("namq_aux_lp", keepFlags = TRUE))))
})

test_that("flags contain some confidential flagged fields",{
  skip_on_cran()
  expect_true(c("c") %in%
              unique(get_eurostat("naio_10_cp1620", keepFlags = TRUE)$flags))
})

context("json")

test_that("Get json data",{
  skip_on_cran()
  expect_named(get_eurostat_json("nama_gdp_c", filters = list(geo=c("EU28", "FI"), 
                                                             unit="EUR_HAB",
                                                             indic_na="B1GM")),
               c("geo", "unit", "indic_na", "time", "values"), 
               ignore.order = TRUE)
})

