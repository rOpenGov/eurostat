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
  expect_equal(c("European Union - 28 countries (2013-2020)",
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
               c("Finland", "Germany", "European Union - 28 countries (2013-2020)"))
})

test_that("custom_dic works", {
  expect_equal(label_eurostat(c("FI", "DE"), dic = "geo", custom_dic = c(DE = "Germany")),
               c("Finland", "Germany"))
})

