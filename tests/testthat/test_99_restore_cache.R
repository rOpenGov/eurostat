test_that("Restore user cache dir after testing", {
  skip_on_cran()
  skip_if_offline()

  # Clear test cache
  cat("Test cache was ", eur_helper_detect_cache_dir(), "\n")
  expect_message(clean_eurostat_cache(config = FALSE))

  user_dir <- Sys.getenv("TEST_EUROSTAT_CURRENT_CACHE")
  current_env <- Sys.getenv("EUROSTAT_CACHE_DIR")

  expect_false(current_env == user_dir)

  expect_message(expect_message(
    set_eurostat_cache_dir(user_dir)
  ))
  newcache <- suppressMessages(set_eurostat_cache_dir(user_dir))
  expect_equal(newcache, user_dir)
  expect_equal(user_dir, Sys.getenv("EUROSTAT_CACHE_DIR"))

  cat("Cache restored to ", Sys.getenv("EUROSTAT_CACHE_DIR"), "\n")
  
  eurostat:::clean_eurostat_toc()
})
