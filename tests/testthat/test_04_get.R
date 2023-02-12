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
  # sleep for a while to let the API rest
  Sys.sleep(5)
})

test_that("get_eurostat (bulk download) produces an error with multiple select_time", {
  skip_on_cran()
  skip_if_offline()
  expect_error(get_eurostat(id = "avia_gonc",
                            select_time = c("A", "M", "Q"),
                            time_format = "date_last",
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
  # sleep for a while to let the API rest
  Sys.sleep(5)
})

test_that("get_eurostat (dissemination API) works correctly with multi-frequency", {
  skip_on_cran()
  skip_if_offline()
  expect_message(get_eurostat("avia_gonc", 
                              cache = FALSE,
                              time_format = "date_last",
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
  expect_true("S" %in% get_eurostat("earn_mw_cur", 
                                    legacy_bulk_download = FALSE)$freq)
})

test_that("eurostat2num (bulk download) works correctly", {
  skip_on_cran()
  skip_if_offline()
  expect_true(is.numeric(get_eurostat("earn_mw_cur", 
                                      time_format = "num", 
                                      legacy_bulk_download = TRUE)$time)
  )
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
                   legacy_bulk_download = FALSE)$TIME_PERIOD
      )
    )
})

test_that("weekly dataset download (dissemination API) works correctly", {
  skip_on_cran()
  skip_if_offline()
  expect_match(
    get_eurostat(id = "lfsi_abs_w", 
                 select_time = c("W"), 
                 time_format = "date", 
                 legacy_bulk_download = FALSE)$freq[1], "W")
})

test_that("get_eurostat get non-normal variable order", {
  skip_on_cran()
  skip_if_offline()
  expect_gt(nrow(get_eurostat("cens_01rdhh")), 0)
})
