test_that("get_eurostat (bulk download) includes time and value", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("time", "values") %in%
    names(get_eurostat("road_eqr_trams",
                       select_time = "Y",
                       stringsAsFactors = TRUE))))
})

test_that("get_eurostat (dissemination API) includes TIME_PERIOD and value", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("TIME_PERIOD", "values") %in%
                    names(get_eurostat(id = "road_eqr_trams",
                                       stringsAsFactors = TRUE,
                                       select_time = "A",
                                       legacy_bulk_download = FALSE))))
})

test_that("get_eurostat (dissemination API) includes TIME_PERIOD and value", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("TIME_PERIOD", "values") %in%
                    names(get_eurostat(id = "road_eqr_trams",
                                       stringsAsFactors = TRUE,
                                       select_time = "Y",
                                       legacy_bulk_download = FALSE))))
})

test_that("get_eurostat (bulk download) produces an error with multiple select_time", {
  skip_on_cran()
  skip_if_offline()
  expect_error(get_eurostat(id = "avia_gonc",
                              select_time = c("A", "M", "Q"),
                              legacy_bulk_download = TRUE))
})

test_that("get_eurostat (dissemination API) produces a message with multiple select_time", {
  skip_on_cran()
  skip_if_offline()
  expect_message(get_eurostat(id = "avia_gonc",
                              select_time = c("A", "M", "Q"),
                              legacy_bulk_download = FALSE))
})

test_that("get_eurostat (dissemination API) produces an error with imaginary select_time parameters", {
  skip_on_cran()
  skip_if_offline()
  expect_error(get_eurostat(id = "avia_gonc",
                              select_time = c("X", "Y", "Z"),
                              legacy_bulk_download = FALSE))
})

test_that("get_eurostat (bulk download) works correctly with multi-frequency", {
  skip_on_cran()
  skip_if_offline()
  expect_error(get_eurostat("avia_gonc", cache = FALSE))
  expect_match(as.character(unique(get_eurostat("avia_gonc",
    select_time = "Y",
    cache = FALSE
  )$time)), "-01-01")
})

test_that("get_eurostat (dissemination API) works correctly with multi-frequency", {
  skip_on_cran()
  skip_if_offline()
  expect_message(get_eurostat("avia_gonc", 
                              cache = FALSE, 
                              legacy_bulk_download = FALSE)
                 )
  expect_match(as.character(unique(get_eurostat("avia_gonc",
                                                select_time = NULL,
                                                cache = FALSE,
                                                legacy_bulk_download = FALSE)$TIME_PERIOD)), 
               "-01-01")
})

test_that("get_eurostat return right classes", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("character", "numeric") %in%
    sapply(get_eurostat("road_eqr_trams"), class)))
  expect_true(all(c("character", "numeric") %in%
    sapply(
      get_eurostat("road_eqr_trams"),
      class
    )))
})

test_that("bi-annual data contains freq S", {
  skip_on_cran()
  skip_if_offline()
  expect_true("S" %in% get_eurostat("earn_mw_cur", legacy_bulk_download = FALSE)$freq)
})

# The following test produced an error on R-Studio R CMD check:
# Error: 'length(x) = 3 > 1' in coercion to 'logical(1)'
# Backtrace: 1. eurostat::get_eurostat(...) test_get.R:29:2
# Probably has something to do with usage of || (scalar comparison)
# in functions instead of using | (vector comparison), will look into it
# test_that("get_eurostat handles daily data", {
#  skip_on_cran()
#  skip_on_ci()
#  dat1 <- get_eurostat("ert_bil_eur_d",
#                       filters = list(currency = "ARS",
#                                      statinfo ="AVG",
#                                      time = c("2017M03D09", "2017M03D10")),
#                       time_format = "date", cache = FALSE)
#  time <- as.numeric(difftime(dat1$time[2], dat1$time[1], units = "days"))
#  expect_identical(time, 1)
# })


test_that("get_eurostat get non-normal variable order", {
  skip_on_cran()
  skip_if_offline()
  expect_gt(nrow(get_eurostat("cens_01rdhh")), 0)
})
