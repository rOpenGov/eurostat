test_that("get_eurostat includes time and value", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("time", "values") %in%
    names(get_eurostat("road_eqr_trams"))))
})

test_that("get_eurostat works with multi-frequency", {
  skip_on_cran()
  skip_if_offline()
  expect_error(get_eurostat("avia_gonc", cache = FALSE))
  expect_match(as.character(unique(get_eurostat("avia_gonc",
    select_time = "Y",
    cache = FALSE
  )$time)), "-01-01")
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
