test_that("get_eurostat (dissemination API) includes TIME_PERIOD and value", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("TIME_PERIOD", "values") %in%
                    names(get_eurostat(id = "road_eqr_trams",
                                       stringsAsFactors = TRUE,
                                       select_time = "A"))))
})

test_that("get_eurostat (dissemination API) includes TIME_PERIOD and value", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("TIME_PERIOD", "values") %in%
                    names(get_eurostat(id = "road_eqr_trams",
                                       stringsAsFactors = TRUE,
                                       select_time = "Y"))))
  # sleep for a while to let the API rest
  Sys.sleep(5)
})

test_that("get_eurostat (dissemination API) produces a message with multiple select_time", {
  skip_on_cran()
  skip_if_offline()
  expect_message(get_eurostat(id = "avia_gonc",
                              select_time = c("A", "M", "Q")))
})

test_that("get_eurostat (dissemination API) produces an error with imaginary select_time parameters", {
  skip_on_cran()
  skip_if_offline()
  expect_error(get_eurostat(id = "avia_gonc",
                              select_time = c("X", "Y", "Z")))
  # sleep for a while to let the API rest
  Sys.sleep(5)
})

test_that("get_eurostat (dissemination API) works correctly with multi-frequency", {
  skip_on_cran()
  skip_if_offline()
  expect_message(get_eurostat("avia_gonc", 
                              cache = FALSE,
                              time_format = "date_last")
                 )
  expect_match(as.character(unique(get_eurostat("avia_gonc",
                                                select_time = NULL,
                                                cache = FALSE)$TIME_PERIOD)), 
               "-01-01")
})

test_that("get_eurostat return right classes", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("character", "numeric", "Date") %in%
    sapply(get_eurostat("road_eqr_trams"), class)))
  expect_true(all(c("character", "numeric", "Date") %in%
    sapply(
      get_eurostat("road_eqr_trams", keepFlags = TRUE),
      class
    )))
})

test_that("bi-annual data contains freq S", {
  skip_on_cran()
  skip_if_offline()
  expect_true("S" %in% get_eurostat("earn_mw_cur")$freq)
  # sleep for a while to let the API rest
  Sys.sleep(5)
})


test_that("eurostat2num2 (dissemination API) works correctly", {
  skip_on_cran()
  skip_if_offline()
  expect_true(
    is.numeric(
      get_eurostat(id = "earn_mw_cur", 
                   time_format = "num",
                   use.data.table = TRUE)$TIME_PERIOD
      )
    )
})

test_that("weekly dataset download (dissemination API) works correctly", {
  skip_on_cran()
  skip_if_offline()
  expect_match(
    get_eurostat(id = "lfsi_abs_w", 
                 select_time = c("W"), 
                 time_format = "date")$freq[1], "W")
})

test_that("get_eurostat get non-normal variable order", {
  skip_on_cran()
  skip_if_offline()
  expect_gt(nrow(get_eurostat("cens_01rdhh")), 0)
})

test_that("get_eurostat and eurotime2date work with daily data", {
  skip_on_cran()
  skip_if_offline()
  expect_match(get_eurostat("irt_h_eurcoe_d",
                            filters = list(lastTimePeriod = 5))$freq[1], "D")
})

test_that("get_eurostat and eurotime2num work with daily data", {
  skip_on_cran()
  skip_if_offline()
  # Downloading daily data with time_format = "num" produces a warning
  # suppressWarnings is here to suppress that
  expect_match(suppressWarnings(get_eurostat("irt_h_eurcoe_d",
                            filters = list(lastTimePeriod = 5),
                            time_format = "num"))$freq[1], "D")
})

test_that("get_eurostat and eurotime2num work with daily data", {
  skip_on_cran()
  skip_if_offline()
  expect_match(get_eurostat("ei_bsci_m_r2",
                            filters = list(lastTimePeriod = 5),
                            time_format = "num")$freq[1], "M")
})

test_that("get_eurostat and eurotime2num work with daily data", {
  skip_on_cran()
  skip_if_offline()
  expect_match(get_eurostat("med_ag32",
                            filters = list(lastTimePeriod = 5),
                            time_format = "num")$freq[1], "A")
})
