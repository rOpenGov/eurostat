test_that("Save user cache for test", {
  skip_on_cran()
  skip_if_offline()

  # Get current cache dir
  Sys.setenv("TEST_EUROSTAT_CURRENT_CACHE" = eur_helper_detect_cache_dir())

  cat("User cache dir is ", Sys.getenv("TEST_EUROSTAT_CURRENT_CACHE"), "\n")

  testdir <- file.path(tempdir(), "eurostat", "testthat")
  # Set a temp cache dir
  expect_message(set_eurostat_cache_dir(testdir))

  cat("Testing cache dir is ", Sys.getenv("EUROSTAT_CACHE_DIR"), "\n")
})

test_that("Cache is ok if cache dir does not exist", {
  skip_on_cran()
  skip_if_offline()
  k <- get_eurostat("nama_10_lp_ulc")

  expect_true(inherits(k, "data.frame"))
})

test_that("Cache works", {
  skip_on_cran()
  skip_if_offline()

  t_dir <- file.path(tempdir(), "reurostat")
  k <- get_eurostat("nama_10_lp_ulc", cache_dir = t_dir)
  expect_true(inherits(k, "data.frame"))
})

test_that("Dataset is filtered from cached bulk file", {
  skip_on_cran()
  skip_if_offline()
  
  t_dir <- file.path(tempdir(), "reurostat")
  k2 <- get_eurostat("nama_10_lp_ulc", 
                     cache_dir = t_dir, 
                     filters = list())
  expect_message(get_eurostat("nama_10_lp_ulc", 
                              cache_dir = t_dir, 
                              filters = list(geo = "AT")), "and filtering it")
  
})

test_that("Set cache", {
  old <- eur_helper_detect_cache_dir()
  new <- file.path(tempdir(), "eurostat", "testthat", "new")
  expect_message(set_eurostat_cache_dir(new))

  set_eurostat_cache_dir(old)
})
