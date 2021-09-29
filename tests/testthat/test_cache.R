context("cache")


# Get current cache dir
Sys.setenv("TEST_EUROSTAT_CURRENT_CACHE" = eur_helper_detect_cache_dir())

cat("User cache dir is ", Sys.getenv("TEST_EUROSTAT_CURRENT_CACHE"), "\n")

# Set a temp cache dir
set_eurostat_cache_dir(file.path(tempdir(), "eurostat", "testthat"))

cat("Testing cache dir is ", Sys.getenv("EUROSTAT_CACHE_DIR"), "\n")


test_that("Cache is ok if cache dir does not exist", {
  skip_on_cran()
  k <- get_eurostat("nama_10_lp_ulc")

  expect_true(inherits(k, "data.frame"))
})

test_that("Cache works", {
  skip_on_cran()

  t_dir <- file.path(tempdir(), "reurostat")
  k <- get_eurostat("nama_10_lp_ulc", cache_dir = t_dir)
  expect_true(inherits(k, "data.frame"))
})

test_that("Set cache", {
  old <- eur_helper_detect_cache_dir()
  new <- file.path(tempdir(), "eurostat", "testthat", "new")
  expect_message(set_eurostat_cache_dir(new))

  set_eurostat_cache_dir(old)
})
